import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Database/DatabaseService.dart';

class StoriesWidget extends StatefulWidget {
  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  DatabaseService databaseService = DatabaseService();
  String USERID = FirebaseAuth.instance.currentUser!.uid;
   Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userDetails =
        await databaseService.getUserDetails(USERID);
    print(USERID);
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
      });
    } else {
      // Handle case where user details could not be retrieved
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(width: 20.0),
          Stack(
            children: <Widget>[
              Container(
                height: 70.0,
                child: ClipOval(
                  child: userData != null &&
                      userData!['profilePictureURL'] != null &&
                      userData!['profileUrl'] != ''
                      ? Image.network(
                          userData!['profilePictureURL'],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/default_profile.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: -1.0,
                right: -1.0,
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 10.0,
                    ),
                    Icon(Icons.add_circle, size: 20.0, color: Colors.blue),
                  ],
                )
              ),
            ],
          ),

          SizedBox(width: 20.0),

          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
              ),
              Container(
                width: 66.0,
                height: 66.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
              ),
              ClipOval(
                child: Image.asset(
                  "assets/eddison.jpg",
                  fit: BoxFit.cover,
                  width: 60.0,
                ),
              ),
            ],
          ),

          SizedBox(width: 20.0),

          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
              ),
              Container(
                width: 66.0,
                height: 66.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
              ),
              ClipOval(
                child: Image.asset(
                  "assets/ryan.jpg",
                  fit: BoxFit.cover,
                  width: 60.0,
                ),
              ),
            ],
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/nick.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/mathew.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/sophia.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/joey.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/adelle.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),

          ClipOval(
            child: Image.asset(
              "assets/natasha.jpg",
              fit: BoxFit.cover,
              width: 70.0,
            )
          ),

          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}