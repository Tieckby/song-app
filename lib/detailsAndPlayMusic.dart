
import 'package:flutter/material.dart';
import 'package:songapp/list_song.dart';

class DetailsPage extends StatelessWidget{

  final int index;
  List<GetSongData> songData;

  DetailsPage(this.songData, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Play music"),
      ),
      body: Center(
        child: Text(songData[index].music_name),
      ),

    );
  }

}