import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/commons/widgets/custom_banner.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/providers/outlet_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({super.key});

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  final TextEditingController _searchTC = TextEditingController();
  List<OutletModel> listOutletModel = [];
  bool _isLoading = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    await _getHeaderAttandance();
  }

  Future<void> _getHeaderAttandance() async {
    setState(() {
      _isLoading = true;
    });
    listOutletModel.clear();
    final outletProv = await Provider.of<OutletProvider>(context, listen: false);
    try {
      final _outletState = await outletProv.getOutlet(context, search: _searchTC.text);
      if (_outletState != null) {
        setState(() {
          listOutletModel = _outletState;
        });
      }
    } catch (e) {
      debugPrint('Error in getHeaderAttandance: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading?Center(child: CircularProgressIndicator(),): Column(
        children: [
          BannerWidget(
            title: "Daftar Toko",
            onBack: () {
              Navigator.pop(context);
            },
            searchWidget: _buildSearch(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  ListView.builder(
                    itemCount: listOutletModel.length,
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(), 
                    itemBuilder: (context, index) {
                      final outlet = listOutletModel[index];
                      return Column(
                        children: [
                          Stack(
                            children: [
                              CustomListItem(
                                labelTitle: "Toko",
                                labelSubtitle1: "Kode",
                                labelSubtitle2: "Alamat",
                                title: ": ${outlet.name ?? "-"}",
                                subtitle1: ": ${outlet.codeOutlet ?? "-"}",
                                subtitle2: ": ${outlet.address ?? "-"}",
                                imageUrl: "${outlet.codeOutlet ?? "-"}",
                                detail: true,
                                onTap: () {
                                   Navigator.pushNamed(context, detailOutletRoute, arguments: outlet);
                                },
                              ),
                              if(outlet.promoAvailable == 1)
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(coralFlameColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Image.asset(icPromo, height: 14, width: 14, fit: BoxFit.cover, color: Color(pureWhiteColor),)),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: "SELENGKAPNYA",
              onPressed: () async{ _getHeaderAttandance(); },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildSearch(){
    return CustomTextField(
      controller: _searchTC,
      onChanged: (p0) => _getHeaderAttandance(),
      hintext: 'Search',
      label: "",
      hintextColor: softGreyColor,
      logo: const Icon(Icons.search_rounded, color: Color(tealBreezeColor), size: 26),
    );
  }

}