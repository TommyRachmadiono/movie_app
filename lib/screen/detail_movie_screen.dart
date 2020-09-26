import 'package:flutter/material.dart';
import 'package:movie_app/ui/webview_video_player.dart';
import 'package:movie_app/utils/custom_style.dart';
import 'package:movie_app/utils/network_url.dart';

class DetailMovieScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;

  DetailMovieScreen({this.videoId, this.title, this.description});

  @override
  _DetailMovieScreenState createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  @override
  Widget build(BuildContext context) {
    String _title = widget.title;
    String _description = widget.description;
    String _videoId = widget.videoId;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("$_title"),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.cyan,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Image.network("$YOUTUBE_THUMBNAIL/$_videoId/0.jpg"),
              RaisedButton(
                child: Text("Play Video"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayer(url: "$YOUTUBE_VIDEO/$_videoId"),
                    ),
                  );
                },
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description', style: titleText),
                      Divider(),
                      Text(_description),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
