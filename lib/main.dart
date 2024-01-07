import 'package:flutter/material.dart';
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/pages/biller.dart';
import 'package:khaata_app/pages/dashboard.dart';
import 'package:khaata_app/pages/edit_profile_page.dart';
import 'package:khaata_app/pages/friends_page.dart';
import 'package:khaata_app/pages/login_page.dart';
import 'package:khaata_app/pages/notification_page.dart';
import 'package:khaata_app/pages/register_page.dart';
import 'package:khaata_app/pages/transaction_page.dart';
import 'package:khaata_app/utils/themes.dart';

// Importing Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:khaata_app/widgets/add_new_friend_search_bar.dart';
import 'package:khaata_app/widgets/billCreator.dart';
import 'package:provider/provider.dart';

/* Yeah - I'm gonna make the main function ~ asychronous !
 [ !!! WARNING {Diwas} - Don't mess with Firebase Options and API keys !!! ]
 */
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBQpiMuk5ELTQDxRl-bGzI65EtkDwPwe2w",
          appId: "1:800158423272:android:56c2d440ccd3ebfa0ad15d",
          messagingSenderId: "800158423272",
          projectId: "khaata-3bs"));
  runApp(ChangeNotifierProvider(
    create: ((context) => ThemeProvider()),
    child: const MyApp(),
  ));
}

// {Diwas - Converting to stateful widget was crucial to listen to authentication changes so that initial route can be set}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var logged = false;
  // Check if a user is already authenticated or not ! {Diwas - You know the deal here !}
  Future<void> checkIfAuthenticated() async {
    await Authentication().changes.then((change) {
      change.listen((user) {
        if (user != null && mounted) {
          setState(() {
            logged = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed((Duration.zero), () async {
      await checkIfAuthenticated().then((value) {
        print('Already authenticated');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<ThemeProvider>().darkmode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.DarkTheme(context),
      initialRoute: logged ? "/dashboard" : "/login",
      routes: {
        //"/": (context) => Dashboard(),
        "/dashboard": (context) => Dashboard(),
        "/friends": ((context) => FriendsPage()),
        "/transactions": (context) => TransactionPage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/notifications": (context) => NotificationPage(),
        "/addfriend": (context) => AddFriendSearchBar(),
        "/editprofile": (context) => EditProfilePage(),
        "/biller": (context) => BillCreator(),
      },
    );
  }
}
