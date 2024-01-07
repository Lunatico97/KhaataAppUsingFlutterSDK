
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';

import '../models/structure.dart';
import '../models/transaction.dart';

/*
 Author: Diwas Adhikari
 {I am a sucker for classes and getters/setters - it sucks that I don't know if templates exist in Dart !}
 */

class TransactionLoader{
    List<Record> records = [] ;
    List<UserData> borrowers = [] ;
    List<UserData> lenders = [] ;

    List<Record> get getRecords => records ;
    List<UserData> get getBorrowers => borrowers ;
    List<UserData> get getLenders => lenders ;
    var auth = Authentication() ;

    Future<void> getPastTransactions() async{
      await TransactionRecord().getRecentLendRecords(2).then((specified){
        records = specified;
      }) ;
      await TransactionRecord().getRecentBorrowRecords(2).then((specified){
        records = records + specified ;
      }) ;
    }

    Future<void> getAllTransactions() async{
      await TransactionRecord().getAllLendRecords().then((specified){
        records = specified;
      }) ;
      await TransactionRecord().getAllBorrowRecords().then((specified){
        records = records + specified ;
      }) ;
    }

    Future<void> getTransactionsAssocTo(String friendID) async{
      await TransactionRecord().getLendRecordsBetweenCurrentUserAnd(friendID).then((specified){
        records = specified ;
      }) ;
      await TransactionRecord().getBorrowRecordsBetweenCurrentUserAnd(friendID).then((specified){
        records = records + specified ;
      }) ;
    }

    Future<void> getDetailsOfParticipants(bool recent) async {
    if(!recent){
      await getAllTransactions() ;
    }
    else{
      await getPastTransactions();
    }
    for (var i = 0; i < records.length; i++) {
      await Userbase()
        .getUserDetails("id", records[i].lenderID.toString())
        .then((value) {
          lenders.insert(i, value);
      });
      await Userbase()
        .getUserDetails("id", records[i].borrowerID.toString())
        .then((value) {
          borrowers.insert(i, value);
      });
    }
  }
}