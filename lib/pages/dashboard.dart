import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khaata_app/backend/transactionUtility.dart';
import 'package:khaata_app/backend/transactionsLoader.dart';
import 'package:khaata_app/widgets/piechart.dart';
import 'package:velocity_x/velocity_x.dart';

// Imports
import '../backend/authentication.dart';
import '../backend/notificationUtility.dart';
import '../models/structure.dart';
import '../models/transaction.dart';
import '../widgets/drawer.dart';

var notifCounts = 0;

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App?'),
              content: Text('Do you really want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      // Navigator.of(context).popUntil((route) => false);
                      SystemNavigator.pop();
                      //    Navigator.of(context).pop();
                      // Navigator.of(context).pop(true);
                    }),
              ],
            );
          },
        );
        if (exit == null || !exit) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home_rounded), label: "Home"),
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
            if (index == 1) {
              Navigator.pushNamed(context, "/friends");
            } else if (index == 2) {
              Navigator.pushNamed(context, "/transactions");
            }
          },
          selectedIndex: 0,
        ),
        drawer: MyDrawer(),
        appBar: AppBar(title: "Khaata".text.make(), actions: [
          IconButton(
              onPressed: (() {
                Navigator.pushNamed(context, "/notifications");
                notifCounts = 0 ;
              }),
              icon: Stack(children: [
                Icon(CupertinoIcons.bell),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                          color: notifCounts == 0
                              ? Colors.transparent
                              : Colors.red,
                          shape: BoxShape.circle),
                    )),
                Positioned(
                  right: 0,
                  top: 0,
                  child: SizedBox(
                    height: 14,
                    width: 14,
                    child: Center(
                      child: notifCounts == 0
                          ? Text("")
                          : Text(
                              "$notifCounts",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                    ),
                  ),
                )
              ]))
        ]),
        body: Column(
          children: [
            "Your Summary".text.xl2.bold.make().p(8),
            MyPieChart(association: false).p(8),
            "Recents".text.xl2.bold.make().pOnly(top: 12, bottom: 12),
            RecentList().expand(),
          ],
        ),
      ),
    );
  }
}

// {Diwas - Changed it to stateful as it needs async updates everytime the page opens}
class RecentList extends StatefulWidget {
  const RecentList({Key? key}) : super(key: key);

  @override
  State<RecentList> createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  List<Record> records = [];
  List<UserData> borrowers = [];
  List<UserData> lenders = [];
  var trans = TransactionLoader();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if(mounted){
        setState(() {
          Notifier().countSeenNotifications().then((value) {
            notifCounts = value;
          });
         }) ;
       }
      await trans.getDetailsOfParticipants(true).then((value) {
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
    return borrowers.isEmpty
        ? (records.isEmpty
            ? Center(child: "No recent transactions".text.lg.make())
            : const Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: lenders.length,
            itemBuilder: ((context, index) {
              print(lenders);
              return Card(
                child: ListTile(
                    leading:
                        "${TransactionRecord().months[records[index].transactionDate.toDate().month-1]}"
                                " ${records[index].transactionDate.toDate().day}"
                            .text
                            .lg
                            .make(),
                    title: Row(children: [
                      "${lenders[index].name}".text.lg.make(),
                      lenders[index].id == Authentication().currentUser?.uid
                          ? Icon(Icons.arrow_forward, color: Colors.teal)
                          : Icon(Icons.arrow_forward, color: Colors.red),
                      "${borrowers[index].name}".text.lg.make()
                    ]),
                    subtitle:
                        "${TransactionRecord().days[records[index].transactionDate.toDate().weekday-1]}"
                                " - ${records[index].transactionDate.toDate().toString().substring(0, 16)}"
                            .text
                            .sm
                            .make(),
                    //   // instead of using toDate() which shows shitty seconds and milliseconds nobody cares about !
                    trailing: "${records[index].amount}".text.lg.bold.make()),
              );
            })).pOnly(top: 10);
  }
}
