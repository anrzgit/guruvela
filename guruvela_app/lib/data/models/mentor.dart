import 'package:equatable/equatable.dart';

/// A mentor profile (`mentors` table).
class Mentor extends Equatable {
  const Mentor({
    required this.id,
    required this.name,
    required this.branch,
    required this.state,
    this.profileImagePath,
    this.googleFormLink1to1,
    this.groupGuidanceLink,
    this.linkedinUrl,
    this.active = true,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String branch;
  final String state;
  final String? profileImagePath;
  final String? googleFormLink1to1;
  final String? groupGuidanceLink;
  final String? linkedinUrl;
  final bool active;
  final int sortOrder;

  factory Mentor.fromMap(Map<String, dynamic> map) {
    return Mentor(
      id: '${map['id']}',
      name: (map['name'] ?? '') as String,
      branch: (map['branch'] ?? '') as String,
      state: (map['state'] ?? '') as String,
      profileImagePath: map['profile_image_path'] as String?,
      googleFormLink1to1: map['google_form_link_1_to_1'] as String?,
      groupGuidanceLink: map['group_guidance_link'] as String?,
      linkedinUrl: map['linkedin_url'] as String?,
      active: (map['active'] as bool?) ?? true,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, branch, state];
}
