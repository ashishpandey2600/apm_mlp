import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import '../ChatFunctionality/model/usermodel.dart';
import 'Screens/PDF/homepage.dart';
import 'Screens/profilepage.dart';
import 'Screens/ShowMyUploadpage.dart';
import 'widget/bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final UserModel userModel;
  final User firebaseUser;
  const DashboardScreen(
      {required this.pageIndex,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<String> _titles;
  late PageController _pageController;
  late List<BottomNavigationBarItem> bottomNavbarList;

  int _pageIndex = 0;
   // String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  late final List<Widget> _screens = [
    HomePage(
      userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,
    ),
    UploadPage(
      userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,
    ),
    ProfilePage(
      userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,
    ),
    // ChatRoomPage(targetUser: targetUser, chatroom: chatroom, userModel: userModel, firebaseUser: firebaseUser)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _titles = ["APM", "profile", "Chat", "Upload"];

    bottomNavbarList = [
      bottomNavigationBar(context, Icons.home, "APM"),
      bottomNavigationBar(context, Icons.home, "Uploads"),
      bottomNavigationBar(context, Icons.home, "profile"),
    ];
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavbarList,
        onTap: _setPage,
        currentIndex: _pageIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _screens,
      ),
    );
  }
}
