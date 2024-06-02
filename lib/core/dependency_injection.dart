import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import './dependency_injection.config.dart';
import 'config/config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class FirebaseModule {
  @Named('FirebaseAuthInstance')
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @Named('GoogleSignInInstance')
  GoogleSignIn googleSignIn() => GoogleSignIn(clientId: kIsWeb ? googleSignInClientId : null);

  @Named('FacebookAuthInstance')
  FacebookAuth facebookAuth() => FacebookAuth.instance;
}