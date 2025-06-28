import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Hàm chọn ảnh từ gallery và nén lại để tối ưu dung lượng
Future<List<String>> pickAndCompressMultipleImages() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: true,
  );

  if (result == null || result.files.isEmpty) return [];

  final tempDir = await getTemporaryDirectory();
  List<String> compressedPaths = [];

  for (var file in result.files) {
    final original = File(file.path!);
    final targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_${file.name}.jpg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      original.absolute.path,
      targetPath,
      quality: 70,
    );

    if (compressedFile != null) {
      compressedPaths.add(compressedFile.path);
    }
  }

  return compressedPaths;
}
