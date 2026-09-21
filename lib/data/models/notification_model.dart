class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.readAt,
    this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime? readAt;
  final DateTime? createdAt;

  bool get isUnread => readAt == null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      type: (json['type'] as String?) ?? 'info',
      readAt: DateTime.tryParse(json['read_at']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class NotificationInbox {
  const NotificationInbox({required this.items, required this.unreadCount});

  final List<NotificationModel> items;
  final int unreadCount;

  factory NotificationInbox.fromJson(Map<String, dynamic> json) {
    final items = (json['data'] as List<dynamic>)
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>?;
    return NotificationInbox(
      items: items,
      unreadCount:
          (meta?['unread_count'] as num?)?.toInt() ??
          items.where((item) => item.isUnread).length,
    );
  }
}
