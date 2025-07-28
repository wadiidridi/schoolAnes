class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String type;
  final String priority;
  final DateTime? publishDate;
  final List<dynamic>? attachments;
  final bool isRead; // <-- Nouveau champ

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.priority,
    this.publishDate,
    this.attachments,
    required this.isRead, // <-- Ajout ici
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'general',
      priority: json['priority'] ?? 'medium',
      publishDate: json['publishDate'] != null
          ? DateTime.parse(json['publishDate'])
          : null,
      attachments: json['attachments'] as List<dynamic>?,
      isRead: json['isRead'] ?? false, // <-- Ajout ici
    );
  }
}
