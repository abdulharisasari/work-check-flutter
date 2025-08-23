import 'dart:io';

class AttendanceModel {
  int? id, status, userId;
  String?  time, date, address, imgUrl, type, leaveType, notes;
  AttendanceModel({this.id,this.status, this.time, this.date, this.address,this.imgUrl, this.userId, this.type, this.leaveType, this.notes});

  factory AttendanceModel.fromJson(Map<String, dynamic>json){
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      imgUrl: json['image'],
      address: json['address'],
      type: json['type'],
      leaveType: json['leave_type'],
      notes: json['notes'],
      date: json['date'],
      time: json['time'],


    );
  }

  static List<AttendanceModel> fromList(List<dynamic> list){
    return list.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson()=>{
    'id' : id,
    'user_id' : userId,
    'status':status,
    'image': imgUrl,
    'address': address,
    'type': type,
    'leave_type': leaveType,
    'notes': notes,
    'date': date,
    'time': time,
    
  };

}


class CheckinModel {
  final String status;
  final String address;
  final String type;
  final String date;
  final String time;
  final String? imagePath; // local file path

  CheckinModel({
    required this.status,
    required this.address,
    required this.type,
    required this.date,
    required this.time,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'address': address,
      'type': type,
      'date': date,
      'time': time,
    };
  }
}
