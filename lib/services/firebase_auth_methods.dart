import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_branch_customer/services/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/authmodels/users.dart';




class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCreaditials> getUserDetails() async {
    log("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .catchError(
      (onError) {
        throw Exception(onError);
      },
    );

    return UserCreaditials.fromSnap(snapshot);
  }
  // Creating the function which is responsible for the auth related work

  // creating the function to create the user
  Future<String> createUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error Occured";
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential.user!.uid);
      // email verification
      String verifyRes = await sendVerification(context);

      if (verifyRes == 'success') {
        // const url = "https://mail.google.com/";
        // html.window.open(url, "Gmail.com");
        res = "success";
      } else {
   //     showSnakeBar(verifyRes, context);
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
    //    showSnakeBar("The password provided is too weak.", context);
      } else if (err.code == 'email-already-in-use') {
     //   showSnakeBar("The account already exists for that email.", context);
      }
    }
    return res;
  }

// Email Verification
  Future<String> sendVerification(
    BuildContext context,
  ) async {
    String res = "Some error occured";
    try {
      _auth.currentUser!.sendEmailVerification();
 //     showSnakeBar("Email Verification is send to your email.", context);
      res = "success";
    } on FirebaseException catch (e) {
     // showSnakeBar(e.message!, context);
    }
    return res;
  }

  // complete profile
  Future<String> completeProfile({
   // required Uint8List licencePic,
   // required Uint8List istemaraPic,
   // required Uint8List identityPic,
    required String fullname,
  //  required String email,
    //required String password,
//    required String lastName,
    required String phoneNumber,
    required String address,
  //  required String country,
    //required String age,
    //required String gender,
    required BuildContext context,
    // required List? cart,
  }) async {
    String res = "Some error occured";
    try {
   //   createUser(email: email, password: password, context: context);

      UserCreaditials userCreaditials = UserCreaditials(
        email: _auth.currentUser!.email!,
        uid: _auth.currentUser!.uid,

        fullname: fullname,
        //lastName: lastName,
        address: address,
       // age: age,
       // gender: gender,
      //  country: country,
        phoneNo: phoneNumber,
        // cart: cart!,
      );
      _firebaseFirestore
          .collection("customers")
          .doc(_auth.currentUser!.uid)
          .set(userCreaditials.toJson());
      res = "success";
    } on FirebaseAuthException catch (err) {
   //   showSnakeBar(err.message!, context);
    }
    return res;
  }

  // login
  Future<String> userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occured.";
    // checking the values are empty or not
    try {
      // now checking and login the user
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //     if (!_auth.currentUser!.emailVerified) {
      //     await _auth.currentUser!.sendEmailVerification();
      // const url = "https://mail.google.com/";
      // html.window.open(url, "Gmail.com");
      //  showSnakeBar("Verify the email first.", context);
      //  } else {
      res = "success";
      //  }
    } on FirebaseAuthException catch (err) {
      if (err.code == "wrong-password") {
        // showSnakeBar("Invalid Creaditials", context);
      }
    } catch (err) {
      //  showSnakeBar(err.toString(), context);
    }
    return res;
  }
 /* Future<String> userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occured.";
    // checking the values are empty or not
    try {
      // now checking and login the user
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
 //     if (!_auth.currentUser!.emailVerified) {
   //     await _auth.currentUser!.sendEmailVerification();
        // const url = "https://mail.google.com/";
        // html.window.open(url, "Gmail.com");
      //  showSnakeBar("Verify the email first.", context);
    //  } else {
        res = "success";
    //  }
    } on FirebaseAuthException catch (err) {
      if (err.code == "wrong-password") {
       // showSnakeBar("Invalid Creaditials", context);
      }
    } catch (err) {
    //  showSnakeBar(err.toString(), context);
    }
    return res;
  }*/
  // google sign in
/*
  Future<String> googleSignInOrSignUp({required BuildContext context}) async {
    String res = "Some error Found";
    try {
     // final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await _googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCreaditails =
            await _auth.signInWithCredential(credential);
        print(userCreaditails.user!.uid);
        print(userCreaditails.user!.displayName);
        // googel signup
        if (userCreaditails.user != null) {
          if (userCreaditails.additionalUserInfo!.isNewUser) {
            print("singup hererer new user");
          }
        }
        res = 'success';
      }
    } on FlutterExceptionHandler catch (e) {
      res = e.toString();
    }
    return res;
  }*/

  // forgot password
  Future<String> forgotPassword(
      {required BuildContext context, required String email}) async {
    String res = "Some error occred";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = 'success';
    } on FirebaseException catch (e) {
     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ")));
      log(e.toString());
    }
    return res;
  }

  // signout
  Future<String> signOut() async {
    String res = "Some error Occured";
    try {
      await _auth.signOut();
      res = "Logout Done.";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // post comments
  Future<String> addToCart({
    required String uid,
    required String productId,
    required String productPic,
    required String productPrice,
    required String productTitle,
   required String productDescription,
    required String category,
  }) async {
    String res = "Some error Occured";
    try {
      String cartId = uid[0].toLowerCase().codeUnits[0] >
          productTitle.toLowerCase().codeUnits[0]?"$uid$productTitle":"$productTitle$uid";//Uuid().v1();
      await _firebaseFirestore
          .collection('customers')
          .doc(uid)
          .collection("cart")
          .doc(cartId)
          .set({
        "cartId": cartId,
        "uid": uid,
        "postId": productId,
        "postPic": productPic,
        "postPrice": productPrice,
        "postTitle": productTitle,
        "postDesc":productDescription,
        "category":category
       // "postLocation": postLocation,
      //  "datePublished": DateTime.now(),
      });
      res = "The item is added to the wishlist.";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
