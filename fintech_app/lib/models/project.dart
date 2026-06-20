class Project {
  final int id;
  final String title;
  final String description;
  final int userId;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sans titre',
      description: json['body'] ?? 'Pas de description',
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': description,
      'userId': userId,
    };
  }
}

class ProjectTask {
  final int id;
  final String title;
  final bool completed;
  final int projectId;

  ProjectTask({
    required this.id,
    required this.title,
    required this.completed,
    required this.projectId,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tâche sans nom',
      completed: json['completed'] ?? false,
      projectId: json['userId'] ?? 0, // Using userId from JSONPlaceholder to simulate projectId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': projectId,
    };
  }
}
