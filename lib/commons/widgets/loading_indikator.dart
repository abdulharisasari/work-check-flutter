import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Color color;
  final double size;
  final bool overlay;
  final String? title; // tambahkan title

  const CustomLoadingIndicator({
    Key? key,
    required this.isLoading,
    this.color = Colors.white,
    this.size = 50,
    this.overlay = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return SizedBox.shrink();

    Widget indicator = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 4,
            ),
          ),
          if (title != null) ...[
            SizedBox(height: 16),
            Text(
              title!,
              style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );

    if (overlay) {
      return Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          indicator,
        ],
      );
    }

    return indicator;
  }
}
