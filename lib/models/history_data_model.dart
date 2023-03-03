class HistoryModel {
  static Item entry = Item(id: 0, data: []);
}

class Item {
  final int id;
  final List<SingleEntry> data;

  Item({required this.id, required this.data});
  //Data Class Generator Extension can perform this task easily
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(id: map["id"], data: map["data"]);
  }

  toMap() => {
        "id": id,
        "data": data,
      };
}

class SingleEntry {
  final String date;
  final String time;
  final int transac;
  SingleEntry({required this.date, required this.time, required this.transac});
  factory SingleEntry.fromMap(Map<String, dynamic> map) {
    return SingleEntry(
      date: map["date"],
      time: map["time"],
      transac: map["transaction"],
    );
  }

  toMap() => {"date": date, "time": time, "transaction": transac};
}
