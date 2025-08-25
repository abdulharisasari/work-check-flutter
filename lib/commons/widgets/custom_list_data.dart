import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';

class CustomListItem extends StatelessWidget {
  final String? title;
  final String? subtitle1, labelSubtitle1, labelTitle;
  final String? subtitle2, labelSubtitle2;
  final String imageUrl;
  final String? barcode;
  final bool selectable;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelectedChanged;
  final bool? detail;
  final double? labelWidth;

  const CustomListItem({
    Key? key,
    this.title,
    this.labelTitle,
    this.subtitle1 = "",
    this.labelSubtitle1,
    this.subtitle2 = "",
    this.labelSubtitle2,
    this.imageUrl = "",
    this.barcode,
    this.selectable = false,
    this.isSelected = false,
    this.onTap,
    this.onSelectedChanged,
    this.detail,
    this.labelWidth = 50,
  }) : super(key: key);

  List<bool> _encodeBarcode(String code) {
    return code.runes.map((c) => c % 2 == 1).toList();
  }

  Widget _buildBarcodeWidget(String code, {double widthPerUnit = 4, double height = 80}) {
    final pattern = _encodeBarcode(code);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pattern.map((isBlack) {
        return Container(
          width: widthPerUnit,
          height: height,
          color: isBlack ? Colors.black : Colors.white,
        );
      }).toList(),
    );
  }

  void _showBarcodePopup(BuildContext context) {
    if (barcode == null || barcode!.isEmpty) return;

    final double widthPerUnit = 6; 
    final double barcodeWidth = barcode!.length * widthPerUnit;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), 
        ),
        content: Container(
          width: barcodeWidth, 
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBarcodeWidget(
                barcode!,
                widthPerUnit: widthPerUnit,
                height: 50,
              ),
              Text(
                barcode!,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(softGrey3Color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Builder(
                    builder: (context) {
                      if (imageUrl.isEmpty) {
                        return Image.asset(
                          illustrationOutlet,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        );
                      }

                      final file = File(imageUrl);
                      if (file.existsSync()) {
                        return Image.file(
                          file,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            illustrationOutlet,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            illustrationOutlet,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: labelWidth,
                            child: Text(
                              labelTitle??'',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(darkGreyColor),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              title??"",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(darkGreyColor),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    labelSubtitle1??'',
                                    style: TextStyle(fontSize: 11, color: Color(darkGreyColor)),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (subtitle1!.isNotEmpty)
                                  Text(
                                    "$subtitle1",
                                    style: TextStyle(fontSize: 11, color: Color(darkGreyColor)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  labelSubtitle2 ?? '',
                                  style: TextStyle(fontSize: 11, color: Color(darkGreyColor)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (subtitle2!.isNotEmpty)
                                  Text(
                                    "$subtitle2",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11, color: Color(darkGreyColor)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: detail != null? Icon(Icons.chevron_right,size: 40) :Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          if (barcode != null && barcode!.isNotEmpty)
                            Container(
                              height: 50,
                              width: 40,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () => _showBarcodePopup(context),
                                child: _buildBarcodeWidget(barcode!, widthPerUnit: 2, height: 27),
                              ),
                            ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              if (onSelectedChanged != null) {
                                onSelectedChanged!(!isSelected);
                              }
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected ? Color(mintGreenColor) : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? Color(mintGreenColor) : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
