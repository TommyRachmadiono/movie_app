import 'package:flutter/material.dart';
import 'package:movie_app/screen/liked_movie_screen.dart';

class MyDrawer extends StatelessWidget {
  final String userName, userEmail;
  final int userId;
  final VoidCallback signOut;

  MyDrawer({this.userId, this.userName, this.userEmail, this.signOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35,
                  child: Icon(
                    Icons.person,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  userName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikedMovieScreen(userId: userId),
                ),
              );
            },
            leading: Icon(Icons.favorite, color: Colors.pink),
            title: Text('Liked Movies'),
          ),
          Divider(),
          ListTile(
            onTap: signOut,
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
