class OutletModel {
  int? id, promoAvailable;
  String? name, codeOutlet, address, imgUrl;
  
  OutletModel({this.id, this.name, this.codeOutlet, this.address, this.imgUrl, this.promoAvailable});

  factory OutletModel.fromJson(Map<String, dynamic>json){
    return OutletModel(
      id: json['id'],
      name : json['nama_toko'],
      codeOutlet : json['kode_toko'],
      address : json['alamat'],
      imgUrl : json['image'],
      promoAvailable: json['promo_available']??0
    );
  }

  static List<OutletModel> fromList(List<dynamic> list){
    return list.map((e) => OutletModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson()=>{
    'id': id,
    'nama_toko': name,
    'kode_toko': codeOutlet,
    'alamat': address,
    'image': imgUrl,
    'promo_available': promoAvailable
  };

}