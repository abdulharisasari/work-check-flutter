import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_dialog.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/attendance_model.dart';
import 'package:workcheckapp/models/user_model.dart';
import 'package:workcheckapp/providers/attandance_provider.dart';
import 'package:workcheckapp/providers/auth_provider.dart';
import 'package:workcheckapp/providers/user_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/db_local.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:workcheckapp/services/utils.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  final AttendanceModel? attendanceModel;
  const AttendancePage({Key? key, this.attendanceModel}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final TextEditingController _dateTC = TextEditingController();
  final TextEditingController _notesTC = TextEditingController();
  List<AttendanceModel> listAttendance = [];
  AttendanceModel attendanceModel = AttendanceModel();
  UserModel userModel = UserModel();
  String locationText = '';
  DateTime? timestamp;
  String? selectedLeave;
  String? selectedHari;
  bool _isAttandence = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeaderAttendance();
    });
  }

  void _init() async {
    await _getMe();
    await _checkLocationPermission();
    await _getHeaderAttendance();
    await _getLocationAndTime();
  }
  
  Future<void> _getMe() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    try {
      final user = await userProv.getMe(context);
      if (user != null) {
      setState(() {
          userModel = user;
        });  
      }
    } catch (e) {
     debugPrint("catch on _getMe :$e");
    }
  }

  Future<void> _getHeaderAttendance() async {
    setState(() => _isLoading = true);
    listAttendance.clear();
    final attandanceProv = Provider.of<AttandanceProvider>(context, listen: false);
    final localDb = LocalOfflineDatabase<AttendanceModel>(boxName: 'attendance_offline', fromJson: (json) => AttendanceModel.fromJson(json), toJson: (att) => att.toJson());
    try {
      final offlineList = await localDb.getPendingItems();
      if (offlineList.isNotEmpty) {
        setState(() => listAttendance = offlineList);
      }

      final _attandanceState = await attandanceProv.getHeaderAttendance(context).timeout(const Duration(seconds: 2));
      final _attandanceToday = await attandanceProv.getTodayAttendance(context).timeout(const Duration(seconds: 2));

      if (_attandanceState != null && _attandanceToday != null) {
        await localDb.clearAll();
        final existingItems = <int>{};
        for (var att in _attandanceState) {
          if (existingItems.contains(att.hashCode)) continue;
          existingItems.add(att.hashCode);

          if (att.imgUrl != null && att.imgUrl!.startsWith('http')) {
            final file = await _downloadAndSaveImage(att.imgUrl!);
            att.imgUrl = file.path;
          }
          await localDb.addItem(att);
        }
        setState(() {
          listAttendance = _attandanceState;
          attendanceModel = _attandanceToday;
        });
      }
    } catch (e) {
      debugPrint('Error in getHeaderAttendance: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  
  Future<File> _downloadAndSaveImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${url.split('/').last}');
    await file.writeAsBytes(bytes);
    return file;
  }



  Future<void> createAttandance() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final attendanceDb = LocalOfflineDatabase<AttendanceModel>(boxName: 'attendance_offline', fromJson: (json) => AttendanceModel.fromJson(json), toJson: (attendance) => attendance.toJson());
    final attandanceProv = Provider.of<AttandanceProvider>(context, listen: false);
    final now = DateTime.now();
    if (_dateTC.text.isEmpty || _notesTC.text.isEmpty) {
      showSnackBar(context,"Mohon isi ${_dateTC.text.isEmpty ? "Tanggal Izin" : _notesTC.text.isEmpty ? "Notes" : selectedHari == null ? "Waktu izin" : selectedLeave == null ? "Jenis Izin" : selectedHari == null ? "Waktu Izin" : "Semua"}");
      setState(() => _isLoading = false);
      return;
    }
    final attendanceModel = AttendanceModel(
      leaveType: selectedLeave,
      time: now.toString().split(' ')[1].split('.')[0],
      date: _dateTC.text,
      address: locationText,
      notes: _notesTC.text,
      status: 0,
    );

    try {
      final response = await attandanceProv.createAttandance(context, attendanceModel).timeout(const Duration(seconds: 2));;
      if (response != null) {
        if (response.code == 200) {
          showSnackBar(context, response.message, backgroundColor: Color(mintGreenColor));
          await attendanceDb.clearAll();
          Navigator.pushReplacementNamed(context, attendanceRoute);
        }else if (response.code == 403) {
          await attendanceDb.addItem(attendanceModel);
          showSnackBar(context, response.message);
        } else {
          showSnackBar(context, response.message);
        }
      }
    } catch (e) {
      debugPrint('Error in createAttandance: $e');
      showSnackBar(context, 'Gagal mengirim absen. Silakan coba lagi.');
    }
  }
  

  Future<void> _getLocationAndTime() async {
    setState(() {});
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: "id_ID",
      );

      String loc = "Tidak diketahui";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        loc = "${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
      }

      DateTime now = DateTime.now();

      setState(() {
        locationText = loc;
        timestamp = now;
      });
    } catch (e) {
      print('Error mendapatkan lokasi: $e');
      setState(() {
        locationText = 'Error mendapatkan lokasi';
        timestamp = DateTime.now();
      });
    }
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Pilih Kehadiran",
        confirmText: "Masuk Kerja",
        cancelText: "Izin Absen",
        onConfirm: () async {
          final now = DateTime.now();
          int status;
          if (now.hour >= 8 && now.hour < 12) {
            status = 1;
          } else if (now.hour >= 12) {
            status = 2;
          } else {
            showSnackBar(context, "Belum waktu absen");
            return;
          }

          Navigator.pushNamed(context, cameraRoute, arguments: status);
          setState(() {
            _isAttandence = true;
          });
        },
        onCancel: () {
          Navigator.of(context).pop();
          setState(() {
            _isAttandence = false;
          });
        },
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(context, "Layanan lokasi tidak aktif. Silakan aktifkan layanan lokasi.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(context, "Izin lokasi ditolak.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(context, "Izin lokasi ditolak secara permanen, silakan atur di pengaturan.");
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async{_init();} ,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : !_isAttandence
                  ? _buildFormLeave()
                  : _buildDashboard(),
        ));
  }

  Widget _buildFormLeave() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              _buildBanner(),
              Positioned(
                top: 70,
                left: 20,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backIzinTitle(),
                    _buttonCamera(),
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, -50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildFieldLeave(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildBanner(),
            Positioned(
                top: 70,
                left: 25,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backTitle(),
                    _buttonCamera()
                  ],
                )),
            Positioned(top: 140, right: 20, left: 20, child: _buildCheckInOut())
          ],
        ),
        SizedBox(height: 5),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                _listAttendence(),
                SizedBox(height: 15),
                CustomButton(
                    text: "DAFTAR TOKO",
                    onPressed: () {
                      Navigator.pushNamed(context, outletRoute);
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonCamera() {
    return InkWell(
      onTap: () => _showAttendanceDialog(),
      child: Container(
          decoration: BoxDecoration(boxShadow: Utils.shadowCustom(), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)), color: Color(tealBreezeColor)),
          padding: EdgeInsets.all(2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_rounded,
                size: 36,
                color: Color(pureWhiteColor),
              ),
              Text(
                "Absen",
                style: TextStyle(fontSize: 12, color: Color(pureWhiteColor)),
              ),
            ],
          )),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 200,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(primaryColor),
          image: DecorationImage(
            image: AssetImage(backgroundBannerPng),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInOut() {
    return Container(
      width: 200,
      height: 75,
      decoration: BoxDecoration(
        color: Color(pureWhiteColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: Utils.shadowCustom(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Masuk Kerja", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("${attendanceModel.timeCheckIn ?? "--:--"}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
          Container(height: 75, width: 2, color: Colors.grey),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pulang Kerja", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(" ${attendanceModel.timeCheckOut ?? "--:--"}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLeave() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(pureWhiteColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: Utils.shadowCustom(),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text("Permohonan Izin Absen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          CustomDateField(
            label: 'Tanggal Izin',
            hintText: "dd/mm/yy",
            controller: _dateTC,
          ),
          SizedBox(height: 20),
          _selectLeave(),
          SizedBox(height: 20),
          CustomTextField(
            label: 'Notes',
            maxLines: 3,
            isTextarea: true,
            controller: _notesTC,
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton(
              text: "KIRIM PERMOHONAN",
              onPressed: () {
                createAttandance();
              }),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _selectLeave() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Jenis Izin", style: TextStyle(fontSize: 15, color: Color(darkGreyColor))),
        SizedBox(height: 15),
        Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1.0, color: Color(darkGreyColor)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLeave,
              elevation: 4,
              hint: Text("Pilih jenis izin"),
              items: [
                DropdownMenuItem(value: "Sakit", child: Text("Sakit")),
                DropdownMenuItem(value: "Cuti", child: Text("Cuti")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLeave = value;
                });
              },
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pilih Waktu Izin",
          style: TextStyle(fontSize: 15, color: Color(darkGreyColor)),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  child: Radio<String>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: "Full Sehari",
                    groupValue: selectedHari,
                    onChanged: (value) {
                      setState(() {
                        selectedHari = value;
                      });
                      print("Select hari : $selectedHari");
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text("Full Sehari", style: TextStyle(fontSize: 15, color: Color(darkGreyColor))),
              ],
            ),
            SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  child: Radio<String>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: "Setengah Hari",
                    groupValue: selectedHari,
                    onChanged: (value) {
                      setState(() {
                        selectedHari = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text("Setengah Hari", style: TextStyle(fontSize: 15, color: Color(darkGreyColor))),
              ],
            ),
          ],
        ),
      ],
    );
  }

 Widget _backTitle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'profile') {
                    
                  } else if (value == 'logout') {
                    final authProv = Provider.of<AuthProvider>(context, listen: false);
                    authProv.logout(context);
                    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
                  }
                },
                itemBuilder: (context) => [
                   PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Image.asset(icPerson, height: 15,width: 15, color: Colors.black),
                        SizedBox(width: 10),
                        Text("Profil"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 15),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ],
                child: Text(
                  "Absensi",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Color(pureWhiteColor),
                  ),
                ),
              ),
              Row(
                children: [
                  Image.asset(icPerson, height: 11, color: Color(pureWhiteColor)),
                  const SizedBox(width: 5),
                  Text(
                    "${userModel.name}",
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: Color(pureWhiteColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _backIzinTitle() {
    return InkWell(
      onTap: () {
        setState(() {
          _isAttandence = true;
        });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 24,
              child: Icon(
                Icons.chevron_left,
                size: 24.0,
                color: Color(pureWhiteColor),
              ),
            ),
            Text(
              "From Izin",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Color(pureWhiteColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listAttendence() {
    return Expanded(
      child: listAttendance.isEmpty
          ? Center(child: Text("No Data Available"))
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listAttendance.length,
              itemBuilder: (context, index) {
                final attendance = listAttendance[index];
                return _buildHeaderAttandance(attendance);
              },
            ),
    );
  }

  Widget _buildHeaderAttandance(AttendanceModel attendance) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color(softGrey3Color),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                child: attendance.status == 1 || attendance.status == 2
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Builder(
                          builder: (context) {
                            if (attendance.imgUrl == null || attendance.imgUrl!.isEmpty) {
                              return Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              );
                            }
                            final isLocal = File(attendance.imgUrl!).existsSync();
                            if (isLocal) {
                              return Image.file(
                                File(attendance.imgUrl!),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                  );
                                },
                              );
                            } else {
                              return Image.network(
                                attendance.imgUrl!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )

                    : Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: attendance.leaveType == "Sakit" ? Color(coralFlameColor) : Color(mintGreenColor)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(attendance.leaveType == "Sakit" ? icSick : icLeave, height: 28, width: 28),
                            Text(
                              "${attendance.leaveType}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(pureWhiteColor)),
                            ),
                          ],
                        ),
                      )),
            SizedBox(width: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textCustom("Jam"),
                      _textCustom("Hari/Tgl"),
                      _textCustom("Alamat"),
                      _textCustom("Status")
                    ],
                  ),
                ),
                Container(
                  width: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textCustom(":"),
                      _textCustom(":"),
                      _textCustom(":"),
                      _textCustom(":")
                    ],
                  ),
                ),
                Container(
                  width: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textCustom("${attendance.status == 0 ?attendance.time :attendance.timeCheckIn??attendance.timeCheckOut}"),
                      _textCustom("${attendance.date}"),
                      _textCustom("${attendance.address}"),
                      _textCustom("${attendance.status == 0 ? "${attendance.leaveType}" : attendance.status == 1 ? "Masuk" : "Pulang"}")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textCustom(String text) {
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Color(darkGreyColor)));
  }
}
