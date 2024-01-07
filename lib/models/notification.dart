
// Author: Diwas Adhikari
// Structures and classes to save user's info

import 'package:cloud_firestore/cloud_firestore.dart';

class Notify{
  final String toID ;
  final String message ;
  final bool seen ;
  final Timestamp time ;

  Notify({required this.toID, required this.message, required this.seen, required this.time}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'toID' : toID, 'message' : message, 'seen' : seen, 'time': time
  } ;

  static Notify fromJSON(Map<String, dynamic> json) =>
      Notify(toID: json['toID'], message : json['message'],
          seen : json['seen'], time: json['time']) ;

  factory Notify.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
    final json = docu.data()! ; // null checks are lame in Dart !
    return Notify(toID: json['toID'], message : json['message'],
        seen : json['seen'], time: json['time']) ;
  }
}