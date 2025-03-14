import 'dart:convert';
import 'dart:typed_data';

class SavaImage {
  Uint8List? imageBytes;

  SavaImage({ this.imageBytes});

  factory SavaImage.fromJson(Map<String, dynamic> json) {
    return SavaImage(
      imageBytes: json['imageBytes'] != null ? base64Decode(json['imageBytes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }
}
class SavaPdf {
  Uint8List? pdfBytes;

  SavaPdf({this.pdfBytes,});

  factory SavaPdf.fromJson(Map<String, dynamic> json) {
    return SavaPdf(
      pdfBytes: json['pdfBytes'] != null ? base64Decode(json['pdfBytes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdfBytes': pdfBytes != null ? base64Encode(pdfBytes!) : null,
    };
  }
}