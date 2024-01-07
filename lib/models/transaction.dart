
// Author: Diwas Adhikari
// Structures and classes to save user's info

import 'package:cloud_firestore/cloud_firestore.dart';

class Record{
  final String? transactionID ;
  final String borrowerID, lenderID ;
  final String remarks ;
  final Timestamp transactionDate ;
  final int amount ;

  Record({required this.transactionID, required this.borrowerID, required this.lenderID, required this.transactionDate,
          required this.amount, required this.remarks}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'transactionID' : transactionID, 'borrowerID' : borrowerID, 'lenderID' : lenderID, 'transactionDate': transactionDate,
    'amount' : amount, 'remarks' : remarks
  } ;

  // Read the JSON from the document in the cloud store and convert to an user object with the tuple data
  // (Two methods to do the same - hahhahaha) !
  static Record fromJSON(Map<String, dynamic> json) =>
      Record(transactionID: json['transactionID'], borrowerID : json['borrowerID'],
                  lenderID : json['lenderID'], transactionDate: json['transactionDate'],
                  amount: json['amount'], remarks: json['remarks']) ;

  factory Record.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
    final json = docu.data()! ; // null checks are lame in Dart !
    return Record(transactionID: json['transactionID'], borrowerID : json['borrowerID'],
                  lenderID : json['lenderID'], transactionDate: json['transactionDate'],
                  amount: json['amount'], remarks: json['remarks']) ;
  }
}