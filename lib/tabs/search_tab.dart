import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/pages/user_showing_page.dart';
import 'package:instagram/widgets/search_categories.dart';

class UserDetails {
  final String userID;
  final String username;
  final String bio;
  final String profilePictureUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  bool isFollowing;

  UserDetails({
    required this.userID,
    required this.username,
    required this.bio,
    required this.profilePictureUrl,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
  });
}

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<UserDetails> searchResults = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userDetails =
        await databaseService.getUserDetails(currentUserID);
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
      });
    } else {
      // Handle case where user details could not be retrieved
    }
  }

  void search(String query, String currentUsername) {
    if (query.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isNotEqualTo: currentUsername)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        setState(() {
          isSearching = true;
          searchResults.clear();
        });
        for (DocumentSnapshot doc in querySnapshot.docs) {
          final user = UserDetails(
              userID: doc.id,
              username: doc['username'],
              bio: doc['bio'],
              profilePictureUrl: doc['profilePictureURL'],
              isFollowing:
                  (doc['followers'] as List<dynamic>).contains(currentUserID),
              followersCount: doc['followersCount'],
              followingCount: doc['followingCount'],
              postsCount: doc['postsCount']);
          setState(() {
            searchResults.add(user);
          });
        }
      }).catchError((error) {
        print("Failed to search: $error");
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) =>
                            search(query, userData!['username']),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, size: 30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SearchCategories(),
              isSearching
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    UserShowingPage(userDetails: user)));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePictureUrl),
                            ),
                            title: Text(user.username),
                            trailing: ElevatedButton(
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
                              ),
                              child: Text(
                                user.isFollowing ? 'Following' : 'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text('Default Content'),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
