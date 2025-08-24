import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/product_model.dart';
import 'package:workcheckapp/providers/product_provider.dart';
import 'package:workcheckapp/services/db_local.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';

class ProductPage extends StatefulWidget {
  final OutletModel outletModel;
  const ProductPage({super.key, required this.outletModel});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchTC = TextEditingController();
  final Set<int> selectedIndexes = {};
  List<ProductModel> listProduct = [];
  late final LocalOfflineDatabase<ProductModel> productDb;
  bool _isLoading = false;

  @override
  void initState() {
    productDb = LocalOfflineDatabase<ProductModel>(
      boxName: 'product_offline',
      fromJson: (json) => ProductModel.fromJson(json),
      toJson: (product) => product.toJson(),
    );

    _init();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPendingSelectedProducts();
    });
  }

  void _init() async {
    _searchTC.clear();
    await _getHeaderProduct();

    selectedIndexes.clear();
    for (int i = 0; i < listProduct.length; i++) {
      if (listProduct[i].availableStock == 1) {
        selectedIndexes.add(i);
      }
    }
  }

  Future<void> _getHeaderProduct() async {
    setState(() {
      _isLoading = true;
    });
    final productProv = Provider.of<ProductProvider>(context, listen: false);

    try {
      final remoteProducts = await productProv.getProduct(context, "${widget.outletModel.id}", search: _searchTC.text).timeout(const Duration(seconds: 2));

      if (remoteProducts != null && remoteProducts.isNotEmpty) {
        await productDb.clearAll();
        for (var p in remoteProducts) {
          await productDb.addItem(p);
        }

        setState(() {
          listProduct = remoteProducts;
          _isLoading = false;
        });
        
        return;
      }
    } on TimeoutException {
      debugPrint("⏱ Timeout ambil produk, pakai offline");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("⚠️ Gagal ambil produk dari server: $e");
      setState(() {
        _isLoading = false;
      });
    }

    final localProducts = await productDb.getPendingItems();
    setState(() {
      listProduct = localProducts;
      _isLoading = false;
    });
  }

  // Future<void> _selectedProduct(List<ProductModel> listProduct) async {
  //   setState(() {});
  //   final productProv = await Provider.of<ProductProvider>(context, listen: false);
  //   try {
  //     final response = await productProv.createProductSelect(context, listProduct, widget.outletModel.id);
  //     if (response != null && response.code == 200) {
  //       showSnackBar(context, response.message, backgroundColor: Color(mintGreenColor));
  //     } else {
  //       showSnackBar(context, "${response?.message}");
  //     }
  //   } catch (e) {
  //     debugPrint('Error in _selectedProduct: $e');
  //   }
  //   return null;
  // }

  Future<void> _selectedProduct(List<ProductModel> listProduct) async {
  final productProv = Provider.of<ProductProvider>(context, listen: false);

  try {
    final response = await productProv
        .createProductSelect(context, listProduct, widget.outletModel.id)
        .timeout(const Duration(seconds: 2));

    if (response != null && response.code == 200) {
      showSnackBar(context, response.message, backgroundColor: Color(mintGreenColor));
      // ✅ Hapus data pending di local (kalau ada)
      await productDb.clearAll();
    } else {
      // ⬇️ Simpan ke local biar nanti sync
      for (var product in listProduct) {
        await _saveOfflineIfNotExists(product);
      }
      showSnackBar(context, response?.message ?? "Produk disimpan offline");
    }
  } on TimeoutException {
    // ⏱ Timeout → simpan ke offline
    for (var product in listProduct) {
      await _saveOfflineIfNotExists(product);
    }
    showSnackBar(context, "Timeout. Produk disimpan offline.");
  } catch (e) {
    debugPrint("Error in _selectedProduct: $e");
    for (var product in listProduct) {
      await _saveOfflineIfNotExists(product);
    }
    showSnackBar(context, "Gagal mengirim produk. Disimpan offline.");
  }
}

/// 🔄 Sync otomatis produk yang belum terkirim
Future<void> _syncPendingSelectedProducts() async {
  final productProv = Provider.of<ProductProvider>(context, listen: false);
  final pendingProducts = await productDb.getPendingItems();

  for (var product in pendingProducts) {
    try {
      final response = await productProv
          .createProductSelect(context, [product], widget.outletModel.id)
          .timeout(const Duration(seconds: 2));

      if (response != null && response.code == 200) {
        await productDb.removeItem(product.hashCode);
      }
    } catch (e) {
      debugPrint("Gagal sync produk: $e");
    }
  }
}

/// 🔒 Helper: biar ga nyimpen item duplikat
Future<void> _saveOfflineIfNotExists(ProductModel product) async {
  final pending = await productDb.getPendingItems();
  final exists = pending.any((p) => p.id == product.id);
  if (!exists) {
    await productDb.addItem(product);
  }
}


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _init();
      },
      child: Scaffold(
        body: _isLoading?Center(child: CircularProgressIndicator()): _buildProduct()
      ),
    );
  }

  Widget _buildProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CustomTextField(label: "", hintext: "Search ...",controller: _searchTC,onChanged: (p0) { _getHeaderProduct();},  logo: const Icon(Icons.search_rounded, size: 26, color: Color(tealBreezeColor))),
          Expanded(
            child: ListView.builder(
              itemCount: listProduct.length,
              itemBuilder: (context, index) {
                final product = listProduct[index];
                final isSelected =  selectedIndexes.contains(index);
                return CustomListItem(
                  labelWidth: 140,
                  labelTitle: "${product.name ?? "-"}",
                  labelSubtitle1: "${product.volume}",
                  imageUrl: "${product.imgUrl ?? "-"}",
                  barcode: "${product.codeBarcode}",
                  selectable: true,
                  isSelected: isSelected,
                  onSelectedChanged: (selected) {
                    setState(() {
                      if (selected == true) {
                        selectedIndexes.add(index);
                      } else {
                        selectedIndexes.remove(index);
                      }
                    });
                  },
                  onTap: () {},
                );
              },
            ),
          ),
          CustomButton(
              text: "SIMPAN",
              onPressed: ()async {
               final List<ProductModel> select = listProduct.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final isSelected = selectedIndexes.contains(index);
                  return ProductModel(id: product.id, availableStock: isSelected ? 1 : 0);
                }).toList();
               await _selectedProduct(select);
              })
        ],
      ),
    );
  }
}