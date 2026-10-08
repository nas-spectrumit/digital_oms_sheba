import 'dart:io';

import 'package:camera/camera.dart';
import 'package:digital_oms_sheba/core/card_capture_widget/card_overlay_camera.dart';
import 'package:digital_oms_sheba/core/constant/alerts_custom.dart';
import 'package:digital_oms_sheba/core/constant/crop_screen_widget.dart';
import 'package:digital_oms_sheba/core/constant/loadin_overlay.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//Usage
//  final cameras = await availableCameras();
//               void if (context.mounted) {
//                 pushPage(
//                   context,

//                   KycCardCaptureCamera(
//                     cameras: cameras,
//                     onImageCaptured: (String imagePath) {
//                       // Handle the captured image path here
//                       debugPrint('Captured: $imagePath');
//                     },
//                     // optional — override the hint text
//                     hint: '',
//                   ),
//                 );
//               }
//             },

class KycCardCaptureCamera extends StatefulWidget {
  const KycCardCaptureCamera({
    super.key,
    required this.fileName,
    required this.cameras,
    required this.onImageCaptured,
    this.hint = 'Take a front photo of your card',
  });

  final String fileName;

  /// Available camera list — pass the result of `availableCameras()`.
  final List<CameraDescription> cameras;

  /// Called with the final compressed image file path when capture is complete.
  final ValueChanged<String> onImageCaptured;

  /// Hint text shown at the top of the camera view.
  final String hint;

  @override
  State<KycCardCaptureCamera> createState() => _KycCardCaptureCameraState();
}

class _KycCardCaptureCameraState extends State<KycCardCaptureCamera> {
  late CameraController _cameraController;

  bool _isReady = false; // camera initialized
  bool _isCapturing = false; // shutter pressed, waiting for photo

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // ─── Camera init ──────────────────────────────────────────────────────────

  Future<void> _initCamera() async {
    _cameraController = CameraController(widget.cameras.first, ResolutionPreset.max, enableAudio: false);
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() => _isReady = true);
  }

  // ─── Capture flow ─────────────────────────────────────────────────────────

  /// Step 1: Take photo.
  Future<void> _takePicture() async {
    if (!_isReady || _isCapturing) return;
    setState(() => _isCapturing = true);
    MyGlobalLoader.show('দয়া করে অপেক্ষা করুন');
    try {
      final XFile photo = await _cameraController.takePicture();
      await _openCropScreen(photo.path);
      // await _processAndReturn(photo.path); // bypass crop (testing only)
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      MyGlobalLoader.hide();
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  /// Step 2: Open crop screen — returns cropped image path.
  Future<void> _openCropScreen(String rawImagePath) async {
    // Loader is already showing from step 1 — keep it while reading bytes.
    final bytes = await File(rawImagePath).readAsBytes();
    if (!mounted) return;

    // Hide loader before pushing crop screen so the user can interact with it.
    MyGlobalLoader.hide();

    final String? croppedPath = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => CropScreenWidget(imageData: bytes, ratioX: 3, ratioY: 2)));

    if (croppedPath == null) return; // user cancelled

    await _processAndReturn(croppedPath);
  }

  /// Step 3: Compress the cropped image and fire the callback.
  Future<void> _processAndReturn(String imagePath) async {
    MyGlobalLoader.show('Processing photo...');
    try {
      final Directory tempDir = await getTemporaryDirectory();
      if (!mounted) return;
      final String outputPath = '${tempDir.path}/${widget.fileName}_${DateTime.now().microsecondsSinceEpoch}.jpg';

      // final XFile compressed = await Provider.of<ImageController>(
      //   context,
      //   listen: false,
      // ).compressAndSaveImage(File(imagePath), outputPath, minHeight: 1920, minWidth: 1080, maxFileSize: 490);

      // debugPrint('Card image size: ${(await File(compressed.path).length() / 1024).toStringAsFixed(2)} KB');
      // widget.onImageCaptured(compressed.path);  // return result to caller (with compression)
      // Copy original file to outputPath (rename with card_<timestamp>.jpg)

      await File(imagePath).copy(outputPath);
      debugPrint('Card Image Original Size: ${(await File(outputPath).length() / 1024).toStringAsFixed(2)} KB');
      widget.onImageCaptured(outputPath); // return result to caller (no compression)
    } catch (e, stack) {
      debugPrint('Image processing failed: $e\n$stack');
      if (mounted) {
        showCustomMaterialAlert(context: context, message: 'ছবি প্রসেসিং ব্যর্থ হয়েছে');
      }
    } finally {
      MyGlobalLoader.hide();
    }
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Show loader while camera is initializing.
    if (!_isReady) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Stack(
        children: [
          // Camera preview — centered and fitted to avoid zoom/stretch.
          Center(child: CameraPreview(_cameraController)),

          // ID card guide overlay.
          const IDCardOverlay(),

          // Capture button — hidden while taking a photo.
          if (!_isCapturing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),

          // Hint text at the top.
          if (widget.hint.isNotEmpty) _HintBanner(text: widget.hint),
        ],
      ),
    );
  }
}

// ─── Sub-widget ───────────────────────────────────────────────────────────────

class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * .05,
      left: MediaQuery.of(context).size.width * .1,
      right: MediaQuery.of(context).size.width * .1,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
