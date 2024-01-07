
import 'package:cloud_firestore/cloud_firestore.dart';

class Bill{
  final String? billID ;
  final String byID, toID ;
  List<dynamic> items= [] ;
  List<dynamic> quantities = [] ;
  List<dynamic> rates = [] ;
  final Timestamp time ;
  Bill({required this.billID, required this.byID, required this.toID, required this.items,
        required this.quantities, required this.rates, required this.time}) ;

  // Convert tuple to JSON so that we can later push it to the cloud store
  Map<String, dynamic> toJSON() => {
    'billID': billID, 'byID' : byID, 'toID' : toID, 'items': items, 'quantities': quantities, 'rates': rates, 'time': time
  } ;

  static Bill fromJSON(Map<String, dynamic> json) =>
      Bill(billID: json['billID'], byID: json['byID'], toID: json['toID'], items: json['items'], quantities:  json['quantities'],
          rates: json['rates'], time: json['time']) ;

  factory Bill.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu){
    final json = docu.data()! ; // null checks are lame in Dart !
    return Bill(billID: json['billID'], byID: json['byID'], toID: json['toID'], items: json['items'], quantities:  json['quantities'],
        rates: json['rates'], time: json['time']) ;
  }
}