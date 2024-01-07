
// Author: Diwas Adhikari
// Firebase Authentication Stuff here !!!

import 'package:firebase_auth/firebase_auth.dart' ;

class Authentication{

  String? errorDialog = "" ;
  final FirebaseAuth _auth = FirebaseAuth.instance ; // just made it a private instance

  User? get currentUser => _auth.currentUser ;
  Future<Stream<User?>> get changes async => await _auth.authStateChanges() ;

  Future<bool> registerUser({required String email, required String password}) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password) ;
      return true ;
    } on FirebaseAuthException catch (e){
          errorDialog = e.message ;
          return false ;
    }
  }

  Future<bool> signInUser({required String email, required String password}) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((msg){
        print('Logged in successfully - ${currentUser?.displayName}') ;
      }) ;
      return true ;
    } on FirebaseAuthException catch (e) {
        errorDialog = e.message ;
        print(errorDialog) ;
        return false ;
    }
  }

  Future<void> signOut() async{
    await _auth.signOut().then((msg){
      print('Signed out successfully !') ;
    }) ;
  }

  Future<void> setInfoForCurrentUser(String name) async{
    await _auth.currentUser?.updateDisplayName(name) ;
  }

}

