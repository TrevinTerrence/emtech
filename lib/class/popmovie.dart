class PopMovie {
  int id;
  String title;
  String homepage;
  String overview;
  String releaseDate;
  String voteAverage;
  String? url;
  int runtime;
  final List? genres;
  final List? actor;
  List? scene;


  PopMovie({required this.id, required this.title,required this.homepage, required this.overview,required this.releaseDate,required this.voteAverage, this.url, required this.runtime, this.genres, this.actor,this.scene});
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
      id: json['movie_id'] as int,
      title: json['title'] as String,
      homepage: json['homepage'] as String,
      overview: json['overview'] as String,
      releaseDate: json['release_date'],
      voteAverage: json['voteAverage'] != null ? json['voteAverage'].toString() : '0.0',
      url: json['url'],
      runtime: json['runtime'] as int,
      genres: json['genres'],
      actor: json['actor'],
      scene: json['scenes']
    );
  }
}
