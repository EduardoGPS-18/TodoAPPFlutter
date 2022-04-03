class TaskModel {
  final int id;
  final String title;
  final String subtitle;
  final DateTime endDate;
  final String description;
  final bool completed;

  TaskModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.endDate,
    required this.description,
    required this.completed,
  });

  bool get isToday {
    final todayDateTime = DateTime.now();
    final today = DateTime(todayDateTime.year, todayDateTime.month, todayDateTime.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    if (today.isAtSameMomentAs(end)) {
      return true;
    }
    return false;
  }

  factory TaskModel.fromApiMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      endDate: DateTime.parse("${map['end_date']}"),
      description: map['description'] ?? '',
      completed: map['completed'] as bool,
    );
  }
}
