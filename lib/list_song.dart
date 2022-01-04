class GetSongData {
  final int id_music;
  final String music_path;
  final String music_image;
  final String music_name;

  GetSongData({this.id_music, this.music_path, this.music_image, this.music_name});

  factory GetSongData.fromJSON(json)
  {
    return GetSongData(
        id_music: int.parse(json['id_music']),
        music_path: json['music_path'].toString(),
        music_image: json['music_image'].toString(),
        music_name: json['music_name'].toString()
    );
  }
}