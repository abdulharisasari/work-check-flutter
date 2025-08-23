class ProductModel {
  int? id, price, pricePromo;
  String? name, imgUrl, codeBarcode;
  
  ProductModel({this.id, this.price, this.pricePromo, this.name, this.imgUrl, this.codeBarcode});

  factory ProductModel.fromJson(Map<String, dynamic>json){
    return ProductModel(
      id : json['id'],
      price : json['price'],
      pricePromo : json['price_promo'],
      name: json['name'],
      imgUrl: json['img_url'],
      codeBarcode: json['code_barcode']
    );
  }
  
  static List<ProductModel> fromList(List<dynamic> list) {
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

    Map<String, dynamic> toJson()=>{
      'id': id,
      'price': price,
      'price_promo': pricePromo,
      'name': name,
      'img_url': imgUrl,
      'code': codeBarcode
    };

}