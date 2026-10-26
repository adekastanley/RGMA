class StudentProfile {
  final String id;
  final String studentCode;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String level;
  final String campus;
  final String academicSession;
  final double overallAttendancePercent;
  final int completedCourses;
  final int totalCourses;
  final int completedSessions;
  final int totalSessions;

  const StudentProfile({
    required this.id,
    required this.studentCode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.level,
    required this.campus,
    required this.academicSession,
    required this.overallAttendancePercent,
    required this.completedCourses,
    required this.totalCourses,
    required this.completedSessions,
    required this.totalSessions,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String? ?? '',
      studentCode: json['student_code'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      level: json['level'] as String? ?? 'Level 1',
      campus: json['campus'] as String? ?? 'Abuja',
      academicSession: json['academic_session'] as String? ?? '2026–2027 Session',
      overallAttendancePercent:
          (json['overall_attendance_percent'] as num?)?.toDouble() ?? 0.0,
      completedCourses: json['completed_courses'] as int? ?? 0,
      totalCourses: json['total_courses'] as int? ?? 0,
      completedSessions: json['completed_sessions'] as int? ?? 0,
      totalSessions: json['total_sessions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_code': studentCode,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'level': level,
      'campus': campus,
      'academic_session': academicSession,
      'overall_attendance_percent': overallAttendancePercent,
      'completed_courses': completedCourses,
      'total_courses': totalCourses,
      'completed_sessions': completedSessions,
      'total_sessions': totalSessions,
    };
  }
}
