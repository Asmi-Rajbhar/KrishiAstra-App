class ChecklistItem {
  final String title;
  final String subtitle;
  bool isCompleted;
  bool isReminderActive;

  ChecklistItem({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isReminderActive = false,
  });
}
