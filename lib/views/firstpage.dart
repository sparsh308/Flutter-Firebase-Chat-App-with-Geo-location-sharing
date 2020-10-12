import 'package:chatApp/helper/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:chatApp/widget/fadeanimation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatApp/widget/colors.dart';
import 'package:chatApp/views/loginpage.dart';

class firstpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        home: first());
  }
}

class first extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //We take the image from the assets

            FadeAnimation(
              1.5,
              Image.asset(
                'assets/chat-bubble.png',
                width: 250,
                height: 150,
              ),
            ),
            FadeAnimation(
              1.5,
              Text(
                'Whats up!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            FadeAnimation(
              1.5,
              Text(
                'Messaging App',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),

            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: FadeAnimation(
                  1.5,
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 0.8,
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authenticate(),
                          ));
                    },
                    color: themecolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Get Started',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                    textColor: Colors.white,
                  ),
                )),
          ],
        ));
  }
}
