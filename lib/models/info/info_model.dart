class InfoModel {
  final int completedTasks;
  final int totalTasks;

  InfoModel({
    required this.completedTasks,
    required this.totalTasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
    };
  }

  factory InfoModel.fromMap(Map<String, dynamic> map) {
    print(map['completedTasks'].runtimeType);
    return InfoModel(
      completedTasks: int.parse("${map['completedTasks']}"),
      totalTasks: int.parse("${map['totalTasks']}"),
    );
  }
}
