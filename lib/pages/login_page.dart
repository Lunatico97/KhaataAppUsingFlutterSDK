import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
// Back-end imports
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/backend/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  final _formKey = GlobalKey<FormState>();
  bool wrongUser = true;
  bool wrongPass = false;
  String loggerMail = "0xFF";
  bool changeButton = false;
  bool hide = true;
  TextEditingController namer = TextEditingController();
  TextEditingController passer = TextEditingController();

  //To check internet connectivity
  var _source = kIsWeb ? null : {ConnectivityResult.none: false};
  var _networkConnectivity = kIsWeb ? null : NetworkConnectivity.instance;
  bool isConnected = true;

  // Backend utilities {Diwas - Don't mess with field names !}
  Future<void> getMailFromUsername(String name) async {
    await Userbase().getUserDetails("name", name).then((specified) {
      // Forget setState and I lost my shit - hahahaha !
      setState(() {
        loggerMail = specified.email;
        wrongUser = false; // this is needed and I know it !
      });
    }).catchError((error) {
      print(error);
      setState(() {
        wrongUser = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb || _networkConnectivity == null || _source == null) {
      isConnected = true;
      return;
    }
    _networkConnectivity!.initialise();
    _networkConnectivity!.myStream.listen((source) {
      _source = source;
      isConnected = _networkConnectivity!.isConnected();
    });
    setState(() {});
  }

  dispose() {
    super.dispose();
    _networkConnectivity!.disposeStream();
  }

  moveToHome(BuildContext context, bool givePass) async {
    if (!givePass) {
      setState(() {
        wrongPass = true;
      });
    } else {
      setState(() {
        wrongPass = false;
        changeButton = true;
      });
    }
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      var successfulSnackBar = SnackBar(
        content: "Successfully Logged In".text.color(Colors.green).make(),
        action: SnackBarAction(
          label: "DISMISS",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(successfulSnackBar);
      await Navigator.pushNamed(context, "/dashboard");
      //Navigator.pop(context, "/login");
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: ((isConnected != null && isConnected == true) || kIsWeb)
            ? Form(
                key: _formKey,
                child: ListView(
                  controller: ScrollController(),
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Image.asset("assets/images/khaata-logo.png"),
                    ).pOnly(top: 40),
                    Center(
                      child: Text(
                        "Welcome $name !",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(children: [
                          TextFormField(
                            controller: namer,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              hintText: "Enter username",
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Username cannot be empty.");
                              } else if (wrongUser) {
                                return ("Username is not found.");
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passer,
                            decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hide = !hide;
                                      });
                                    },
                                    icon: Icon(hide
                                        ? Icons.visibility_off
                                        : Icons.visibility))),
                            obscureText: hide,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Password cannot be empty.");
                              } else if (wrongPass) {
                                return ("Your password doesn't match! ");
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              if (!kIsWeb) {
                                _networkConnectivity!.initialise();
                                isConnected =
                                    _networkConnectivity!.isConnected();
                                if (isConnected == null ||
                                    isConnected == false) {
                                  setState(() {});
                                  return;
                                }
                              }
                              name = namer.text.trim();
                              String pass = passer.text.trim();
                              getMailFromUsername(name).then((value) async {
                                print(
                                    "$name\n$pass\n$loggerMail\n"); // Just for us devs - hahaha (your data is safe with us, lol !)
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }));
                                await Authentication()
                                    .setInfoForCurrentUser(name);
                                moveToHome(
                                    context,
                                    await Authentication().signInUser(
                                        email: loggerMail, password: pass));
                                Navigator.of(context).pop();
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: changeButton ? 50 : 100,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(
                                    changeButton ? 50 : 16),
                              ),
                              child: changeButton
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                          TextButton(
                              onPressed: (() {
                                Navigator.pushNamed(context, "/register");
                              }),
                              child: Text("Not registered? Register"))
                        ]))
                  ],
                ),
              )
            : NotConnnectedWidget());
  }
}

class NetworkConnectivity {
  NetworkConnectivity._();
  bool isOnline = false;
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

// 2.
  void _checkStatus(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    //   _controller.sink.add({result: isOnline});
  }

  bool isConnected() {
    initialise();
    return isOnline;
  }

  void disposeStream() => _controller.close();
}

class NotConnnectedWidget extends StatelessWidget {
  const NotConnnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.red,
          size: 100,
        ).p(16).centered(),
        SizedBox(
          height: 16,
        ),
        SizedBox(
            height: 120,
            width: 300,
            child: Text(
              "Please connect to the internet and restart the app.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ).centered())
      ],
    ).p(32);
  }
}
