import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/tabs/search_tab.dart';

class UserShowingPage extends StatefulWidget {
  final UserDetails userDetails;

  const UserShowingPage({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<UserShowingPage> createState() => _UserShowingPageState();
}

class _UserShowingPageState extends State<UserShowingPage> {
  late UserDetails user; // Change User to UserDetails
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = widget.userDetails; // Use widget.userDetails here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.username,
        ),
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
              child: Icon(Icons.more_vert_outlined,
                  color: Colors.black, size: 22.0)),
        ],
      ),
      body: SingleChildScrollView(
        child: user != null
            ? Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(22.0, 35.0, 22.0, 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage: NetworkImage(
                                  user.profilePictureUrl) as ImageProvider,
                            ),
                            SizedBox(width: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                      '${user.postsCount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.0),
                                    ),
                                SizedBox(height: 5.0),
                                Text('Posts', style: TextStyle(fontSize: 15.0))
                                ],
                              ),
                              SizedBox(width: 20,),
                                Column(
                                  children: [
                                    Text(
                                      '${user.followersCount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text('Followers', style: TextStyle(fontSize: 15.0)),
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  children: [
                                    Text(
                                      '${user.followingCount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(height: 5.0),
                                   Text('Following', style: TextStyle(fontSize: 15.0)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Text(
                            '${user.username}',
                             style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                             fontSize: 15.0),
                           ),
                           SizedBox(height: 10,),
                           Text(
                            '${user.bio}',
                             style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                             fontSize: 15.0),
                           ),
                          ],
                        ) ,
                        SizedBox(height: 20,),
                        ElevatedButton(
                              onPressed: () async {
                                if (user.isFollowing) {
                                  await databaseService.unfollowUser(
                                      currentUserID, user.userID);
                                  setState(() {
                                    user.isFollowing = false;
                                    // Decrease the followingCount of the current user
                                    userData!['followingCount'] -= 1;
                                  });
                                } else {
                                  await databaseService.followUser(
                                      currentUserID, user.userID);
                                  setState(() {
                                    user.isFollowing = true;
                                    // Increase the followingCount of the current user
                                    userData!['followingCount'] += 1;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ), backgroundColor: user.isFollowing
                                    ? Colors.grey
                                    : Colors.blue,
                                minimumSize: Size(400, 40)
                              ),
                              child: Text(
                                user.isFollowing ? 'Following' : 'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        )                      
                      ],
                    ),
                  ),
                  // Other content
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
