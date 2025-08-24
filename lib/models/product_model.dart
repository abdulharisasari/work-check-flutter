class ProductModel {
  int? id,  availableStock;
  String? name, imgUrl, codeBarcode, price, volume;
  
  ProductModel({this.id, this.price, this.name, this.imgUrl, this.codeBarcode, this.availableStock, this.volume});

  factory ProductModel.fromJson(Map<String, dynamic>json){
    return ProductModel(
      id : json['id'],
      name: json['nama_produk'],
      codeBarcode: json['barcode'],
      imgUrl: json['image'],
      availableStock: json['available'],
      price: json['promo_price'],
      volume: json['volume'],

    );
  }
  
  static List<ProductModel> fromList(List<dynamic> list) {
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

    Map<String, dynamic> toJson()=>{
      'id': id,
      'nama_produk': name,
      'barcode': codeBarcode,
      'image': imgUrl,
      'available': availableStock,
      'promo_price': price,
      'volume': volume,
    };

}