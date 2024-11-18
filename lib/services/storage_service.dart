import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadProfileImage(String uid, File imageFile) async {
    Reference ref = _storage.ref().child('profileImages').child('$uid.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
