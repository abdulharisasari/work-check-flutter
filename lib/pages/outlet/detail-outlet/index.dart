import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_banner.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/product_model.dart';
import 'package:workcheckapp/models/promo_model.dart';
import 'package:workcheckapp/providers/product_provider.dart';
import 'package:workcheckapp/providers/promo_provider.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workcheckapp/services/utils.dart';

class DetailOutletPage extends StatefulWidget {
  final OutletModel outletModel;
  const DetailOutletPage({super.key, required this.outletModel});

  @override
  State<DetailOutletPage> createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {
  final TextEditingController _searchTC = TextEditingController();
  final TextEditingController _nameProductTC = TextEditingController();
  final TextEditingController _priceNormalTC = TextEditingController();
  final TextEditingController _pricePromoTC = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  final Set<int> selectedIndexes = {};
  List<ProductModel> listProduct = [];

  bool _isPromo = false;

  File? _imageFile;
  String? _pathImage;

  int _selectedPageProduct = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    _nameProductTC.clear();
    _searchTC.clear();
    _priceNormalTC.clear();
    _pricePromoTC.clear();
    _pathImage = null;
    _imageFile = null;
    _isPromo = widget.outletModel.promoAvailable == 1? true: false;
    await _getHeaderProduct();

    for (int i = 0; i < listProduct.length; i++) {
    if (listProduct[i].availableStock == 1) {
      selectedIndexes.add(i);
    }}
  }

  Future<void> _getHeaderProduct() async {

    listProduct.clear();
    final productProv = await Provider.of<ProductProvider>(context, listen: false);
    print("select OutletId : ${widget.outletModel.id}");
    try {
      final _productState = await productProv.getProduct(context, "${widget.outletModel.id}", search: _searchTC.text);
      if (_productState != null) {
        setState(() {
          listProduct = _productState;
        });
      }
    } catch (e) {
      debugPrint('Error in getHeaderAttandance: $e');
    } 
  }

  Future<void> _selectedProduct(List<ProductModel> listProduct) async {
    setState(() {
    });
    final productProv = await Provider.of<ProductProvider>(context, listen: false);
    try {
      final response = await productProv.createProductSelect(context, listProduct,widget.outletModel.id);
      if (response != null && response.code == 200) {
        showSnackBar(context, response.message, backgroundColor: Color(mintGreenColor));
      } else{
        showSnackBar(context, "${response?.message}");
      }
    } catch (e) {
      debugPrint('Error in _selectedProduct: $e');
    }return null;
  }



  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;
    } else {
      final status = await Permission.photos.request();
      if (!status.isGranted) return;
    }

    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _pathImage = pickedFile.path; 
      });
    }
  }

  Future<void> _addPromo() async{
    setState(() {
    });
     if (_nameProductTC.text.isEmpty || _priceNormalTC.text.isEmpty || _priceNormalTC.text.isEmpty ) {
      showSnackBar(context, "Harap isi semua kolom");
      return;
    }
    final promoProv = Provider.of<PromoProvider>(context, listen: false);
    final base64Image = await Utils.convertImageToSmallBase64(_pathImage!);
    final promoModel = PromoModel(imageUrl: base64Image, nameProduct: _nameProductTC.text, priceNormal: int.tryParse(_priceNormalTC.text), pricePromo: int.tryParse(_pricePromoTC.text));
    try {
      final response = await promoProv.createProductPromo(context, promoModel, widget.outletModel.id!);
      if (response?.code == 200) {
        showSnackBar(context, response?.message??'', backgroundColor: Color(mintGreenColor));
         _init();
         setState(() {
           _selectedPageProduct = 0;
         });
      }else if(response?.code == 400){
        showSnackBar(context,response?.message??"Gagal nambah Promo");
      }else{
        showSnackBar(context,response?.message??"Gagal Nambah Promo" );
      }
    } catch (e) {
      debugPrint("Error in _addPromo : $e");
      showSnackBar(context, 'Gagal mengirim absen. Silakan coba lagi.');
    }finally{
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async {
          _init();
        },
        child: Column(
          children: [
            BannerWidget(
              title: "Detail Toko",
              onBack: () => Navigator.pop(context),
              addWidget: _buildDetailOutlet(),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(softGreyColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPageProduct = 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedPageProduct == 0 ? Color(secondaryColor) : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(icProduct, height: 20,color: _selectedPageProduct == 0 ? Colors.white : Color(primaryColor),),
                                  Text(
                                    "Produk",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: _selectedPageProduct == 0 ? Colors.white : Color(primaryColor),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _selectedPageProduct = 1; _init();}),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedPageProduct == 1 ? Color(secondaryColor) : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(icPromo, height: 20, color: _selectedPageProduct == 1 ? Colors.white : Color(primaryColor),),
                                  Text(
                                    "Promo",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: _selectedPageProduct == 1 ? Colors.white : Color(primaryColor),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _selectedPageProduct == 0 ? _buildProduct() : _buildPromo(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromo() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child:Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 225,
                  height: 150,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8), image: _imageFile == null ? null : DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)),
                  child: _imageFile == null ? Icon(Icons.image, size: 50, color: Colors.grey[700]) : null,
                ),
                Positioned(
                  bottom: -4,
                  right: -10,
                  child: ClipOval(
                    child: Material(
                      color: Colors.black45,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.add_a_photo, color: Colors.white),
                        onSelected: (value) {
                          switch (value) {
                            case 'camera':
                              _pickImage(ImageSource.camera);
                              break;
                            case 'gallery':
                              _pickImage(ImageSource.gallery);
                              break;
                            case 'view':
                              if (_imageFile != null) {
                                showDialog(context: context, builder: (_) => Dialog(child: Image.file(_imageFile!)));
                              }
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'camera', child: Text('Camera')),
                          PopupMenuItem(value: 'gallery', child: Text('Gallery')),
                          if (_imageFile != null) PopupMenuItem(value: 'view', child: Text('View')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomTextField(label: "Nama Produk", controller: _nameProductTC),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Normal", controller: _priceNormalTC, keyBoardNumber: true),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Promo", controller: _pricePromoTC,keyBoardNumber: true),
            SizedBox(height: 20),
            CustomButton(text: "TAMBAHKAN PROMO",isEnabled: _isPromo, onPressed: ()async {await _addPromo();})
          ],
        ),
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
                  labelTitle: "Nama",
                  labelSubtitle1: "Harga",
                  
                  title: "${product.name ?? "-"}",
                  subtitle1: "${product.price ?? "-"}",
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

  Widget _buildDetailOutlet() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 200,
        child: Row(
          children: [
            Container(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Nama Toko", style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                  Text("Kode", style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                  Text("Alamat", style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(": ${widget.outletModel.name}", style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                  Text(": ${widget.outletModel.codeOutlet}", style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                  Text(": ${widget.outletModel.address}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Color(pureWhiteColor))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
