
// Author: Diwas Adhikari
// Firebase Access and CRUD Stuff - Bills Utility

import "package:cloud_firestore/cloud_firestore.dart" ;
import 'package:khaata_app/backend/authentication.dart';
import '../models/bill.dart';

class BillUtility{
  final _database = FirebaseFirestore.instance ;
  String collectionPath = "bills" ; // Don't mess with this as well - HAHAHA !

  // Create a new bill (C)
  createNewBill(Bill newBill) async {
    await _database.collection(collectionPath).add(newBill.toJSON())
        .whenComplete((){
      // do smth
    })
        .catchError((error){
      print("Error: + $error") ;
    }) ;
  }

  // Fetch bills created by the current user (R)
  Future<List<Bill>> fetchBills() async{
    String reqID = Authentication().currentUser?.uid as String ;
    final snapShot = await _database.collection(collectionPath).where("toID", isEqualTo: reqID)
                      .orderBy("time", descending: true).get() ;
    final data = snapShot.docs.map((e) => Bill.fromSnapshot(e)).toList() ;
    return data ;
  }

  // Delete a particular bill (D)
  deleteBill(String billID) async{
    final snapShot = await _database.collection(collectionPath)
        .where("billID", isEqualTo: billID).get() ;
    final data = snapShot.docs.single ;
    await _database.collection(collectionPath).doc(data.id).delete() ;
  }
}

