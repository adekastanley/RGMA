class ClassQuestion {
  final String id;
  final String courseId;
  final int sessionNumber;
  final String studentName;
  final String questionText;
  final String createdAt;
  final String? instructorReply;
  final String? repliedBy;

  const ClassQuestion({
    required this.id,
    required this.courseId,
    required this.sessionNumber,
    required this.studentName,
    required this.questionText,
    required this.createdAt,
    this.instructorReply,
    this.repliedBy,
  });

  factory ClassQuestion.fromJson(Map<String, dynamic> json) {
    return ClassQuestion(
      id: json['id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      sessionNumber: json['session_number'] as int? ?? 1,
      studentName: json['student_name'] as String? ?? 'Student',
      questionText: json['question_text'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? 'Just now',
      instructorReply: json['instructor_reply'] as String?,
      repliedBy: json['replied_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'session_number': sessionNumber,
      'student_name': studentName,
      'question_text': questionText,
      'created_at': createdAt,
      'instructor_reply': instructorReply,
      'replied_by': repliedBy,
    };
  }
}
