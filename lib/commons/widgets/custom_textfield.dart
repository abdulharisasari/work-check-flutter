import 'package:flutter/material.dart';
import 'package:workcheckapp/services/themes.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Widget? logo;
  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines; 
  final bool isTextarea; 
  final String? hintext;
  final int? hintextColor;
  final bool? keyBoardNumber;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    this.logo,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.isTextarea = false,
    this.hintext,
    this.hintextColor,
    this.onChanged,
    this.keyBoardNumber
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label !="")Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15.0,
                color: Color(darkGreyColor)
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        
        Container(
          height: maxLines == 1? 55: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1.0, color: hintextColor != null ? Color(hintextColor!) : Color(darkGreyColor)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            focusNode: focusNode,
            maxLines: isTextarea ? maxLines : 1,
            minLines: isTextarea ? 3 : 1,
            onTapOutside: (event) => focusNode?.unfocus(),
            onChanged: onChanged,
            keyboardType:keyBoardNumber != null ? TextInputType.number:TextInputType.name,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: hintext,
              hintStyle: TextStyle(color:hintextColor != null? Color(hintextColor!):Color(darkGreyColor)),
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              
              suffixIcon: logo != null
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: logo,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}


class CustomDateField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? logo;
  final String? hintText;

  const CustomDateField({
    Key? key,
    required this.label,
    this.controller,
    this.logo,
    this.hintText,
  }) : super(key: key);

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        _controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 15.0, color: Color(darkGreyColor)),
        ),
        SizedBox(height: 15),
        Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1.0, color: Color(darkGreyColor)),
          ),
          child: TextField(
            controller: _controller,
            readOnly: true,
            onTap: _selectDate,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(pureWhiteColor),
              hintText: widget.hintText ?? "dd/mm/yyyy",
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: widget.logo ??
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.calendar_today, size: 20, color: Color(darkGreyColor)),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
