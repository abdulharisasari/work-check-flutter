class PromoModel {
  String? nameProduct, imageUrl;
  int? priceNormal, pricePromo, id;

  PromoModel({this.nameProduct, this.imageUrl, this.priceNormal, this.pricePromo, this.id});

  factory PromoModel.fromJson(Map<String, dynamic> json){
    return PromoModel(
      nameProduct: json['nama_produk'],
      priceNormal: json['harga_normal'],
      pricePromo: json['harga_promo'],
      imageUrl: json['image'],
      id: json['id'],

    );
  }
  
  static List<PromoModel> fromList(List<dynamic> list) {
    return list.map((e) => PromoModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson()=>{
    'nama_produk':nameProduct,
    'harga_normal':priceNormal,
    'harga_promo':pricePromo,
    'image':imageUrl,
    'id':id,
  };

}


