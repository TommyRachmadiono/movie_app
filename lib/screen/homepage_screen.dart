import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/screen/detail_movie_screen.dart';
import 'package:movie_app/ui/drawer.dart';
import 'package:movie_app/utils/custom_style.dart';
import 'package:movie_app/utils/network_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  final VoidCallback signOut;
  HomePageScreen(this.signOut);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String userName = '';
  String userEmail = '';
  int userId;
  List likedVideos = [];
  List videos = [];
  Set liked;

  getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getInt('userId');
    userName = pref.getString('userName');
    userEmail = pref.getString('userEmail');
  }

  getLikedVideos() async {
    final response = await http.get("$NETWORK_URL/youtube-videos/$userId");
    final data = jsonDecode(response.body);
    likedVideos.addAll(data['liked_videos']);
    print(likedVideos);
  }

  Future getVideos() async {
    final response = await http.get("$NETWORK_URL/youtube-videos/$userId");
    final data = jsonDecode(response.body);
    videos = data['videos'];
    likedVideos = data['liked_videos'];

    return videos;
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
    getLikedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Movie App'),
      ),
      drawer: MyDrawer(
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        signOut: widget.signOut,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.cyan,
          child: FutureBuilder(
            future: getVideos(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                // print(snapshot.data);
                return ListView.builder(
                  itemCount: videos.length == 0 ? 0 : videos.length,
                  itemBuilder: (context, index) {
                    return _buildCardMovie(videos[index], likedVideos);
                  },
                );
              } else {
                return Center(
                  child: SpinKitThreeBounce(
                    color: Colors.blue,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardMovie(video, likedVideo) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMovieScreen(
                        videoId: video['video_id'],
                        title: video['title'],
                        description: video['description'],
                      ),
                    ),
                  );

                  setState(() {});
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          "$YOUTUBE_THUMBNAIL/${video['video_id']}/0.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        video['title'],
                        style: titleText,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.pink),
                      onPressed: () async {
                        // MASIH ERROR
                        // final response = await http.post("$NETWORK_URL/", body: {
                        //   'user_id': userId.toString(),
                        //   'video_id': video['id'].toString(),
                        // });
                        // final data = jsonDecode(response.body);

                        // print(data);
                        // setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
