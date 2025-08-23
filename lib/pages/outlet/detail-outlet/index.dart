import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:workcheckapp/commons/widgets/custom_banner.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/product_model.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailOutletPage extends StatefulWidget {
  final OutletModel outletModel;
  const DetailOutletPage({super.key, required this.outletModel});

  @override
  State<DetailOutletPage> createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {
  int selectedIndex = 0;
  final Set<int> selectedIndexes = {};
  List<ProductModel> listProduct = [
    ProductModel(
      id: 1,
      name: "Sepatu Sneakers",
      price: 500000,
      pricePromo: 450000,
      imgUrl: "https://via.placeholder.com/150",
      codeBarcode: "1234567890123",
    ),
    ProductModel(
      id: 2,
      name: "Kaos Polo",
      price: 150000,
      pricePromo: 120000,
      imgUrl: "https://via.placeholder.com/150",
      codeBarcode: "234567uuuuuu8901234",
    ),
    ProductModel(
      id: 3,
      name: "Celana Jeans",
      price: 300000,
      pricePromo: 250000,
      imgUrl: "https://via.placeholder.com/150",
      codeBarcode: "3456789012345",
    ),
    ProductModel(
      id: 4,
      name: "Topi Baseball",
      price: 80000,
      pricePromo: 65000,
      imgUrl: "https://via.placeholder.com/150",
      codeBarcode: "4567890123456",
    ),
  ];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          onTap: () => setState(() => selectedIndex = 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIndex == 0 ? Color(secondaryColor) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Produk",
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedIndex == 0 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedIndex = 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIndex == 1 ? Color(secondaryColor) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Promo",
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedIndex == 1 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: selectedIndex == 0 ? _buildProduct() : _buildPromo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromo() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
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
            CustomTextField(label: "Nama Produk"),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Normal"),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Promo"),
            SizedBox(height: 20),
            CustomButton(text: "TAMBAHKAN PROMO", onPressed: () {})
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
          CustomTextField(label: "", hintext: "Search ...", logo: const Icon(Icons.search_rounded, size: 26, color: Color(tealBreezeColor))),
          Expanded(
            child: ListView.builder(
              itemCount: listProduct.length,
              itemBuilder: (context, index) {
                final product = listProduct[index];
                final isSelected = selectedIndexes.contains(index);
                return CustomListItem(
                  labelTitle: "Nama",
                  labelSubtitle1: "Harga",
                  labelSubtitle2: "Promo",
                  title: "${product.name ?? "-"}",
                  subtitle1: "${product.price ?? "-"}",
                  subtitle2: "${product.pricePromo ?? "-"}",
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
              onPressed: () {
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
