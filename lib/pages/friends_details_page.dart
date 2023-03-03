// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khaata_app/models/history_data_model.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendDetail extends StatefulWidget {
  final int id;
  const FriendDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState(this.id);
}

class _FriendDetailState extends State<FriendDetail> {
  final id;
  _FriendDetailState(this.id);
  void initState() {
    super.initState();
    loadData(this.id);
  }

  loadData(int id) async {
    var detailJSON =
        await rootBundle.loadString("assets/data/historydata.json");
    var decodedData = jsonDecode(detailJSON);
    var productsData = decodedData["history"];
    var currentHistory = [];
    for (var i = 0; i < productsData.length; i += 1) {
      var cur = productsData[i];
      if (cur["id"] == id) {
        currentHistory = cur["data"];
      }
    }
    HistoryModel.entry.id == id;
    HistoryModel.entry.data.clear();
    if (currentHistory == null) {
      return;
    }
    for (var i = 0; i < currentHistory.length; i++) {
      var cur = currentHistory[i];
      HistoryModel.entry.data.add(SingleEntry.fromMap(cur));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Details of friend no ${id + 1}".text.make()),
      body: HistoryModel.entry.data.isEmpty
          ? "No Transactions for Friend ${id + 1}".text.bold.make().centered()
          : ListView.builder(
              itemCount: HistoryModel.entry.data.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  leading: HistoryModel.entry.data[index].date.text.make(),
                  trailing: HistoryModel.entry.data[index].transac.text.make(),
                  title: "Remarks".text.make(),
                );
              })),
    );
  }
}
