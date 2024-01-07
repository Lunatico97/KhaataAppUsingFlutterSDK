import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
// New imports for back-end {Diwas}
import 'package:khaata_app/backend/authentication.dart';
import 'package:khaata_app/backend/userbaseUtility.dart';
import 'package:khaata_app/models/structure.dart';
import 'package:crypto/crypto.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  String passAgain = "";
  final _formKey = GlobalKey<FormState>();
  // Text Controllers
  TextEditingController namer = TextEditingController();
  TextEditingController numberer = TextEditingController();
  TextEditingController emailer = TextEditingController();
  TextEditingController passer = TextEditingController();
  // Switches
  bool ifItExists = false;
  bool hide = true;
  // Encrypt pin to a hash using SHA-256
  String generateHash(String text) {
    var bytesOfData = utf8.encode(text);
    String hashValue = sha256.convert(bytesOfData).toString();
    return hashValue;
  }

  // Add a new user using async method to push data in Firebase cloud
  Future addUser(
      {required String name,
      required String email,
      required String number,
      required String password}) async {
    final hash = generateHash(password);
    // I just remade this thing again with new classes - life is awful !
    await Authentication().registerUser(email: email, password: password);
    final user = UserData(
        id: Authentication().currentUser?.uid,
        name: name,
        number: number,
        email: email,
        hash: hash,
        friends: [],
        avatarIndex: 1,
        inBalance: 0,
        outBalance: 0
    );
    await Userbase().createNewUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: "Register".text.make(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          controller: ScrollController(),
          children: [
            SizedBox(
              height: 150,
              child: Image.asset("assets/images/khaata-logo.png"),
            ).pOnly(top: 20),
            const Center(
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 32.0),
              child: Column(children: [
                TextFormField(
                  controller: namer,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    hintText: "Enter username",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                        return ("Username cannot be empty.");
                    }
                    else if (ifItExists) {
                      return ("Username already exists! ");
                    }
                    else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: emailer,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Enter email address",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email address cannot be empty.");
                    }
                    else if (ifItExists) {
                      return ("Username associated to this email already exists! ");
                    }
                    else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: numberer,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter phone number",
                  ),
                  maxLength: 10,
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("The number cannot be empty! ");
                    } else if (value.length < 10) {
                      return ("The number must be of 10 digits! ");
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passer,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: Icon(
                              hide ? Icons.visibility_off : Icons.visibility))),
                  obscureText: hide,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("The password cannot be empty! ");
                    } else if (value.length <= 8) {
                      return ("Password is too short! ");
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Enter password again",
                  ),
                  obscureText: hide,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("The password cannot be empty! ");
                    } else if (value != passer.text.trim()) {
                      return ("The passwords don't match! ");
                    } else {
                      passAgain = passer.text.trim();
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      String name1 = namer.text.trim();
                      String num1 = numberer.text.trim();
                      String pass = passer.text.trim();
                      String mail = emailer.text.trim();
                      Userbase().doesUserAlreadyExist(name1).then((value1){
                        setState(() {
                          ifItExists = value1 ;
                        });
                      }) ;
                      // Check validators
                      if (!_formKey.currentState!.validate()) {
                          return;
                      }
                      setState(() {
                        addUser(
                            name: name1,
                            number: num1,
                            email: mail,
                            password: pass);
                      });
                      Navigator.pop(context, "/register");
                      var successfulSnackBar = SnackBar(
                        content: "Successfully Registered"
                            .text
                            .color(Colors.green)
                            .make(),
                        action: SnackBarAction(
                          label: "DISMISS",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successfulSnackBar);
                      Navigator.pushNamed(context, "/login");
                    },
                    child:
                        "Register".text.xl.make().pOnly(right: 12, left: 12)),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
