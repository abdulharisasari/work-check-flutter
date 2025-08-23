import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:workcheckapp/services/assets.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final Rect guideBox;
  final ValueChanged<bool> onFaceInsideGuide;
  ui.Image? _greenImage;

  FaceDetectorPainter(
    this.faces,
    this.absoluteImageSize,
    this.rotation,
    this.guideBox,
    this.onFaceInsideGuide,
  ) {
    // _loadGreenImage(); // load gambar hijau saat dibuat
  }

  void _loadGreenImage() async {
    if (_greenImage != null) return;
    final data = await rootBundle.load(frameSelfiePng);
    final bytes = data.buffer.asUint8List();
    ui.decodeImageFromList(bytes, (img) {
      _greenImage = img;
      onFaceInsideGuide(faces.isNotEmpty);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    bool faceInsideGuide = false;

    for (final face in faces) {
      final rect = Rect.fromLTRB(
        translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
        translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize),
      );

      // jika wajah sepenuhnya dalam guide box
      if (guideBox.contains(rect.topLeft) && guideBox.contains(rect.bottomRight)) {
        faceInsideGuide = true;
        // gambar gambar hijau sesuai ukuran kotak wajah
        if (_greenImage != null) {
          canvas.drawImageRect(
            _greenImage!,
            Rect.fromLTWH(0, 0, _greenImage!.width.toDouble(), _greenImage!.height.toDouble()),
            rect,
            Paint(),
          );
        }
      } else {
        // tetap tampil kotak merah untuk warning
        final Paint warningPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..color = Colors.red;
        canvas.drawRect(rect, warningPaint);
      }
    }

    onFaceInsideGuide(faceInsideGuide);
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.faces != faces || oldDelegate._greenImage != _greenImage;
  }

  double translateX(double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x * size.width / absoluteImageSize.height;
      case InputImageRotation.rotation270deg:
        return size.width - x * size.width / absoluteImageSize.height;
      default:
        return x * size.width / absoluteImageSize.width;
    }
  }

  double translateY(double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / absoluteImageSize.width;
      default:
        return y * size.height / absoluteImageSize.height;
    }
  }
}
