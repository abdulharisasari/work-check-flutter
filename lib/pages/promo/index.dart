import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/models/promo_model.dart';
import 'package:workcheckapp/providers/promo_provider.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:workcheckapp/services/utils.dart';

class PromoPage extends StatefulWidget {
  final OutletModel outletModel;
  const PromoPage({super.key, required this.outletModel});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  final TextEditingController _nameProductTC = TextEditingController();
  final TextEditingController _priceNormalTC = TextEditingController();
  final TextEditingController _pricePromoTC = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _pathImage;
  bool _isPromo = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init(){
    _nameProductTC.clear();
    _priceNormalTC.clear();
    _pricePromoTC.clear();
    _pathImage = null;
    _imageFile = null;
    _isPromo = widget.outletModel.promoAvailable == 1 ? true : false;

  }

  Future<void> _addPromo() async {
    setState(() {});
    if (_nameProductTC.text.isEmpty || _priceNormalTC.text.isEmpty || _priceNormalTC.text.isEmpty) {
      showSnackBar(context, "Harap isi semua kolom");
      return;
    }
    final promoProv = Provider.of<PromoProvider>(context, listen: false);
    final base64Image = await Utils.convertImageToSmallBase64(_pathImage!);
    final promoModel = PromoModel(imageUrl: base64Image, nameProduct: _nameProductTC.text, priceNormal: int.tryParse(_priceNormalTC.text), pricePromo: int.tryParse(_pricePromoTC.text));
    try {
      final response = await promoProv.createProductPromo(context, promoModel, widget.outletModel.id!);
      if (response?.code == 200) {
        showSnackBar(context, response?.message ?? '', backgroundColor: Color(mintGreenColor));
      } else if (response?.code == 400) {
        showSnackBar(context, response?.message ?? "Gagal nambah Promo");
      } else {
        showSnackBar(context, response?.message ?? "Gagal Nambah Promo");
      }
      _init();
    } catch (e) {
      debugPrint("Error in _addPromo : $e");
      showSnackBar(context, 'Gagal mengirim absen. Silakan coba lagi.');
    } finally {
      setState(() {});
    }
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPromo()
      
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
            CustomTextField(label: "Nama Produk", controller: _nameProductTC),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Normal", controller: _priceNormalTC, keyBoardNumber: true),
            SizedBox(height: 10),
            CustomTextField(label: "Harga Promo", controller: _pricePromoTC, keyBoardNumber: true),
            SizedBox(height: 20),
            CustomButton(
                text: "TAMBAHKAN PROMO",
                isEnabled: _isPromo,
                onPressed: () async {
                  await _addPromo();
                })
          ],
        ),
      ),
    );
  }
}