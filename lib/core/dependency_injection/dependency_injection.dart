import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_connect/core/dependency_injection/dependency_injection.config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../config/config.dart';

const String firebaseAuthInstance = 'FirebaseAuthInstance';
const String googleSignInInstance = 'GoogleSignInInstance';
const String facebookAuthInstance = 'FacebookAuthInstance';
const String firebaseFirestoreInstance = 'FirebaseFirestoreInstance';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class AuthModule {
  @Named(firebaseAuthInstance)
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @Named(googleSignInInstance)
  GoogleSignIn googleSignIn() =>
      GoogleSignIn(clientId: kIsWeb ? googleSignInClientId : null);

  @Named(facebookAuthInstance)
  FacebookAuth facebookAuth() => FacebookAuth.instance;

  @Named(firebaseFirestoreInstance)
  FirebaseFirestore firestore() => FirebaseFirestore.instance;

  @lazySingleton
  Dio get dio => Dio();
}
