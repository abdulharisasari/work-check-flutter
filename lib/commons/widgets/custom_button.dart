import 'package:flutter/material.dart';
import 'package:workcheckapp/services/themes.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double height;
  final bool isOutline;
  final Color? borderColor;
  final double? sizeText;
  final bool isEnabled;

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
    this.sizeText = 18,
    this.isEnabled = true, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = isEnabled ? (isOutline ? Colors.white : backgroundColor) : Colors.grey.shade400;

    final effectiveTextColor = isEnabled ? textColor : Colors.grey.shade200;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: effectiveBackground,
          foregroundColor: effectiveTextColor,
          elevation: isEnabled ? 3 : 0,
          side: BorderSide(color: borderColor ?? backgroundColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
        onPressed: isEnabled ? onPressed : null, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: effectiveTextColor,
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
