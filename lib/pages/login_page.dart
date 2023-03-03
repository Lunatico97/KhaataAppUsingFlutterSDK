import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      changeButton = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    await Navigator.pushNamed(context, "/");
    Navigator.pop(context, "/login");
    setState(() {
      changeButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60.0,
                ),
                Text(
                  "Welcome $name!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter Username",
                      ),
                      onChanged: (value) => {name = value, setState(() {})},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Username cannot be empty.");
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Username",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Password cannot be empty.");
                        } else if (value.length < 8) {
                          return ("Password is too short");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () => moveToHome(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: changeButton ? 50 : 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              changeButton ? Colors.deepPurple : Colors.purple,
                          borderRadius:
                              BorderRadius.circular(changeButton ? 50 : 16),
                        ),
                        child: changeButton
                            ? Icon(Icons.done, color: Colors.blue)
                            : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    //   ElevatedButton(
                    //     child: Text("Login"),
                    //     style: TextButton.styleFrom(minimumSize: const Size(150, 40)),
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, MyRoutes.homeRoute);
                    //     },
                    //   )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
