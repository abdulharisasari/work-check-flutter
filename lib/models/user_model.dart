class UserModel {
  int? id;
  String?name, email, password;

  UserModel({ this.id, this.name, this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      
    );
  }

  static List<UserModel> fromList(List<dynamic> list) {
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
    'user_id': id,
    'name': name,
    'email': email,
    'password': password,
    
  };
}