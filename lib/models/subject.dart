class Subject {
  final String id;
  final String name;
  final String description;
  final String imagePath;

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
    );
  }
}
