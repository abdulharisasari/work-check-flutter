class AttendanceModel {
  int? id, statusId;
  String? name, hours, date, address, imgUrl;

  AttendanceModel({this.id,this.statusId, this.name, this.hours, this.date, this.address,this.imgUrl});

  factory AttendanceModel.fromJson(Map<String, dynamic>json){
    return AttendanceModel(
      id: json['id'],
      statusId: json['status_id'],
      name : json['name'],
      hours : json['hours'],
      date : json['date'],
      address : json['address'],
      imgUrl : json['img_url'],
    );
  }

  static List<AttendanceModel> fromList(List<dynamic> list){
    return list.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson()=>{
    'id' : id,
    'status_id':statusId,
    'name' : name,
    'hours' : hours,
    'date' : date,
    'address' : address,
    'img_url' : imgUrl,
  };

}