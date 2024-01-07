import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BillCreator extends StatefulWidget {
  const BillCreator({Key? key}) : super(key: key);

  @override
  State<BillCreator> createState() => _BillCreatorState();
}

class _BillCreatorState extends State<BillCreator> {
  //load lists
  List<String> items = [] ;
  List<int> rates = [] ;
  List<int> quantities = [] ;
  final itemController = TextEditingController() ;
  final rateController = TextEditingController() ;
  final quantityController = TextEditingController() ;
  final _itemFormKey = GlobalKey<FormState>();
  int total = 0 ;

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
        floatingActionButton: FloatingActionButton(
            child: Icon(CupertinoIcons.add),
            onPressed: (){
              itemController.text = '';
              quantityController.text = '';
              rateController.text = '' ;
          showDialog(
          context: context,
          builder: (context)
        {
          return Form(
          key: _itemFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: Text("Item"),
                actions: [
                  TextFormField(
                    decoration: InputDecoration(
                        alignLabelWithHint:
                        true,
                        labelText:
                        "Item",
                        hintText:
                        "Write item name"),
                    controller:
                    itemController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Item cannot be empty");
                      } else if (value
                          .length >
                          20) {
                        return ("Item name is too long");
                      }
                      return null;
                    },
                  ).pOnly(
                      left: 16, right: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        alignLabelWithHint:
                        true,
                        labelText:
                        "Rate",
                        hintText:
                        "Specify rate of the item"),
                    controller:
                    rateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Item cannot be empty");
                      }
                      return null;
                    },
                  ).pOnly(
                      left: 16, right: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        alignLabelWithHint:
                        true,
                        labelText:
                        "Quantity",
                        hintText:
                        "Specify number of items"),
                    controller:
                    quantityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Quantity cannot be empty");
                      }
                      return null;
                    },
                  ).pOnly(
                      left: 16, right: 16),
                  ButtonBar(children: [
                    TextButton(
                        child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold)),
                        onPressed: () {
                          Navigator.of(
                              context)
                              .pop();
                        }
                      // save a transaction
                    ),
                    TextButton(
                        child: Text("OK",
                            style: TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold)),
                        style:
                        ButtonStyle(),
                        onPressed:
                            () async {
                              if (!_itemFormKey.currentState!.validate()) {
                                return;
                              }
                          // add item here
                              setState(() {
                                items.add(itemController.text.trim());
                                quantities.add(
                                    int.parse(quantityController.text.trim()));
                                rates.add(int.parse(rateController.text.trim()));
                                total = total + (int.parse(quantityController.text.trim())*int.parse(rateController.text.trim())) ;
                              });

                          Navigator.of(
                              context)
                              .pop();
                        }),
                  ]),
                ],
              ),
            ),
          ),
        );
        }) ;
        }),
        body: items.isEmpty ? "No items in the cart !".text.lg.bold.makeCentered() :
            Stack(children: [
        ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context, index) {
            return Card(
              elevation: 5,
                    child: ListTile(
                        title: "${items[index]}".text.lg.bold.make().pOnly(left: 5),
                        subtitle: "(Pcs: ${quantities[index]} @ ${rates[index]})".text.sm.make().pOnly(left: 10),
                        leading: "${rates[index]*quantities[index]} ".text.lg.bold.make(),
                        trailing: IconButton(onPressed: () async{
                                // remove that item
                                setState(() {
                                  total = total - (quantities[index]*rates[index]) ;
                                  items.removeAt(index) ;
                                  quantities.removeAt(index) ;
                                  rates.removeAt(index) ;
                                });
                              }, icon: Icon(Icons.delete))

                    )
                ) ;
          }),
        ),
              Positioned(
                bottom:
                0, // Adjust this value to change the button's position
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8)),
                    color: Color.fromARGB(255, 233, 230, 233),
                  ),
                  child: "Total: $total".text.lg.bold.green500.make().pOnly(bottom: 20, top: 20, left: 20),
                  ),
                ),
                ]
              )
        ) ;
  }
}
