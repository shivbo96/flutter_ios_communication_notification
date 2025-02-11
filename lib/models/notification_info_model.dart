// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationInfo {
  final String senderName;
  final String imageUrl;
  final String content;
  final String value;
  final Function(String payload)? onPressed;

  NotificationInfo({
    required this.senderName,
    required this.imageUrl,
    required this.content,
    required this.value,
    this.onPressed,
  });

  NotificationInfo copyWith({
    String? senderName,
    String? imageUrl,
    String? content,
    String? value,
    Function(String payload)? onPressed,
  }) {
    return NotificationInfo(
      senderName: senderName ?? this.senderName,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      value: value ?? this.value,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderName': senderName,
      'imageUrl': imageUrl,
      'content': content,
      'value': value,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'NotificationInfo(senderName: $senderName, imageUrl: $imageUrl, content: $content, value: $value, onPressed: $onPressed)';
  }

  @override
  bool operator ==(covariant NotificationInfo other) {
    if (identical(this, other)) return true;

    return other.senderName == senderName &&
        other.imageUrl == imageUrl &&
        other.content == content &&
        other.value == value &&
        other.onPressed == onPressed;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^ imageUrl.hashCode ^ content.hashCode ^ value.hashCode ^ onPressed.hashCode;
  }
}
