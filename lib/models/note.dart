class Note {
  int id;
  String author;
  String title;
  String desc;
  String favorite;

  Note({
    required this.id,
    required this.author,
    required this.title,
    required this.desc,
    required this.favorite,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      author: json['author'],
      title: json['title'],
      desc: json['desc'],
      favorite: json['favorite'],
    );
  }
}
