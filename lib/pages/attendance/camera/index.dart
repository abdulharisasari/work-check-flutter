import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:workcheckapp/commons/widgets/custom_button.dart';
import 'package:workcheckapp/models/attendance_model.dart';
import 'package:workcheckapp/providers/attandance_provider.dart';
import 'package:workcheckapp/routers/constant_routers.dart';
import 'package:workcheckapp/services/snack_bar.dart';
import 'package:workcheckapp/services/themes.dart';
import 'package:workcheckapp/services/utils.dart';
import 'camera_view.dart';
import 'face_detector_painter.dart';
import 'package:workcheckapp/services/assets.dart';
import 'package:http/http.dart' as http;


class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  CameraController? _cameraController;
  bool _canProcess = true;
  bool _isBusy = false;
  bool _pictureTaken = false;
  bool _faceInsideGuide = false;
  bool _facesDetected = false;
  CustomPaint? _customPaint;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          title: '',
          customPaint: _customPaint,
          onImage: processImage,
          initialDirection: CameraLensDirection.front,
          onCameraControllerReady: (controller) {
            _cameraController = controller;
          },
        ),
        Positioned(
          top: 40,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // if (!_facesDetected)
        //   Positioned(
        //     top: 180,
        //     left: 0,
        //     right: 0,
        //     child: Center(
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //         color: Colors.black54,
        //         child: const Text(
        //           'Wajah tidak terdeteksi',
        //           style: TextStyle(color: Colors.white, fontSize: 18),
        //         ),
        //       ),
        //     ),
        //   ),
        if (!_facesDetected)
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Image.asset(frameSelfiePng, height: 300,),
              ),
            ),
          ),
        if (!_facesDetected)

        // if (_faceInsideGuide && !_pictureTaken)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child:Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(pureWhiteColor)
                ),
                child: IconButton(
                  onPressed: _takePicture,
                  icon:  Icon(Icons.camera_alt, size: 24.0),
                ),
              ),
              
            ),
          ),
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy || _pictureTaken) return;
    _isBusy = true;

    final faces = await _faceDetector.processImage(inputImage);
    _facesDetected = faces.isNotEmpty;

    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final guideBox = Rect.fromLTWH(
        0,
        0,
        inputImage.inputImageData!.size.width.toDouble(),
        inputImage.inputImageData!.size.height.toDouble(),
      );

      bool faceDetected = false;
      for (final face in faces) {
        final rect = Rect.fromLTRB(
          translateX(face.boundingBox.left, inputImage.inputImageData!.imageRotation, inputImage.inputImageData!.size),
          translateY(face.boundingBox.top, inputImage.inputImageData!.imageRotation, inputImage.inputImageData!.size),
          translateX(face.boundingBox.right, inputImage.inputImageData!.imageRotation, inputImage.inputImageData!.size),
          translateY(face.boundingBox.bottom, inputImage.inputImageData!.imageRotation, inputImage.inputImageData!.size),
        );
        if (guideBox.contains(rect.topLeft) && guideBox.contains(rect.bottomRight)) {
          faceDetected = true;
          break;
        }
      }

      if (_faceInsideGuide != faceDetected) {
        setState(() {
          _faceInsideGuide = faceDetected;
        });
      }

      _customPaint = CustomPaint(
        painter: FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          guideBox,
          (_) {},
        ),
      );
    } else {
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) setState(() {});
  }

  double translateX(double x, InputImageRotation rotation, Size size) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x * size.width / size.height;
      case InputImageRotation.rotation270deg:
        return size.width - x * size.width / size.height;
      default:
        return x;
    }
  }

  double translateY(double y, InputImageRotation rotation, Size size) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / size.width;
      default:
        return y;
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || _pictureTaken) return;
    _pictureTaken = true;

    try {
      await _cameraController!.stopImageStream();

      // final image = await _cameraController!.takePicture();
      final image = await _cameraController!.takePicture();

      if (!mounted) return;

      
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DisplayPictureScreen(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
      _pictureTaken = false;
    }
  }
}


class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isLoading = false;
  String locationText = 'Memuat lokasi...';
  DateTime? timestamp;
  
  @override
  void initState() {
    _getLocationAndTime();
    super.initState();
  }
  
  Future<String> convertImageToBase64(String filePath) async {
      final bytes = await File(filePath).readAsBytes();
      return "data:image/jpeg;base64," + base64Encode(bytes);
    }
    
  Future<void> createAttandance() async {
    setState(() {
      _isLoading = true;
    });

    final attandanceProv = Provider.of<AttandanceProvider>(context, listen: false);
    final base64Image = await convertImageToBase64(widget.imagePath); // ini sudah ada

    final attendanceModel = AttendanceModel(
      id: 1,
      userId: 1,
      imgUrl: null, // pakai base64
      date: timestamp.toString().split(' ')[0],
      time: timestamp.toString().split(' ')[1].split('.')[0],
      address: locationText,
      status: 1,
    );

    try {
      final response = await attandanceProv.createAttandance(context, attendanceModel);
      if (response != null) {
        if (response.code == 200) {
          Navigator.pushReplacementNamed(context, attendanceRoute);
        } else {
          showSnackBar(context, response.message);
        }
      }
    } catch (e) {
      debugPrint('Error in createAttandance: $e');
      showSnackBar(context, 'Gagal mengirim absen. Silakan coba lagi.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _getLocationAndTime() async {
    setState(() {
      _isLoading = true;
    });
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
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading?Center(child: CircularProgressIndicator()): Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(widget.imagePath), fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Color(primaryColor).withOpacity(0.7),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              icDate,
                              height: 24,
                            ),
                            SizedBox(height: 10),
                            Container(height: 70, alignment: Alignment.topLeft, child: Icon(Icons.location_on, size: 24, color: Color(coralFlameColor))),
                          ],
                        ),
                      ),
                      Container(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timestamp != null ? '${timestamp!.toLocal()}' : 'Memuat waktu...',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 70,
                              child: Text(
                                locationText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: CustomButton(text: "KIRIM ABSEN", onPressed: ()async {
                        await createAttandance();
                      }, backgroundColor: Color(tealBreezeColor))),
                      SizedBox(width: 20),
                      Expanded(
                          child: CustomButton(
                        text: "ULANGI",
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, cameraRoute);
                        },
                        backgroundColor: Color(primaryColor).withOpacity(0.0),
                        borderColor: Color(tealBreezeColor),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

