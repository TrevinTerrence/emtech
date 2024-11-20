class PopActor {
  int id;
  String name;

  PopActor({required this.id, required this.name});
  factory PopActor.fromJson(Map<String, dynamic> json) {
    return PopActor(
      id: json['person_id'] as int,
      name: json['person_name'] as String,
    );
  }
}