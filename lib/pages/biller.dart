
/*
  Author: Diwas Adhikari
  All we need was a self-biller and here we go !
 */

import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/widgets/billCreator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/bill.dart';

late Bill selectedBill ;

class BillerPage extends StatefulWidget {
  const BillerPage({Key? key}) : super(key: key);

  @override
  State<BillerPage> createState() => _BillerPageState();
}

class _BillerPageState extends State<BillerPage> {
  //load lists
  List<Bill> bills = [] ;

  @override
  void initState(){
    // initialize preliminary state for the widget - {Diwas}
    super.initState() ;
    Future.delayed(Duration.zero, () async{
      setState(() {

      });
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Biller".text.make(),
      ),
      body: bills.isEmpty ? "No bills created yet !".text.lg.bold.makeCentered() :
      ListView.builder(
          itemCount: bills.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BillDetail(details: bills[index])));
              },
              child: Card(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "${bills[index].time}".text.lg.make(),
                        SizedBox(width: 20,),
                        IconButton(onPressed: () async{
                          // delete that bill
                          setState(() {
                            bills.removeAt(index) ;
                          });
                        }, icon: Icon(Icons.delete))
                        ]
                )
             )
           );
          }),
      )
    );
  }
}

// If a bill is tapped and chosen, show its details
class BillDetail extends StatefulWidget {
  final Bill details;
  BillDetail({Key? key, required this.details}) : super(key: key) {
    selectedBill = details;
  }

  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {

    return const Placeholder();
  }
}

