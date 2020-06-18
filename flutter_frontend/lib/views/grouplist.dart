import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import '../models/usergroups.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './groupdetail.dart';

class GroupList extends StatefulWidget {
  String username;
  GroupList(String username) {
    this.username = username;
  }

  @override
  _GroupListState createState() => _GroupListState(username);
}

class _GroupListState extends State<GroupList> {
  final groupNameController = TextEditingController();
  final groupCodeController = TextEditingController();
  String username;
  _GroupListState(this.username);

  Future<List<UserGroups>> getUserGroups() async {
    String url = 'http://10.0.2.2:5000/getusergroups?username=' + username;
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List result = json.decode(response.body);
      List<UserGroups> usergroups = [];
      for (var u in result) {
        UserGroups grp =
            UserGroups(u['id'], u['userId'], u['grpCode'], u['grpName']);
        usergroups.add(grp);
      }
      print(usergroups[0].grpName);
      return usergroups;
    } else {
      print("fail");
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   cursorColor: Colors.red,
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.red[900],
      //   accentColor: Colors.black,
      // ),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        drawer: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            child: leftDrawer(context)),
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
            title: Text("Group List"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
        ),
        body:  Container(
            padding: EdgeInsets.only(top: 20),
            child: FutureBuilder(
              future: getUserGroups(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loading..."));
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return ListTile(
                    //   title: Text(snapshot.data[index].grpCode.toString()),
                    // );
                    return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupDetail(
                                      snapshot.data[index].grpName,
                                      username,
                                      snapshot.data[index].grpCode)));
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.assignment, color: Colors.white),
                        ),
                        title: Text(
                          snapshot.data[index].grpName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10,
                            ),
                            Text(
                                "Code:  " +
                                    snapshot.data[index].grpCode.toString(),
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.white, size: 30.0));
                  },
                );
              },
            ),
          ),
        
      ),
    );
  }

  Future<String> joinGroup(int grpCode) async {
    String url = 'http://10.0.2.2:5000/joingroup?username=' +
        widget.username +
        '&grpcode=' +
        grpCode.toString();
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

  Future<String> createGroup(String grpName, int grpCode) async {
    String url = 'http://10.0.2.2:5000/creategroup?username=' +
        widget.username +
        '&grpcode=' +
        grpCode.toString() +
        '&grpname=' +
        grpName;
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

  Future<int> generateGroupCode() async {
    int grpCode;
    String condition;
    do {
      var rand = new Random();
      int min = 1000;
      grpCode = min + rand.nextInt(8999);
      String url =
          'http://10.0.2.2:5000/checkgroup?grpcode=' + grpCode.toString();
      print(url);
      print("before response");
      final response = await http.get(url);
      print("after response");

      if (response.statusCode == 200) {
        Map result = json.decode(response.body);
        print("inside response");
        condition = result['status'];
        print(result['status']);
      } else {
        print("fail");
        throw Exception('Failed to load album');
      }
    } while (condition == 'Failure');
    return grpCode;
  }

  AlertDialog startCreateForm(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Text(
        "Create A Group",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        style: TextStyle(color: Colors.white),
        controller: groupNameController,
        decoration: InputDecoration(
          hintText: 'Group Name',
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
            onTap: () async {
              int grpCode = await generateGroupCode();
              print(grpCode);
              String status =
                  await createGroup(groupNameController.text.trim(), grpCode);
              setState(() {});
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
                  "Create Group",
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

  AlertDialog startJoinForm(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Text(
        "Join A Group",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        controller: groupCodeController,
        decoration: InputDecoration(
          hintText: 'Group Code',
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
            onTap: () async {
              print(int.parse(groupCodeController.text.trim()));
              String status =
                  await joinGroup(int.parse(groupCodeController.text.trim()));
              setState(() {});
              print(status);
              if (status == "Group Doesnt Exist") {
                Fluttertoast.showToast(
                    msg: status,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              if (status == "Joined Group") {
                Fluttertoast.showToast(
                    msg: status,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).pop();
              }
              if (status == "Already In The Group") {
                Fluttertoast.showToast(
                    msg: status,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
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
                  "Join Group",
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

    //keyboardType: TextInputType.number,
    //controller: groupCodeController,
  }

  Drawer leftDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.red[900],
                  Colors.red[800],
                  Colors.orange[400]
                ]),
              ),
              accountEmail: Text(""),
              accountName: Text(
                widget.username,
                style: TextStyle(fontSize: 50),
              ),
            ),
            ListTile(
              title: Text(
                "Create Group",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return startCreateForm(context);
                  },
                );
                // createGroupButton(context);
              },
            ),
            ListTile(
              title: Text("Join Group", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.add, color: Colors.white),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return startJoinForm(context);
                  },
                );
                // createGroupButton(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
