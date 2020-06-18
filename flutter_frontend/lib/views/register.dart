import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import './login.dart';

class RegisterPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> register(String username, password) async {
    String url = 'http://10.0.2.2:5000/register?username=' +
        username +
        '&password=' +
        password;
    print(url);
    print("before response");
    final response = await http.get(url);
    print("after response");

    if (response.statusCode == 200) {
      Map result = json.decode(response.body);
      print("inside response");
      print(result['status']);
      return result['status'];
    } else {
      print("fail");
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                      Container(
              
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                      Colors.red[900],
                      Colors.red[800],
                      Colors.orange[400]
                    ]),
                    borderRadius: BorderRadius.circular(40)),
                    child:Center(
                      
                      child:Padding
                      (padding: EdgeInsets.all(40),
                                          child: Column(
                          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height:70),
                            Text('Register', style:TextStyle( fontSize:70,fontWeight: FontWeight.bold,color:Colors.white))
                          ],
                          
                        ),
                      )
                    )
                    
                    
                    ),

                    SizedBox(height: 30,),
                    userField(),
                    SizedBox(height:10),
                    passField(),
                    SizedBox(height: 40),
                    InkWell(
                          onTap: () async {
                    print(usernameController.text);
                    print(passwordController.text);
                    String status = await register(usernameController.text.trim(),
                        passwordController.text.trim());
                    print("status" + status);
                    if (status == 'Username Taken') {
                      Fluttertoast.showToast(
                          msg: status,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    if (status == 'User Created') {
                      Fluttertoast.showToast(
                          msg: status,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage()));
                    }
                  },
                            
                          
                          child: Container(
                            margin: EdgeInsets.all(30),
                            width: 400,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: 
                            LinearGradient(begin: Alignment.topCenter, colors: [
                          Colors.red[400],
                          Colors.red[800],
                          Colors.red[900],
                        ]),),
                            child: Center(
                                child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                          ),
                        ),


                    ] 
          ),
        ),

               

      ),
    );
  }

  Padding userField() {
    return Padding(
      padding: EdgeInsets.all(12.0),
       child:Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(130, 14, 100, 0.2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: TextField(
                            controller: usernameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500])))) 
      //Container(
      //     height: 30,
      //     decoration: BoxDecoration(
      //       border: Border.all(color:Colors.white,
      //       width:2.0),
      //       borderRadius:BorderRadius.circular(20)
      //     ),
      //         child: TextField(
      //     controller: usernameController,
      //     decoration: InputDecoration(
      //       hintText: 'Enter Username',
      //       hintStyle: TextStyle(color:Colors.white),
           
      //     ),
      //   ),
      // ),
    );
  }

  Padding passField() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child:Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(130, 14, 100, 0.2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: TextField(
                            controller: passwordController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  
                                  hintStyle:
                                      TextStyle(color: Colors.grey[500])),
                                      obscureText: true,)) 
      // child: TextField(
      //   controller: passwordController,
      //   decoration: InputDecoration(
      //     hintText: 'Enter Password',
      //     border: new OutlineInputBorder(
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(30.0),
      //       ),
      //     ),
      //   ),
      //   obscureText: true,
      // ),
    );
  }
}
