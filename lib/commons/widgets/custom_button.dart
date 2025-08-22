import 'package:flutter/material.dart';
import 'package:workcheckapp/services/themes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Widget? icon;
  final VoidCallback onPressed;
  final double height;
  final bool isOutline;
  final Color? borderColor;
  final double? sizeText;


  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(primaryColor),
    this.textColor = Colors.white,
    this.borderRadius = 8,
    this.icon,
    this.height = 50,
    this.isOutline = false,
    this.borderColor,
    this.sizeText = 18
  }) : super(key: key);
@override
Widget build(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: isOutline ? Colors.white : backgroundColor,
        foregroundColor: textColor,
        elevation: 3, 
        side: isOutline ? BorderSide(color: borderColor ?? textColor, width: 1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadowColor: Colors.grey.withOpacity(0.5), 
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: sizeText,
            ),
          ),
        ],
      ),
    ),
  );
}
}



class HariSelector extends StatefulWidget {
  final Function(String) onChanged;
  final String? initialValue;

  HariSelector({required this.onChanged, this.initialValue});

  @override
  _HariSelectorState createState() => _HariSelectorState();
}

class _HariSelectorState extends State<HariSelector> {
  String? selectedHari;

  @override
  void initState() {
    super.initState();
    selectedHari = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio<String>(
              value: "Full Sehari",
              groupValue: selectedHari,
              onChanged: (value) {
                setState(() {
                  selectedHari = value;
                  widget.onChanged(value!);
                });
              },
            ),
            Text("Full Sehari"),
          ],
        ),
        SizedBox(width: 16),
        Row(
          children: [
            Radio<String>(
              value: "Setengah Hari",
              groupValue: selectedHari,
              onChanged: (value) {
                setState(() {
                  selectedHari = value;
                  widget.onChanged(value!);
                });
              },
            ),
            Text("Setengah Hari"),
          ],
        ),
      ],
    );
  }
}
