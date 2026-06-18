import 'package:equatable/equatable.dart';

/// A document row (`document` table), e.g. a JoSAA official document link.
class DocumentItem extends Equatable {
  const DocumentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
  });

  final String id;
  final String title;
  final String description;
  final String link;

  factory DocumentItem.fromMap(Map<String, dynamic> map) {
    return DocumentItem(
      id: '${map['id']}',
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      link: (map['link'] ?? '') as String,
    );
  }

  @override
  List<Object?> get props => [id, title, description, link];
}
