import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../imports/import.dart';
import 'package:lottie/lottie.dart';

// This code contains all the code for Login Procees.
// User need AppID and password to login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controller for TextFilds.
  final TextEditingController appIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Login check use.
  bool appIdError = false;
  bool passwordError = false;
  bool isLoding = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(
            CommonFunctions.getWidth(context, 10),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: CommonFunctions.getHeight(context, 5),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    AssetsConst.loginPageAnimation,
                    height: CommonFunctions.getHeight(context, 20),
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      CommonWidget.getTextSpanLight(
                        color: Colors.black,
                        text: "Become",
                        fontSize: CommonFunctions.getHeight(context, 2),
                      ),
                      CommonWidget.getTextSpanBold(
                        color: ColorPalat.skyBlue,
                        text: " Smart Member",
                        fontSize: CommonFunctions.getHeight(context, 2),
                      ),
                      CommonWidget.getTextSpanLight(
                        color: Colors.black,
                        text: " of Home",
                        fontSize: CommonFunctions.getHeight(context, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: isLoding
                      ? Lottie.asset(
                          AssetsConst.loding,
                          fit: BoxFit.cover,
                          width: CommonFunctions.getWidth(context, 20),
                          height: CommonFunctions.getHeight(context, 10),
                        )
                      : SizedBox(
                          height: CommonFunctions.getHeight(context, 10),
                        ),
                ),
                TextFormField(
                  onChanged: (value) => setState(() {
                    appIdError = false;
                  }),
                  style: TextStyle(
                      fontFamily: CommonFonts.josefinBold,
                      fontSize: CommonFunctions.getHeight(context, 2)),
                  controller: appIdController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle),
                      hintText: "EX : ABCD",
                      label: const Text("App Id"),
                      errorText: appIdError ? "Please Enter the AppID" : null),
                ),
                SizedBox(
                  height: CommonFunctions.getHeight(context, 3),
                ),
                TextFormField(
                  onChanged: (value) => setState(() {
                    passwordError = false;
                  }),
                  style: TextStyle(
                      fontFamily: CommonFonts.josefinBold,
                      fontSize: CommonFunctions.getHeight(context, 2)),
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      hintText: "EX: 1234",
                      label: const Text("Password"),
                      errorText:
                          passwordError ? "Please Enter the Password" : null),
                ),
                SizedBox(
                  height: CommonFunctions.getHeight(context, 3),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorPalat.skyBlue),
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(
                      Size(
                        CommonFunctions.getWidth(context, 40),
                        CommonFunctions.getHeight(context, 6),
                      ),
                    ),
                  ),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontFamily: CommonFonts.josefinBold,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    isLoding = true;
                    setState(() {});
                    try {
                      String appId = appIdController.text.toString();
                      String password = passwordController.text.toString();
                      // First this code will checks inputs are null or note.
                      // If either of them is null then it will show error message to user.
                      if (appId.isEmpty || password.isEmpty) {
                        if (appId.isEmpty) {
                          setState(() => appIdError = true);
                        }
                        if (password.isEmpty) {
                          setState(() => passwordError = true);
                        }
                      } else {
                        //This code will execute if inputs are not null.
                        () async {
                          //This code will fetch data prome this sever.
                          await CommonFunctions.authUser(
                                  userId: appId, password: password)
                              .then((value) {
                            // IF data is available for user then it will recheck with inputs of user.
                            if (value['userId'] == appId &&
                                value['password'] == password) {
                              () async {
                                // If data is correct then this code will store the _id into local storage with hash of the _id.
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('_id', value['_id']);
                                int idHash = value['_id'].hashCode;
                                await prefs.setInt('_idHash', idHash);
                              }();
                              Fluttertoast.showToast(
                                msg: "Wellcome",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.pushNamed(context, "mainPage");
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please enter valid AppID or Password.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              appIdController.text = "";
                              passwordController.text = "";
                            }
                            setState(() {
                              isLoding = false;
                            });
                          }).catchError((e) {
                            // if any problem ocur then it will show a simple SnakBar with error and button.
                            // Button click will stop App and exit app.
                            Fluttertoast.showToast(
                              msg: "Please enter valid AppID or Password.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            appIdController.text = "";
                            passwordController.text = "";
                          });
                          setState(() {
                            isLoding = false;
                          });
                        }();
                      }
                    } on Exception {
                      setState(() {
                        isLoding = false;
                      });
                      // if any problem ocur then it will show a simple SnakBar with error and button.
                      // Button click will stop App and exit app.
                      final snackBar = SnackBar(
                        content: const Text(
                            'Please check the Internet Or Restart App.'),
                        action: SnackBarAction(
                          label: 'Restart',
                          onPressed: () {
                            exit(0);
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
