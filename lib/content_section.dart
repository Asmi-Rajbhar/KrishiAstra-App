// lib/models/content_section.dart

enum SectionType { heading, bullet, paragraph }

class ContentSection {
  final SectionType type;
  final String text;

  ContentSection({
    required this.type,
    required this.text,
  });
}