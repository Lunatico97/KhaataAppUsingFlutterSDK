// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/requestUtility.dart';
import 'package:khaata_app/models/friendRequest.dart';
import 'package:khaata_app/models/structure.dart';

import 'package:velocity_x/velocity_x.dart';

import '../backend/friendsLoader.dart';
import '../backend/notificationUtility.dart';
import '../backend/userbaseUtility.dart';
import '../models/notification.dart';

List<UserData> users = [];

class AddFriendSearchBar extends StatefulWidget {
  const AddFriendSearchBar({super.key});

  @override
  State<AddFriendSearchBar> createState() => _AddFriendSearchBarState();
}

class _AddFriendSearchBarState extends State<AddFriendSearchBar> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Userbase().getAllUserData().then((value) {
        if (mounted) {
          super.setState(() {
            users = value;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        child: const Icon(CupertinoIcons.person_add));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Back-end data fetch {Diwas - "Yeah this is how we do it !"}
  List<UserData> matchedQuery = [];
  var frLoad = FriendLoader();

  @override
  List<Widget>? buildActions(BuildContext context) {
    //clear query
    return [
      IconButton(
          onPressed: (() {
            matchedQuery = [];
            query = "";
          }),
          icon: Icon(CupertinoIcons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (() {
          //closes the search bar
          matchedQuery = [];
          close(context, null);
        }),
        icon: Icon(CupertinoIcons.arrow_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    for (UserData person in users) {
      if (query != "" &&
          person.name.toLowerCase().contains(query.toLowerCase())) {
        if (person.name != Authentication().currentUser?.displayName) {
          matchedQuery.add(person);
        }
      }
    }
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index].name;
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(cur),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: (() {
                      // We might load profile of a friend {Diwas}
                      String? by = Authentication().currentUser?.uid;
                      String? to = matchedQuery[index].id;
                      String sender =
                          Authentication().currentUser?.displayName as String;
                      RequestUtility().createNewRequest(
                          FriendRequest(byID: by, toID: to, sender: sender));
                    }),
                  ),
                ),
              );
            }))
        : "No items match your search".text.make().centered();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    matchedQuery.clear();
    for (UserData person in users) {
      if (query.isNotEmpty &&
          person.name.toLowerCase().contains(query.toLowerCase())) {
        if (person.name != Authentication().currentUser?.displayName) {
          matchedQuery.add(person);
        }
      }
    }
    //these are the suggestions
    //all matching items are given as suggestion for now
    return matchedQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchedQuery.length,
            itemBuilder: ((context, index) {
              var cur = matchedQuery[index];
              return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  DetailsPage(person: cur))));
                    },
                    title: Text(cur.name),
                  ));
            }))
        : "No items match your search".text.make().centered();
  }
}

class DetailsPage extends StatefulWidget {
  final UserData person;
  const DetailsPage({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState(this.person);
}

class _DetailsPageState extends State<DetailsPage> {
  final UserData currentPerson;
  bool isThatAFriend = false;
  bool isReqPending = false;

  _DetailsPageState(this.currentPerson);

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Userbase()
          .isSpecifiedUserFriend(currentPerson.id as String)
          .then((value) {
        if (mounted) {
          super.setState(() {
            isThatAFriend = value;
          });
        }
      });
      await RequestUtility()
          .isRequestPending(Authentication().currentUser?.uid as String,
              currentPerson.id as String)
          .then((value) {
        if (mounted) {
          super.setState(() {
            isReqPending = value;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "${currentPerson.name}'s Profile".text.make()),
      body: ListView(
        controller: ScrollController(),
        children: [
          SizedBox(
            height: 32,
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.accentColor, width: 3),
            ),
            child: Image.asset(
                "assets/images/avatar${currentPerson.avatarIndex}.png"),
          ),
          SizedBox(
            height: 16,
          ),
          currentPerson.name.text.lg.bold.make().centered(),
          SizedBox(
            height: 16,
          ),
          "+977 - ${currentPerson.number}".text.lg.bold.make().centered(),
          SizedBox(
            height: 32,
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.arrow_upward, color: Colors.greenAccent),
              "Rs. ${currentPerson.outBalance}"
                  .text
                  .lg
                  .bold
                  .color(Colors.greenAccent)
                  .make(),
              SizedBox(
                width: 50,
              ),
              Icon(Icons.arrow_downward, color: Colors.redAccent),
              "Rs. ${currentPerson.inBalance}"
                  .text
                  .lg
                  .bold
                  .color(Colors.redAccent)
                  .make()
            ]),
          ),
          SizedBox(
            height: 32,
          ),
          isThatAFriend
              ? ElevatedButton(
                      onPressed: (() {
                        // do nothing - hahaha {Diwas}
                      }),
                      child: "Friends".text.green300.make())
                  .pOnly(right: 16, left: 16)
              : (isReqPending
                  ? ElevatedButton(
                          onPressed: (() {
                            // do nothing again - hahaha {Diwas}
                          }),
                          child: "Request Pending".text.yellow300.make())
                      .pOnly(right: 16, left: 16)
                  : ElevatedButton(
                          onPressed: (() {
                            // Send Request
                            String? by = Authentication().currentUser?.uid;
                            String? to = currentPerson.id;
                            String sender = Authentication()
                                .currentUser
                                ?.displayName as String;
                            if (!isReqPending) {
                              RequestUtility().createNewRequest(FriendRequest(
                                  byID: by, toID: to, sender: sender));
                              Notifier().createNewNotification(Notify(
                                  toID: currentPerson.id as String,
                                  message:
                                      "Looks like you've got a new friend request from ${Authentication().currentUser?.displayName} !",
                                  seen: false,
                                  time: Timestamp.now()));
                              setState(() {
                                isReqPending = true;
                              });
                            }
                          }),
                          child: "Add Friend".text.make())
                      .pOnly(right: 16, left: 16))
        ],
      ),
    );
  }
}
