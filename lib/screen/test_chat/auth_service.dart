import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUserFirebase(
      {required String email,
      required String password,
      required String displayName,
      required String photoPath,
      required String phoneNumber}) async {
    try {
      String? tokenDevice = await SecureStorageUtils.readString('notifyToken');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        if (user != null) {
          await firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'displayName': displayName,
            'photoPath': photoPath,
            'phoneNumber': phoneNumber,
            'pushToken': [tokenDevice],
            'createdAt': FieldValue.serverTimestamp(),
          });
          debugPrint('Account created for $email');
        }
      } else {
        loginUserFirebase(email, password, displayName, photoPath, phoneNumber);
      }
    } catch (e) {
      debugPrint('Error creating account: $e');
    }
  }

  Future<User?> loginUserFirebase(String email, String password,
      String displayName, String photoPath, String phoneNumber) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await updateInfoUser(
          email: email,
          displayName: displayName,
          photoPath: photoPath,
          phoneNumber: phoneNumber);
      return cred.user;
    } catch (e) {
      log("Something went wrong : $e");
    }
    return null;
  }

  Future<User?> updateInfoUser(
      {required email,
      required displayName,
      required photoPath,
      required phoneNumber}) async {
    try {
      String? tokenDevice = await SecureStorageUtils.readString('notifyToken');
      DocumentReference userDoc =
          firestore.collection('users').doc(auth.currentUser!.uid);
      await userDoc.get().then((DocumentSnapshot doc) async {
        if (doc.exists) {
          await userDoc.update({
            'pushToken': FieldValue.arrayUnion([tokenDevice]),
          });
        } else {
          await userDoc.set({
            'uid': auth.currentUser!.uid,
            'email': email,
            'displayName': displayName,
            'photoPath': photoPath,
            'phoneNumber': phoneNumber,
            'pushToken': [tokenDevice],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });
      debugPrint("tokenDevice:$tokenDevice");
      return auth.currentUser;
    } catch (e) {
      log("Something went wrong : $e");
    }
    return null;
  }

  Future<DocumentSnapshot> getUsers(receiverId) {
    return firestore.collection('users').doc(receiverId).get();
  }

  Stream<QuerySnapshot> getListUsers() {
    return firestore
        .collection('users')
        .where('uid', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  Future<void> signout() async {
    try {
      String? tokenDevice = await SecureStorageUtils.readString('notifyToken');
      DocumentReference userDoc =
          firestore.collection('users').doc(auth.currentUser!.uid);
      await userDoc.update({
        'pushToken': FieldValue.arrayRemove([tokenDevice]),
      });
      await auth.signOut();
    } catch (e) {
      log("Something went wrong : $e");
    }
  }
}
