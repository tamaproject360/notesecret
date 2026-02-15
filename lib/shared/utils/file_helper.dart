import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return await saveFileToAppStorage(File(image.path));
  }

  static Future<String> saveFileToAppStorage(File file) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String attachmentsDir = path.join(appDir.path, 'attachments');
    
    final Directory dir = Directory(attachmentsDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    final String newPath = path.join(attachmentsDir, fileName);
    
    await file.copy(newPath);
    return newPath;
  }

  static Future<void> deleteFile(String filePath) async {
    final File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
