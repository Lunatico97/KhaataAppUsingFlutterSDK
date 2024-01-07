// Author: Diwas Adhikari
// Structures and classes to save user's info

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  final String? id ;
  final String name, number, email, hash ;
  final int avatarIndex, inBalance, outBalance ;
  final List<dynamic> friends ;

  UserData({ required this.id, required this.name, required this.number, required this.email,
    required this.hash, required this.friends, required this.avatarIndex, required this.inBalance, required this.outBalance}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'id' : id, 'name' : name, 'number' : number, 'email': email, 'hash' : hash, 'friends' : friends, 'avatarIndex' : avatarIndex,
    'inBalance': inBalance, 'outBalance': outBalance

  } ;

  // Read the JSON from the document in the cloud store and convert to an user object with the tuple data
  // (Two methods to do the same - hahhahaha) !
  static UserData fromJSON(Map<String, dynamic> json) =>
      UserData(id: json['id'], name : json['name'], number : json['number'],
          email: json['email'], hash : json['hash'], friends : json['friends'], avatarIndex: json['avatarIndex'],
          inBalance: json['inBalance'], outBalance: json['outBalance']) ;

  factory UserData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
    final data = docu.data()! ; // null checks are lame in Dart !
    return UserData(id: data['id'], name: data['name'], number: data['number'],
        email: data['email'], hash: data['hash'], friends: data['friends'], avatarIndex: data['avatarIndex'],
        inBalance: data['inBalance'], outBalance: data['outBalance']) ;
  }
}