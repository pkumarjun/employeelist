// Helper class to do image conversions

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Helper class for Image conversions. ie network image to bytes and base64 types
class ImageUtility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Future<String> getImageFromNetwork(String? url) async {
    if (url != "- NA -") {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(url!)).load("");
      return base64String(
        imageData.buffer.asUint8List(),
      );
    } else {
      return "- NA -";
    }
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
