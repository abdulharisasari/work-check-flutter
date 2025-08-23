import 'package:flutter/material.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_list_data.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/commons/widgets/custom_banner.dart';
import 'package:workcheckapp/models/outlet_model.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/themes.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({super.key});

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  List<OutletModel> listOutletModel = [
    OutletModel(
      id: 1,
      name: "Outlet A",
      codeOutlet: "OUT001",
      address: "Jl. Merdeka No. 10, Jakarta",
      imgUrl: "https://picsum.photos/200/300?random=1",
    ),
    OutletModel(
      id: 2,
      name: "Outlet B",
      codeOutlet: "OUT002",
      address: "Jl. Sudirman No. 25, Bandung",
      imgUrl: "https://picsum.photos/200/300?random=2",
    ),
    OutletModel(
      id: 3,
      name: "Outlet C",
      codeOutlet: "OUT003",
      address: "Jl. Malioboro No. 15, Yogyakarta",
      imgUrl: "https://picsum.photos/200/300?random=3",
    ),
    OutletModel(
      id: 3,
      name: "Outlet C",
      codeOutlet: "OUT003",
      address: "Jl. Malioboro No. 15, Yogyakarta",
      imgUrl: "https://picsum.photos/200/300?random=3",
    ),
    OutletModel(
      id: 3,
      name: "Outlet C",
      codeOutlet: "OUT003",
      address: "Jl. Malioboro No. 15, Yogyakarta",
      imgUrl: "https://picsum.photos/200/300?random=3",
    ),
    OutletModel(
      id: 3,
      name: "Outlet C",
      codeOutlet: "OUT003",
      address: "Jl. Malioboro No. 15, Yogyakarta",
      imgUrl: "https://picsum.photos/200/300?random=3",
    ),
    OutletModel(
      id: 3,
      name: "Outlet C",
      codeOutlet: "OUT003",
      address: "Jl. Malioboro No. 15, Yogyakarta",
      imgUrl: "https://picsum.photos/200/300?random=3",
    ),
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          CustomListItem(
                            labelTitle: "Toko",
                            labelSubtitle1: "Kode",
                            labelSubtitle2: "Alamat",
                            title: "${outlet.name ?? "-"}",
                            subtitle1: "${outlet.codeOutlet ?? "-"}",
                            subtitle2: "${outlet.address ?? "-"}",
                            imageUrl: "${outlet.codeOutlet ?? "-"}",
                            onTap: () {
                               Navigator.pushNamed(context, detailOutletRoute, arguments: outlet);
                            },
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
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildSearch(){
    return CustomTextField(
      hintext: 'Search',
      label: "",
      hintextColor: softGreyColor,
      logo: const Icon(Icons.search_rounded, color: Color(tealBreezeColor), size: 26),
    );
  }

}