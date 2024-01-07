import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/transactionUtility.dart';
import '../backend/transactionsLoader.dart';
import '../models/structure.dart';
import '../models/transaction.dart';
import 'package:khaata_app/widgets/billCreator.dart' ;

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Record> records = [];
  List<UserData> borrowers = [];
  List<UserData> lenders = [];
  var trans = TransactionLoader();
  int currentPage = 2;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await trans.getDetailsOfParticipants(false).then((value) {
        if (mounted) {
          super.setState(() {
            records = trans.getRecords;
            borrowers = trans.getBorrowers;
            lenders = trans.getLenders;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
          NavigationDestination(
              icon: Icon(
                CupertinoIcons.person_2_fill,
              ),
              label: "Friends"),
          NavigationDestination(
              icon: Icon(CupertinoIcons.arrow_2_squarepath),
              label: "Transactions"),
          /* A prospect to acheive later - {Diwas}
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet),
              label: "Biller")
          */
        ],
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, "/dashboard");
          } else if (index == 1) {
            Navigator.pushNamed(context, "/friends");
          }
        },
        selectedIndex: currentPage,
      ),
      appBar: AppBar(
          title: Text("Transactions"),
          actions: [
            IconButton(
            onPressed: (() async{
              Navigator.of(context).pushNamed('/biller') ;
            }),
            icon: Icon(Icons.calculate)),
      ],
      ),
      body: records.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  "${lenders[index].name}"
                                      .text
                                      .lg
                                      .make()
                                      .pOnly(right: 4),
                                  lenders[index].id ==
                                          Authentication().currentUser?.uid
                                      ? Icon(Icons.arrow_forward,
                                          color: Colors.teal)
                                      : Icon(Icons.arrow_forward,
                                          color: Colors.red),
                                  "${borrowers[index].name}"
                                      .text
                                      .lg
                                      .make()
                                      .pOnly(left: 4),
                                ]).pOnly(bottom: 8, top: 8),
                                "${TransactionRecord().days[records[index].transactionDate.toDate().weekday-1]}"
                                        " - ${records[index].transactionDate.toDate().toString().substring(0, 16)}"
                                    .text
                                    .sm
                                    .make(),
                              ]),
                          "${records[index].remarks}".text.make(),
                          "${records[index].amount}".text.bold.xl.make(),
                        ]).pOnly(right: 16, left: 16, top: 8, bottom: 8));
              },
            ),
    );
  }
}
