import 'package:flutter/material.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/commons/widgets/custom_dialog.dart';
import 'package:workcheckapp/commons/widgets/custom_textfield.dart';
import 'package:workcheckapp/models/attendance_model.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:workcheckapp/services/utils.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<AttendanceModel> listAttendance = [
    AttendanceModel(
      id: 1,
      statusId: 0,
      name: "John Doe",
      hours: "08:00 - 17:00",
      date: "2025-08-21",
      address: "Jakarta",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 2,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
    AttendanceModel(
      id: 2,
      statusId: 1,
      name: "Jane Smith",
      hours: "09:00 - 18:00",
      date: "2025-08-21",
      address: "Bandung",
      imgUrl: illustrationPeople,
    ),
  ];

 String? selectedValue; 
 String? selectedHari;
 bool _isAttandence = false;

  @override
  void initState() {
    super.initState();
  }

  void _showAttendanceDialog()  {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Pilih Kehadiran",
        confirmText: "Masuk Kerja",
        cancelText: "Izin Absen",
        onConfirm: () {
          Navigator.of(context).pop();
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

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isAttandence? _buildFormLeave(): _buildDashboard()
    );
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
                left: 25,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backTitle(),
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


  Widget _buildDashboard(){
    return Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildBanner(),
              Positioned(top: 70, left: 25,right: 10, child: Row(
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
                  CustomButton(text: "DAFTAR TOKO", onPressed: () {})
              
                ],
              ),
            ),
          ),

        ],
      );
  }


  Widget _buttonCamera(){
    return InkWell(
      onTap: () => _showAttendanceDialog(),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: Utils.shadowCustom(), 
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)), color: Color(tealBreezeColor)
        ),
        padding: EdgeInsets.all(2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded, size: 36, color: Color(pureWhiteColor),),
            Text("Absen",style: TextStyle(fontSize: 12, color: Color(pureWhiteColor)),),
          ],
        )
      ),
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
              Text("08.00", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
          Container(height: 75, width: 2, color: Colors.grey),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Masuk Kerja", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("08.00", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
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
          CustomDateField(label: 'Tanggal Izin', hintText: "dd/mm/yy"),
          SizedBox(height: 20),
          _selectLeave(),
          SizedBox(height: 20),
          _selectDay(),
          SizedBox(height: 20),
          CustomTextField(label: 'Notes', maxLines: 3, isTextarea: true),
          SizedBox(height: 40,),
          CustomButton(text: "KIRIM PERMOHONAN", onPressed: (){}),
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
              value: selectedValue,
              elevation: 4,
              hint: Text("Pilih jenis izin"),
              items: [
                DropdownMenuItem(value: "A", child: Text("Kategori A")),
                DropdownMenuItem(value: "B", child: Text("Kategori B")),
                DropdownMenuItem(value: "C", child: Text("Kategori C")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
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
          
          Text("Absensi",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Color(pureWhiteColor)
            ),
          ),
        ],
      ),
    );
  }

  Widget _listAttendence() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: listAttendance.length,
        itemBuilder: (context, index) {
          final attendance = listAttendance[index];
          return _buildHeaderAttandance(attendance.imgUrl ?? '', attendance.hours ?? '', attendance.date ?? '', attendance.address ?? '', attendance.statusId!);
        },
      ),
    );
  }

  Widget _buildHeaderAttandance(String pathImg, String hours, String date, String address, int statusId) {
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
             child: statusId == 1 ? Image.asset(pathImg, height: 70, width: 70): Container(
               height: 70,
               width: 70,
               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: statusId == 0 ? Color(coralFlameColor) : Color(mintGreenColor)),
               alignment: Alignment.center,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Image.asset(statusId == 0 ? icSick : icLeave, height: 28, width: 28),
                   Text(
                     "${statusId == 0 ? "Sakit" : "Izin"}",
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(pureWhiteColor)),
                   ),
                 ],
               ),
             )),
            SizedBox(width: 10),
            Row(
              children: [
                Container(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textCustom("Jam"),
                      _textCustom("Hari/Tgl"),
                      _textCustom("Alamat")
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textCustom(": $hours"),
                    _textCustom(": $date"),
                    _textCustom(": $address")
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textCustom(String text) {
    return Text(text, style: TextStyle(fontSize: 10, color: Color(darkGreyColor)));
  }
}
