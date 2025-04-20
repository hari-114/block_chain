import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({required String name, required String phone}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = _firestore.collection('users').doc(uid);

    await userDoc.set({
      'name': name,
      'phone': phone,
      'created_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    return _firestore.collection('users').doc(uid).get();
  }
}
