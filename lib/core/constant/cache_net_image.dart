import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

class MyCacheNetWorkImage extends StatelessWidget {
  const MyCacheNetWorkImage({
    super.key,
    required this.imageUrl,
    this.imageBytes,
    this.width = 60,
    this.height = 60,
    this.profileImage = true,
    this.useAuth = true,
  });

  final String imageUrl;
  final Uint8List? imageBytes;
  final double width;
  final double height;
  final bool profileImage;
  final bool useAuth;

  Future<String?> _getToken() async {
    if (!useAuth) return null;
    return await const FlutterSecureStorage().read(key: 'token');
  }

  Widget _errorWidget() {
    return profileImage
        ? const Image(image: AssetImage('assets/images/empty_profile.png'))
        : SvgPicture.asset(SvgMyAsset.imageBox, height: height, width: width);
  }

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }

    if (!useAuth) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => _errorWidget(),
      );
    }

    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        final headers = token != null ? {"Authorization": "Bearer $token"} : null;

        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          httpHeaders: headers,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              profileImage ? _errorWidget() : Icon(Icons.error, color: Colors.blueGrey, size: height),
        );
      },
    );
  }
}
