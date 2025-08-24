import 'package:flutter/material.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:workcheckapp/services/themes.dart';

class BannerWidget extends StatelessWidget {
  final double height;
  final double innerHeight;
  final String title;
  final VoidCallback? onBack;
  final Widget? searchWidget, addWidget;

  const BannerWidget({
    Key? key,
    this.height = 200,
    this.innerHeight =200,
    required this.title,
    this.onBack,
    this.searchWidget,
    this.addWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(
            height: innerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(primaryColor),
              image: DecorationImage(
                image: AssetImage(backgroundBannerPng),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  child: IconButton(
                    onPressed: onBack ?? () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 24.0,
                      color: Color(pureWhiteColor),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Color(pureWhiteColor),
                  ),
                ),
              ],
            ),
          ),

          if (searchWidget != null)
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              child: searchWidget!,
            ),
          if (addWidget != null)
            Positioned(
              top: 105,
              left: 20,
              right: 20,
              child: addWidget!,
            ),
        ],
      ),
    );
  }
}


