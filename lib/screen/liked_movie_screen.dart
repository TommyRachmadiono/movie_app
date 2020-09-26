import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/utils/custom_style.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/utils/network_url.dart';
import 'detail_movie_screen.dart';

class LikedMovieScreen extends StatefulWidget {
  final int userId;
  LikedMovieScreen({this.userId});
  @override
  _LikedMovieScreenState createState() => _LikedMovieScreenState();
}

class _LikedMovieScreenState extends State<LikedMovieScreen> {
  List videos = [];

  Future getLikedVideos() async {
    final response =
        await http.get("$NETWORK_URL/liked-videos/${widget.userId}");
    final data = jsonDecode(response.body);
    videos = data['videos'];

    return videos;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your Liked Movies'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.cyan,
          child: FutureBuilder(
            future: getLikedVideos(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                print(snapshot.data);
                return ListView.builder(
                  itemCount: videos.length == 0 ? 0 : videos.length,
                  itemBuilder: (context, index) {
                    return _buildCardMovie(videos[index]);
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

  Widget _buildCardMovie(video) {
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
                      icon: Icon(Icons.favorite, color: Colors.pink),
                      onPressed: () {},
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
