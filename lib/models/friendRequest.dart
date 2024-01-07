
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest{
  final String? byID, toID ;
  final String sender ;
  FriendRequest({required this.byID, required this.toID, required this.sender}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'byID' : byID, 'toID' : toID, 'sender': sender
  } ;

  static FriendRequest fromJSON(Map<String, dynamic> json) =>
      FriendRequest(byID: json['byID'], toID: json['toID'], sender: json['sender']) ;

  factory FriendRequest.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
    final json = docu.data()! ; // null checks are lame in Dart !
    return FriendRequest(byID: json['byID'], toID: json['toID'], sender: json['sender']) ;
  }
}