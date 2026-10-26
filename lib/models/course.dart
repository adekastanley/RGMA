import 'class_session.dart';

class Instructor {
  final String id;
  final String name;
  final String title;
  final String bio;
  final String initials;
  final int coursesCount;

  const Instructor({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.initials,
    this.coursesCount = 3,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? 'Senior Instructor',
      bio: json['bio'] as String? ?? '',
      initials: json['initials'] as String? ?? 'IN',
      coursesCount: json['courses_count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'bio': bio,
      'initials': initials,
      'courses_count': coursesCount,
    };
  }
}

class Course {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final String category;
  final String level;
  final String totalDuration;
  final String scheduleText;
  final String syllabusOverview;
  final List<String> syllabusObjectives;
  final Instructor instructor;
  final List<ClassSession> sessions;
  final bool isOngoing;
  final double rating;
  final int enrolledCount;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.level,
    required this.totalDuration,
    required this.scheduleText,
    required this.syllabusOverview,
    required this.syllabusObjectives,
    required this.instructor,
    required this.sessions,
    this.isOngoing = true,
    this.rating = 4.9,
    this.enrolledCount = 148,
  });

  int get totalSessions => sessions.length;

  int get completedSessionsCount =>
      sessions.where((s) => s.isAttendanceMarked || s.isCompleted).length;

  double get progressPercent {
    if (sessions.isEmpty) return 0.0;
    return completedSessionsCount / sessions.length;
  }

  int get progressIntPercent => (progressPercent * 100).round();

  Course copyWith({
    String? id,
    String? code,
    String? title,
    String? subtitle,
    String? category,
    String? level,
    String? totalDuration,
    String? scheduleText,
    String? syllabusOverview,
    List<String>? syllabusObjectives,
    Instructor? instructor,
    List<ClassSession>? sessions,
    bool? isOngoing,
    double? rating,
    int? enrolledCount,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      level: level ?? this.level,
      totalDuration: totalDuration ?? this.totalDuration,
      scheduleText: scheduleText ?? this.scheduleText,
      syllabusOverview: syllabusOverview ?? this.syllabusOverview,
      syllabusObjectives: syllabusObjectives ?? this.syllabusObjectives,
      instructor: instructor ?? this.instructor,
      sessions: sessions ?? this.sessions,
      isOngoing: isOngoing ?? this.isOngoing,
      rating: rating ?? this.rating,
      enrolledCount: enrolledCount ?? this.enrolledCount,
    );
  }
}
