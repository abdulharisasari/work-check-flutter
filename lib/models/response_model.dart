class Response{
  final int code;
  final String message;

  Response(this.code, this.message);

  Response.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'];
  
  Response getResponse() {
    return Response(code, message);
  }
}

void createResponse(int code, String message) {
  Response(code, message);
}

class ResponseAdminMasterProduct{
  final int code;
  final String message;
  int? productId;

  ResponseAdminMasterProduct(this.code, this.productId, this.message);

  ResponseAdminMasterProduct.fromJson(Map<String, dynamic> json)
      : code = json['status_code'],
        productId = json['product_id'] ?? 0,
        message = json['message'];
}