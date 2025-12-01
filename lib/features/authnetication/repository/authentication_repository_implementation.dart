import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/api_errors.dart';
import '../../../core/helpers/firebase_helper.dart';
import '../../../core/helpers/hive_helper.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  @override
  Future<Either<Failure, ProfileModel>> login(
      String email, String password, BuildContext context) async {
    try {
      // Sign in with Firebase
      final userCredential = await FirebaseHelper.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final userDoc = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return const Left(ServerFailure('User data not found'));
      }

      final userData = userDoc.data()!;
      final profileData = ProfileData(
        id: userCredential.user!.uid,
        name: userData['name'] ?? '',
        email: userData['email'] ?? email,
        phone: userData['phone'] ?? '',
        image: userData['image'],
        token: userCredential.user!.uid,
      );

      return Right(ProfileModel(
        status: true,
        message: 'Login successful',
        data: profileData,
      ));
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password';
          break;
        case 'user-disabled':
          message = 'This user has been disabled';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void saveProfileDataLocally(ProfileData profile) {
    HiveHelper.setToken(profile.token!);
    HiveHelper.setUser(profile);
  }

  @override
  Future<Either<Failure, ProfileModel>> register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum, required BuildContext context}) async {
    try {
      // Create user with Firebase Auth
      final userCredential = await FirebaseHelper.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phone': phoneNum,
        'image': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final profileData = ProfileData(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phoneNum,
        image: null,
        token: userCredential.user!.uid,
      );

      return Right(ProfileModel(
        status: true,
        message: 'Registration successful',
        data: profileData,
      ));
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
