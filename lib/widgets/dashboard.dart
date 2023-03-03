import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:velocity_x/velocity_x.dart';

import 'drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          "Your Summary".text.bold.lg.make().p(8),
          MyPieChart().p(8),
          RecentList().expand(),
        ],
      ),
    );
  }
}

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: {"Positive": 5, "Negative": 3},
      colorList: [Colors.redAccent, Colors.greenAccent],
      legendOptions: LegendOptions(showLegends: false),
    ).box.square(200).rounded.make();
  }
}

class RecentList extends StatelessWidget {
  const RecentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          if (index == 0) {
            return ListTile(leading: "Recents".text.xl2.bold.make());
          }
          return ListTile(
              leading: "Recent Transaction ${index}".text.sm.make());
        })).pOnly(top: 10);
  }
}
