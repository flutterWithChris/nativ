import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nativ/data/repositories/base_database_repository.dart';
import 'package:nativ/data/repositories/storage/storage_repository.dart';

import '../model/user.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  void storeUserInfoDB(String userId, User user) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(user.toMap());
  }

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<DocumentSnapshot> getUserFromDB(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).get();
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document update: ${user.id}'));
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }
}
