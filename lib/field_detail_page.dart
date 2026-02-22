// lib/pages/field_detail_page.dart
import 'package:flutter/material.dart';
import 'field_config.dart';
import 'content_section.dart';

class FieldDetailPage extends StatelessWidget {
  final FieldConfig field;
  final String content;
  final String cropName;

  const FieldDetailPage({
    super.key,
    required this.field,
    required this.content,
    required this.cropName,
  });

  // Consistent color for all detail pages
  static const kDarkGreen = Color(0xFF0B3B24);

  @override
  Widget build(BuildContext context) {
    final sections = _formatContent(content);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: kDarkGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    field.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kDarkGreen, kDarkGreen.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 56, top: 60),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        field.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Main Content Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: sections.isEmpty
                      ? _buildEmptyState(context)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sections
                              .map((section) => _buildSection(section))
                              .toList(),
                        ),
                ),
                
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      
      // Floating Action Button for Watch Video
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening video...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.play_circle_outline),
        label: const Text('Watch Video'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                field.icon,
                size: 50,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No content available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Information for this topic will be added soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ContentSection> _formatContent(String text) {
    final sections = <ContentSection>[];
    
    // Split by common section markers
    final parts = text.split(RegExp(r'\*\*\*|\*\*'));

    for (var part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;

      // Check if this is a heading
      final isHeading = trimmed.length < 100 &&
          (trimmed.endsWith(':') ||
              RegExp(r'^[A-Z][a-z]+(\s[A-Z][a-z]+)*$').hasMatch(trimmed) ||
              trimmed.startsWith('###') ||
              trimmed.startsWith('##'));

      if (isHeading) {
        sections.add(ContentSection(
          type: SectionType.heading,
          text: trimmed
              .replaceAll(':', '')
              .replaceAll('###', '')
              .replaceAll('##', '')
              .trim(),
        ));
      } else {
        // Split into paragraphs
        final paragraphs =
            trimmed.split('\n').where((p) => p.trim().isNotEmpty).toList();
        
        for (var para in paragraphs) {
          final cleaned = para.trim();
          
          // Check if it's a bullet point
          if (cleaned.startsWith('•') ||
              cleaned.startsWith('-') ||
              cleaned.startsWith('â€¢') ||
              RegExp(r'^\d+\.').hasMatch(cleaned)) {
            sections.add(ContentSection(
              type: SectionType.bullet,
              text: cleaned.replaceAll(RegExp(r'^[•\-â€¢\d+\.]\s*'), ''),
            ));
          } else {
            // Regular paragraph
            sections.add(ContentSection(
              type: SectionType.paragraph,
              text: cleaned,
            ));
          }
        }
      }
    }

    return sections;
  }

  Widget _buildSection(ContentSection section) {
    switch (section.type) {
      case SectionType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: kDarkGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        );
        
      case SectionType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, right: 12),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: kDarkGreen,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  section.text,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
        
      case SectionType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            section.text,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.6,
              fontSize: 14,
            ),
          ),
        );
    }
  }
}