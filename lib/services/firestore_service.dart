import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Central Firestore service providing user-scoped collection references.
/// All data is stored under users/{uid}/ so each user only sees their own data.
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _db.collection('users').doc(_uid);

  CollectionReference<Map<String, dynamic>> get medicinesCollection =>
      _userDoc.collection('medicines');

  CollectionReference<Map<String, dynamic>> get appointmentsCollection =>
      _userDoc.collection('appointments');

  CollectionReference<Map<String, dynamic>> get profileCollection =>
      _userDoc.collection('profile');

  CollectionReference<Map<String, dynamic>> get checkInsCollection =>
      _userDoc.collection('checkIns');
}
