import 'package:flutter/material.dart';
import './login.dart';
import './register.dart';
import 'package:flutter_frontend/Animations/FadeAnimation.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeAnimation(
              1,
              Container(
                height: 400,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.red[900],
                          Colors.red[800],
                          Colors.orange[400]
                        ])),
                child: Center(
                    child: FadeAnimation(
                        1.2,
                        Container(
                          height: 230,
                          width: 230,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Wallet.png'))),
                        ))),

                //Stack(children: <Widget>[
                //   Positioned(
                //       child: Container(
                //           decoration: BoxDecoration(
                //               image: DecorationImage(
                //                   image:
                //                       AssetImage('assets/images/background.png'),
                //                   fit: BoxFit.fill)))),

                //   Positioned(
                //       height: 400,
                //       width: width + 20,
                //       child: Container(
                //           decoration: BoxDecoration(
                //               image: DecorationImage(
                //                   image: AssetImage('assets/images/back.png'),
                //                   fit: BoxFit.fill))))
                // ]),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1.4,
                        Text('Welcome!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 45))),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(1.5,Text('The fuzziest and easiest moeny manager on the go!',
                        style: TextStyle(color: Colors.white, fontSize: 14)))
                  ]),
            ),
            SizedBox(height: 50),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: FadeAnimation(1.6,Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                        Colors.red[400],
                        Colors.red[800],
                        Colors.red[900],
                      ]),
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.purple[800]),
                  child: Center(
                      child: Text(
                    'SignUp',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[300],
                        fontFamily: 'Helvetica Neue',
                        fontWeight: FontWeight.bold),
                  )),
                ),),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: FadeAnimation(1.8,Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                      Colors.red[400],
                      Colors.red[800],
                      Colors.red[900],
                    ]),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                      child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[300],
                        fontFamily: 'Helvetica Neue',
                        fontWeight: FontWeight.bold),
                  )),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
