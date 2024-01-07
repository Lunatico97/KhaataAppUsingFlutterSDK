

import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';

import '../models/structure.dart';
import '../models/transaction.dart';

/*
 Author: Diwas Adhikari
 {I am a sucker for classes and getters/setters - it sucks that I don't know if templates exist in Dart !}
 */

class FriendLoader{
  List<dynamic> friends = [] ;
  List<UserData> friendDetails = [] ;
  List<UserData> matchedQuery = [] ;

  List<dynamic> get fetchFriends => friends ;
  List<UserData> get fetchFriendDetails => friendDetails ;
  var auth = Authentication() ;

  // Backend utilities {Diwas - Don't mess with field names !}
  // I will first get all ids of friends for current user !
  Future<void> getFriendsFromID() async{
    String reqID = auth.currentUser?.uid as String ;
    await Userbase().getUserDetails("id", reqID).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
        friends = specified.friends ;
    });
  }

  // Now I will use the list to get details of friends - Sneaky MOVE - HAHAHA !
  Future<void> getFriendDetails() async {
    await getFriendsFromID();
    for (var i = 0; i < friends.length; i++) {
      await Userbase()
          .getUserDetails("id", friends[i].toString())
          .then((specified) {
        // Forget setState and I lost my shit - hahahaha !
           friendDetails.insert(i, specified);
      });
    }
  }
}