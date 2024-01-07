
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - Request Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import 'package:khaata_app/backend/authentication.dart';
import '../models/friendRequest.dart';

class RequestUtility{
  final _database = FirebaseFirestore.instance ;
  String collectionPath = "friend-requests" ; // Don't mess with this as well - HAHAHA !

  // Create a friend request (C)
  createNewRequest(FriendRequest friendToBe) async {
    await _database.collection(collectionPath).add(friendToBe.toJSON())
        .whenComplete((){
      // do smth
    })
        .catchError((error){
      print("Error: + $error") ;
    }) ;
  }

  // Fetch all friend requests sent to the current user (R)
  Future<List<FriendRequest>> fetchFriendRequests() async{
    String reqID = Authentication().currentUser?.uid as String ;
    final snapShot = await _database.collection(collectionPath).where("toID", isEqualTo: reqID).get() ;
    final data = snapShot.docs.map((e) => FriendRequest.fromSnapshot(e)).toList() ;
    return data ;
  }

  // Delete(D)
  deleteRequest(String byRequestID, String toRequestID) async{
    final snapShot = await _database.collection(collectionPath)
        .where("byID", isEqualTo: byRequestID)
        .where("toID", isEqualTo: toRequestID).get() ;
    final data = snapShot.docs.single ;
    await _database.collection(collectionPath).doc(data.id).delete() ;
  }

  // Checkers
  Future<bool> isRequestPending(String byID, String toID) async{
    String reqID = Authentication().currentUser?.uid as String ;
    final snapShot = await _database.collection(collectionPath)
        .where("byID", isEqualTo: byID).where("toID", isEqualTo: toID).get() ;
    if(snapShot.docs.isNotEmpty){
      print("Request is pending !") ;
      return true ;
    }
    else{
      return false ;
    }
  }
}

