import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/pages/BottomDialog/archive_page.dart';
import 'package:instagram/pages/BottomDialog/close_friends_page.dart';
import 'package:instagram/pages/BottomDialog/favourites_page.dart';
import 'package:instagram/pages/BottomDialog/meta_verified_page.dart';
import 'package:instagram/pages/BottomDialog/orders_and_payments_page.dart';
import 'package:instagram/pages/BottomDialog/qr_code_page.dart';
import 'package:instagram/pages/BottomDialog/saved_page.dart';
import 'package:instagram/pages/BottomDialog/settings_privacy_page.dart';
import 'package:instagram/pages/BottomDialog/supervision_page.dart';
import 'package:instagram/pages/BottomDialog/your_activity_page.dart';
import 'package:instagram/pages/edit_profile.dart';
import 'package:instagram/pages/login_page.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String USERID = FirebaseAuth.instance.currentUser!.uid;

  DatabaseService _databaseService = DatabaseService();

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
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

  @override
  Widget build(BuildContext context) {
     double deviseWidth = MediaQuery.of(context).size.width;
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
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildBottomSheetOption(
                              context,
                              'Settings and Privacy',
                              'assets/settings.png',
                              SettingaAndPrivacyPage()),
                          _buildBottomSheetOption(context, 'Your Activity',
                              'assets/activity.png', YourActivityPage()),
                          _buildBottomSheetOption(context, 'Archive',
                              'assets/archive.png', ArchivePage()),
                          _buildBottomSheetOption(context, 'QR code',
                              'assets/qrcode.png', QRCodePage()),
                          _buildBottomSheetOption(context, 'Saved',
                              'assets/saved.png', SavedPage()),
                          _buildBottomSheetOption(context, 'Supervision',
                              'assets/supervision.png', SupervisionPage()),
                          _buildBottomSheetOption(
                              context,
                              'Orders and Payments',
                              'assets/ordersandpayments.png',
                              OrdersandPaymentsPage()),
                          _buildBottomSheetOption(context, 'Meta Verified',
                              'assets/verified.png', MetaVerifiedPage()),
                          _buildBottomSheetOption(context, 'Close Friends',
                              'assets/closefriends.png', CloseFriendsPage()),
                          _buildBottomSheetOption(context, 'Favourites',
                              'assets/favourites.png', FavouritesPage()),
                          _buildBottomSheetOption(
                              context, 'Logout', 'assets/logout.png', () {
                            print('Attempting to log out...');
                            DatabaseService databaseService = DatabaseService();
                            databaseService.signOut().then((_) {
                              print('User logged out successfully.');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }).catchError((error) {
                              print('Error occurred during logout: $error');
                            });
                          })

                          // Add more options as needed
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.menu, color: Colors.black, size: 30.0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: userData != null
            ? Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(22.0, 35.0, 22.0, 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage: userData != null &&
                                      userData!['profilePictureURL'] != null &&
                                      userData!['profileUrl'] != ''
                                  ? NetworkImage(userData!['profilePictureURL'])
                                      as ImageProvider
                                  : AssetImage('assets/default_profile.jpg'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${userData!['postsCount']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.0),
                                ),
                                SizedBox(height: 5.0),
                                Text('Posts', style: TextStyle(fontSize: 15.0))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${userData!['followersCount']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.0),
                                ),
                                SizedBox(height: 5.0),
                                Text('Followers',
                                    style: TextStyle(fontSize: 15.0))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${userData!['followingCount']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18.0),
                                ),
                                SizedBox(height: 5.0),
                                Text('Following',
                                    style: TextStyle(fontSize: 15.0))
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData!['username']}',
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: deviseWidth * .02),
                              Text(
                                '${userData!['bio']}',
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfilePage()));
                          },
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    width: 0.1, color: Colors.black)),
                            child: Center(
                                child: Text('Edit Profile',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // Other content
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story1.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story8.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story2.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story4.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story5.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story3.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story6.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story9.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story10.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story11.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story12.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story13.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story14.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story15.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story16.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story17.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story18.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story19.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story20.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story21.jpg',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3 - 2,
                              height: MediaQuery.of(context).size.width / 3 - 2,
                              child: Image.asset('assets/story4.jpg',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40.0),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildBottomSheetOption(
      BuildContext context, String optionText, String imagePath, dynamic page) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        height: 30,
        width: 30,
      ),
      title: Text(optionText),
      onTap: () {
        if (page is Widget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else if (page is Function) {
          page();
        }
      },
    );
  }
}
