import 'package:flutter/material.dart';
import 'package:workcheckapp/services/themes.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final double borderRadius;

  const CustomDialog({Key? key, required this.title, this.confirmText = "OK", this.cancelText, this.onConfirm, this.onCancel, this.borderRadius = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(color: Color(primaryColor), borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius))),
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(pureWhiteColor))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomButton(
                    text: confirmText,
                    onPressed: onConfirm ?? () => Navigator.of(context).pop(),
                    backgroundColor: Color(primaryColor),
                    textColor: Color(pureWhiteColor),
                    borderRadius: borderRadius,
                    sizeText: 13,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: CustomButton(
                    text: cancelText!,
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    backgroundColor: Color(pureWhiteColor),
                    textColor: Color(primaryColor),
                    borderRadius: borderRadius,
                    borderColor: Color(primaryColor),
                    isOutline: true,
                    sizeText: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
