import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/groupmembers.dart';

class GroupDetail extends StatefulWidget {
  final String grpName;
  final String username;
  final int grpCode;

  GroupDetail(this.grpName, this.username, this.grpCode);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  final transactionController = TextEditingController();

  Future<List<GroupMembers>> getGroupMembers() async {
    String url = 'http://10.0.2.2:5000/getgroupmembers?grpcode=' +
        widget.grpCode.toString();
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List result = json.decode(response.body);
      print(result);
      List<GroupMembers> usergroups = [];
      for (var u in result) {
        GroupMembers grp =
            GroupMembers(u['userId'], u['username'], u['paid'], u['toBePaid']);
        usergroups.add(grp);
        print('decoded');
      }
      print(usergroups);
      return usergroups;
    } else {
      print("fail");
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red[900],
                      Colors.red[800],
                      Colors.orange[400]
                    ])),
          ),
          centerTitle: true,
          title: Text(widget.grpName),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      body:  Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: getGroupMembers(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text("Loading..."));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.white24))),
                              child:
                                  Icon(Icons.account_circle, color: Colors.white),
                            ),
                            title: Text(
                              snapshot.data[index].username,
                              style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            subtitle: Text(
                                "\nPaid:  " +
                                    snapshot.data[index].paid.toString() +
                                    "\nTo Be Paid:  " +
                                    snapshot.data[index].toBePaid
                                        .toStringAsFixed(2)
                                        .toString(),
                                style: TextStyle(color: Colors.white)),
                          );
                        },
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return startAddTransaction(context);
                      },
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                        Colors.red[400],
                        Colors.red[800],
                        Colors.red[900],
                      ]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(child: Text('Add Transaction', style: TextStyle(color:Colors.white),)),
                  ),
                ),
                SizedBox(height: 40)
              ],
            )),
      

      // floatingActionButton: FloatingActionButton.extended(

      //     backgroundColor: Colors.red[900],

      //     label: Text("Add Transaction")),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<String> addTransaction(double amount) async {
    String url = 'http://10.0.2.2:5000/addtransaction?username=' +
        widget.username +
        '&grpcode=' +
        widget.grpCode.toString() +
        '&amount=' +
        amount.toString();
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

  AlertDialog startAddTransaction(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Text(
        "Add a Transaction",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        controller: transactionController,
        decoration: InputDecoration(
          hintText: 'Amount You Spent',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: new OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
          child: InkWell(
            onTap:() async {
              String status = await addTransaction(
                  double.parse(transactionController.text.trim()));
              setState(() {
                getGroupMembers();
              });
              print(status);
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                      Colors.red[400],
                      Colors.red[800],
                      Colors.red[900],
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Center(
                    child: Text(
                  "Add transaction",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            // color: Colors.red[900],
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(18.0),
            // ),
          ),
        ),
      ],
    );
  }
}



