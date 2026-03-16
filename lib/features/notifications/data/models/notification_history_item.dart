import 'dart:convert';

class NotificationHistoryItem {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final Map<String, String> data;
  final String source;

  NotificationHistoryItem({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.data,
    required this.source,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'receivedAt': receivedAt.toIso8601String(),
      'data': data,
      'source': source,
    };
  }

  factory NotificationHistoryItem.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return NotificationHistoryItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      receivedAt:
          DateTime.tryParse(json['receivedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      data: (rawData is Map)
          ? rawData.map((key, value) => MapEntry(key.toString(), value.toString()))
          : <String, String>{},
      source: json['source'] as String? ?? 'unknown',
    );
  }

  String encode() => jsonEncode(toJson());

  static NotificationHistoryItem decode(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return NotificationHistoryItem.fromJson(json);
  }
}
