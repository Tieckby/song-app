import 'package:flutter/material.dart';
import 'package:songapp/list_song.dart';

class SearchData extends SearchDelegate<String>{
  List songData = [];

  SearchData(this.songData);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return[
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation),

      onPressed: () {
      close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some results based on the selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when something is searching songData.where((p) => p.music_name.startWith(query)).toList()
    final suggestionList = query.isEmpty ? [] : [];

    print(songData.getRange(0, songData.length));

    /*return ListView.builder(
      itemCount: 5
      itemBuilder: (BuildContext context, int index) => ListTile(
          leading: new Icon(Icons.music_note),
          title: new Text('suggestionList[index].music_n          trailing: new IconButton(icon: new Icon(Icons.f      ),
              ame'),
              ile_download), onPressed: () {})
    );*/

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text(suggestionList[index].music_name),
            trailing: new IconButton(icon: new Icon(Icons.file_download), onPressed: () {})
        ),
    );
  }
}