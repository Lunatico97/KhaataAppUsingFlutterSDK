import 'package:flutter/material.dart';
import 'package:khaata_app/models/notification.dart';
import 'package:velocity_x/velocity_x.dart';

import '../backend/notificationUtility.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notify> notifications = [];
  var notifier = Notifier();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await notifier.getAllNotifications().then((value) {
        if (mounted) {
          super.setState(() {
            notifications = value;
            Notifier().updateNotificationsToSeen().then((value){
              // Haha no need to do anything here !
            }) ;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Notifications".text.make(),
        actions: [
          IconButton(
              onPressed: (() async{
                setState(() {
                  notifications = [] ;
                });
                await Notifier().deleteUserNotifications() ;
              }),
              icon: Icon(Icons.clear_all)),
        ],
      ),
      body: notifications.isEmpty
          ? "No new notifications !".text.lg.bold.makeCentered()
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                      title: "${notifications[index].message}".text.make(),
                      leading:
                          "${Notifier().days[notifications[index].time.toDate().weekday-1]}\n"
                                  "${Notifier().months[notifications[index].time.toDate().month-1]} ${notifications[index].time.toDate().day}"
                              .text
                              .sm
                              .make(),
                      trailing:
                          "${notifications[index].time.toDate().toString().substring(10, 16)}"
                              .text
                              .sm
                              .make()),
                );
              })),
    );
  }
}
