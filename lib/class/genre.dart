class Genre {
  int genre_id;
  String genre_name;
  Genre({required this.genre_id, required this.genre_name});

  factory Genre.fromJSON(Map<String, dynamic> json) {
    return Genre(
      genre_id: json["value"],
      genre_name: json["label"],
    );
  }
}
