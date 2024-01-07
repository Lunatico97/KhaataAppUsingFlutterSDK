import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/authentication.dart';
import '../backend/userbaseUtility.dart';

bool assoc = false;
var positive, negative;

class MyPieChart extends StatefulWidget {
  MyPieChart({Key? key, required bool association, var posBal, var negBal})
      : super(key: key) {
    assoc = association;
    positive = posBal;
    negative = negBal;
  }

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  double pos = 0.0;
  double neg = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (assoc) {
        setState(() {
          pos = double.parse(positive.toString());
          neg = double.parse(negative.toString());
        });
      } else {
        await Userbase()
            .getUserDetails('id', Authentication().currentUser?.uid as String)
            .then((value) {
          if (mounted) {
            super.setState(() {
              pos = value.outBalance.toDouble();
              neg = value.inBalance.toDouble();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: PieChart(
          dataMap: {"Outflows": pos, "Inflows": neg},
          colorList: [Colors.greenAccent, Colors.redAccent],
          legendOptions: LegendOptions(showLegends: true),
        )).p(12);
  }
}
