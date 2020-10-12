import 'package:bot_toast/bot_toast.dart';
import 'package:chatApp/helper/helperfunction.dart';
import 'package:chatApp/services/auth.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/views/Home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:chatApp/widget/colors.dart';
import 'package:chatApp/widget/fadeanimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'loginpage.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  Databasemethods databasemethod = new Databasemethods();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  signMeUp() {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwController.text)
          .then((value) {
        if (value == 0) {
          setState(() {
            isLoading = false;
            BotToast.showText(text: "The password provided is too weak.");
          });
        } else if (value == 1) {
          setState(() {
            isLoading = false;
            BotToast.showText(
                text: "The account already exists for that email.");
            passwController.text = null;
          });
        } else if (value != null) {
          Map<String, String> userInfoMap = {
            "name": usernameController.text,
            "email": emailController.text
          };
          databasemethod.uploaduserInfo(userInfoMap);
          HelperFunction.saveuserLoggedInSharedPreference(true);
          HelperFunction.saveuserEmailSharedPreference(emailController.text);
          HelperFunction.saveuserNameSharedPreference(usernameController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      FadeAnimation(
                        1.5,
                        Text("Welcome",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.5,
                        Text("Create new account",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.5,
                        Image.asset(
                          'assets/chat-bubble.png',
                          width: 100,
                          height: 80,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FadeAnimation(
                            1.5,
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: themecolor,
                                        blurRadius: 30,
                                        offset: Offset(1, 8))
                                  ],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  children: [
                                    FadeAnimation(
                                      1.5,
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0,
                                            left: 8,
                                            top: 2,
                                            bottom: 2),
                                        child: TextFormField(
                                          validator: (val) {
                                            if (!val.isEmpty) {
                                              if (val.length < 4) {
                                                return "Username Too short";
                                              }
                                            } else if (val.isEmpty) {
                                              return "Enter Username";
                                            }
                                          },
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              hintText: "Enter Username"),
                                        ),
                                      ),
                                    ),
                                    FadeAnimation(
                                      1.5,
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0,
                                            left: 8,
                                            top: 2,
                                            bottom: 2),
                                        child: TextFormField(
                                          validator: (val) {
                                            if (!val.isEmpty) {
                                              if (RegExp(
                                                      r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                                  .hasMatch(val)) {
                                                return null;
                                              } else {
                                                return "Enter Email correctly";
                                              }
                                            } else
                                              return "Enter Email";
                                          },
                                          controller: emailController,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              hintText: "Email Address"),
                                        ),
                                      ),
                                    ),
                                    FadeAnimation(
                                      1.5,
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0,
                                            left: 8,
                                            top: 2,
                                            bottom: 2),
                                        child: TextFormField(
                                          validator: (val) {
                                            if (!val.isEmpty) {
                                              if (val.length < 4) {
                                                return "Password Too short";
                                              }
                                            } else if (val.isEmpty) {
                                              return "Enter Password";
                                            }
                                          },
                                          controller: passwController,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              hintText: "Password"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            "Forgot Password?",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      FadeAnimation(
                          1.5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                          color: themecolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        1.6,
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, right: 40),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 0.8,
                            height: 50,
                            onPressed: () {
                              signMeUp();
                            },
                            color: themecolor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Sign up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
              ));
  }
}
