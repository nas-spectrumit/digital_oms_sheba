import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CropScreenWidget extends StatefulWidget {
  final Uint8List imageData;
  final double ratioX;
  final double ratioY;

  const CropScreenWidget({
    super.key,
    required this.imageData,
    this.ratioX = 3,
    this.ratioY = 2,
  });

  @override
  State<CropScreenWidget> createState() => _CropScreenWidgetState();
}

class _CropScreenWidgetState extends State<CropScreenWidget> {
  final CropController _controller = CropController();
  bool _isCropping = false;
  bool _isReady = false;

  Future<void> _saveCropped(CropResult result) async {
    if (result is CropSuccess) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/cropped_image.png');
      await file.writeAsBytes(result.croppedImage);

      if (!mounted) return;
      Navigator.of(context).pop(file.path);
    } else if (result is CropFailure) {
      if (!mounted) return;

      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Crop failed: ${result.cause}')),
      );

      setState(() {
        _isCropping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.ratioX / widget.ratioY;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Crop(
                  controller: _controller,
                  image: widget.imageData,
                  aspectRatio: aspectRatio,
                  onCropped: _saveCropped,
                  onStatusChanged: (status) {
                    if (status == CropStatus.ready || status == CropStatus.cropping) {
                      setState(() {
                        _isReady = true;
                      });
                    } else {
                      setState(() {
                        _isReady = false;
                      });
                    }
                  },
                  withCircleUi: false,
                  maskColor: Colors.black.withValues(alpha: .8), // darken outside area
                  baseColor: Colors.black,
                  interactive: false, // allow drag to move crop area
                  progressIndicator: CupertinoActivityIndicator(radius: 25),
                  cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(), // hide resize handles
                  // cornerDotBuilder: (size, edgeAlignment) => Container(
                  //   width: size,
                  //   height: size,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                ),
                if (_isReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: _isCropping
                            ? null
                            : () {
                                setState(() {
                                  _isCropping = true;
                                });
                                _controller.crop();
                              },
                        child: _isCropping
                            ? const CupertinoActivityIndicator(color: Colors.white)
                            : const Icon(
                                Icons.check,
                                size: 26,
                                color: Colors.white,
                              ),
                      ),
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
