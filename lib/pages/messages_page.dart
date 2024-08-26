import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/Database/DatabaseService.dart';

class MessagesPage extends StatefulWidget {
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late String USERID;
  late DatabaseService _databaseService;
  List<String> followerIds = [];
  List<String> followingIds = [];

  @override
  void initState() {
    super.initState();
    USERID = FirebaseAuth.instance.currentUser!.uid;
    _databaseService = DatabaseService();
    fetchUserDetails();
    fetchFollowers();
    fetchFollowing();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userDetails =
        await _databaseService.getUserDetails(USERID);
    print(USERID);
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
      });
    } else {
      // Handle case where user details could not be retrieved
    }
  }

  void fetchFollowers() async {
    followerIds = await _databaseService.getFollowers(USERID);
  }

  void fetchFollowing() async {
    followingIds = await _databaseService.getFollowing(USERID);
  
    // Remove duplicates from followingIds that also exist in followerIds
    followingIds = followingIds.where((id) => !followerIds.contains(id)).toList();
  }

  Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userData != null
            ? Text(
                '${userData!['username']}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 19.0),
              )
            : CircularProgressIndicator(),
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: Colors.black, size: 30.0)),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: 20.0),
              child:
                  Icon(FontAwesomeIcons.video, color: Colors.black, size: 22.0)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.6)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.6)),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, size: 23.0)),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child:
                Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
          SizedBox(height: 23.0),
          // Displaying followers' messages
          for (String followerId in followerIds) ...[
            FutureBuilder<Map<String, dynamic>?>(
              future: _databaseService.getUserDetails(followerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  Map<String, dynamic>? userData = snapshot.data;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userData!['profilePictureURL']),
                      radius: 30.0,
                    ),
                    title: Text(userData['username'], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
                    subtitle: Text('Message text goes here', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                    trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
                  );
                }
              },
            ),
          ],
          // Displaying following users' messages
          for (String followingId in followingIds) ...[
            FutureBuilder<Map<String, dynamic>?>(
              future: _databaseService.getUserDetails(followingId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  Map<String, dynamic>? userData = snapshot.data;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userData!['profilePictureURL']),
                      radius: 30.0,
                    ),
                    title: Text(userData['username'], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
                    subtitle: Text('Message text goes here', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                    trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
