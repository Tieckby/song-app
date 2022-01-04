import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:songapp/detailsAndPlayMusic.dart';

import 'list_song.dart' show GetSongData;
import 'package:songapp/searchData.dart';

//Fonction main de l'application
void main()=> runApp(new MySongApp());

//La classe principale de l'application
class MySongApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My Song", //Titre
        theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false, //La petite Banner en haut à droite
        home: new Song_Home()
    );
  }
}

class Song_Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _Song_Home();
  }
}

// ignore: camel_case_types
class _Song_Home extends State<Song_Home>{

//  PermissionStatus _permissionStatus;

  String musicUrl = "http://192.168.43.129/dbAndroid_App.php"; //"https://tiemoko.000webhostapp.com/Fetch_data.php";
  String link = "http://192.168.43.129/";
  List<GetSongData> songData = [];

  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchMusicFromServer();
  }

  Future<void> downloadFile(String music) async {
    Dio dio = Dio();

    try{
      Directory dir = await getExternalStorageDirectory();

      Fluttertoast.showToast(
          msg: "Emplacement: "+dir.path,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white);

      if(await Permission.storage.request().isGranted){
        await dio.download(link+music, dir.path+"/$music", onReceiveProgress: (rec, total){
          print("Rec: $rec, Total: $total");

          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + " %";
          });
        });
        print(dir.path+"/$music");
      }else{
        openAppSettings();
      }
    }catch(e){
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Termine";
    });

  }

  Future<List<GetSongData>> fetchMusicFromServer() async
  {
    var response = await http.get(musicUrl);
    if (response.statusCode == 200) {
      var convertedJson = json.decode(response.body);
      var musicList = convertedJson['data'];

      setState(() {
        for(Map music in musicList)
        {
          songData.add(GetSongData.fromJSON(music));
        }
      });
    } else {
      throw Exception('Chargement des donnees impossible...');
    }

    return songData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("My Song"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {
              showSearch(context: context, delegate: SearchData(songData));
            },)
          ],//Le titre
        ),
        body: downloading ? new Center(
          child: new Container(
            height: 120.0,
            width: 200.0,
            child: Card(
              color: Colors.black,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0,),
                  Text("Telechargement : $progressString", style: TextStyle(
                      color: Colors.white),)
                ],
              )
            ),
          )
        ) : new Container(
          child: songData.length == 0 ? Container(
              child: new Center(
                child: new Text("Charge les elements...")
              )
          ) : ListView.builder(
                itemCount: songData.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                      leading: new Icon(Icons.music_note),
                      title: new Text(songData[index].music_name),
                      trailing: new IconButton(icon: new Icon(Icons.file_download), onPressed: () => downloadFile(songData[index].music_path)),
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsPage(songData, index)));
                    },
                  );
              }
          )
        ),
    );
  }
}


