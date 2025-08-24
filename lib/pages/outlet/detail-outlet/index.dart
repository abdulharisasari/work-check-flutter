import 'package:flutter/material.dart';
import 'package:workcheckapp/commons/widgets/custom_banner.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/pages/product/index.dart';
import 'package:workcheckapp/pages/promo/index.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';

class DetailOutletPage extends StatefulWidget {
  final OutletModel outletModel;
  const DetailOutletPage({super.key, required this.outletModel});

  @override
  State<DetailOutletPage> createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {
  int _selectedPageProduct = 0;

  
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
                          onTap: () => setState(() { _selectedPageProduct = 1;}),
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
                  child: _selectedPageProduct == 0 ? ProductPage(outletModel: widget.outletModel) : PromoPage(outletModel: widget.outletModel),
                ),
              ],
            ),
          ),
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
