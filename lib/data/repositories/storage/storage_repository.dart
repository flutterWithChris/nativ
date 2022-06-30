import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:nativ/data/model/user.dart';
import 'package:nativ/data/repositories/database_repository.dart';
import 'package:nativ/data/repositories/storage/base_storage_repository.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(User user, XFile image) async {
    try {
      await storage
          .ref('${user.id}/${image.name}')
          .putFile(
            File(image.path),
          )
          .then((p0) =>
              DatabaseRepository().updateUserPictures(user, image.name));
    } catch (_) {}
  }

  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String dowloadURL =
        await storage.ref('${user.id}/$imageName').getDownloadURL();
    return dowloadURL;
  }
}
