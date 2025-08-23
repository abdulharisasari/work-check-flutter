class OutletModel {
  int? id;
  String? name, codeOutlet, address, imgUrl;
  
  OutletModel({this.id, this.name, this.codeOutlet, this.address, this.imgUrl});

  factory OutletModel.fromJson(Map<String, dynamic>json){
    return OutletModel(
      id: json['id'],
      name : json['name'],
      codeOutlet : json['code_outlet'],
      address : json['address'],
      imgUrl : json['img_url'],
    );
  }

  static List<OutletModel> fromList(List<dynamic> list){
    return list.map((e) => OutletModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson()=>{
    'id': id,
    'name': name,
    'code_outlet': codeOutlet,
    'address': address,
    'img_url': imgUrl,
  };

}