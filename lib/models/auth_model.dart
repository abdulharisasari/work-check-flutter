class AuthModel {
  String? accessToken, refreshToken;

  AuthModel({this.accessToken, this.refreshToken});

  AuthModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accesstoken'],
        refreshToken = json['refreshtoken'];

  void setRefreshToken(String? token) {
    refreshToken = token;
  }
}