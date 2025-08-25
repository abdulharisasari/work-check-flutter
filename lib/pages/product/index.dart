import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/product_model.dart';
import 'package:workcheckapp/models/promo_model.dart';
import 'package:workcheckapp/providers/product_provider.dart';
import 'package:workcheckapp/providers/promo_provider.dart';
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
  late final LocalOfflineDatabase<PromoModel> promoDb;


  @override
  void initState() {
    promoDb = LocalOfflineDatabase<PromoModel>(
      boxName: 'promo_offline',
      fromJson: (json) => PromoModel.fromJson(json),
      toJson: (promo) => promo.toJson(),
    );


    _init();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPendingPromos();

    });
    
  }


  Future<void> _syncPendingPromos() async {
    final promoProvider = Provider.of<PromoProvider>(context, listen: false);
    final pending = await promoDb.getPendingItems();

    for (var promo in pending) {
      try {
        final success = await promoProvider.createProductPromo(context, promo, widget.outletModel.id!).timeout(const Duration(seconds: 2));

        if (success?.code == 200) {
          await promoDb.removeItem(promo.hashCode);
        }
      } catch (e) {
        debugPrint("Gagal sinkronisasi promo: $e");
      }
    }
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
    listProduct.clear();
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    print("select OutletId : ${widget.outletModel.id}");
    try {
      final _productState = await productProv.getProduct(context, "${widget.outletModel.id}", search: _searchTC.text).timeout(const Duration(seconds: 2));

      if (_productState != null) {
        setState(() {
          listProduct = _productState;
        });
      }
    } on TimeoutException catch (_) {
      debugPrint('Request timeout setelah 2 detik');
      showSnackBar(context, "Jaringan offline. Silakan nyalakan koneksi internet.");

      
    } catch (e) {
      debugPrint('Error in getHeaderProduct: $e');
    }
  }



  Future<void> _selectedProduct(List<ProductModel> listProduct) async {
    setState(() {});
    final productProv = await Provider.of<ProductProvider>(context, listen: false);
    try {
      final response = await productProv.createProductSelect(context, listProduct, widget.outletModel.id);
      if (response != null && response.code == 200) {
        showSnackBar(context, response.message, backgroundColor: Color(mintGreenColor));
      } else {
        showSnackBar(context, "${response?.message}");
      }
    } catch (e) {
      debugPrint('Error in _selectedProduct: $e');
    }
    return null;
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