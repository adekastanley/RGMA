/// Centralized API configuration and endpoint routes for Rhema Go.
///
/// Backend engineers can update [baseUrl] and use these route constants
/// inside `lib/services/api_service.dart`.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.rhemangr.org/v1';
  static const String webPortalTuitionUrl = 'https://elearning.rhemangr.org/tuition';

  // Authentication & Student Profile
  static const String login = '$baseUrl/auth/login';
  static const String studentProfile = '$baseUrl/student/profile';
  static const String progressReport = '$baseUrl/student/progress-report';

  // Courses & E-Learning Classroom
  static const String ongoingCourses = '$baseUrl/elearning/courses/ongoing';
  static const String allCourses = '$baseUrl/elearning/courses';
  static String courseDetail(String courseId) =>
      '$baseUrl/elearning/courses/$courseId';
  static String courseSessions(String courseId) =>
      '$baseUrl/elearning/courses/$courseId/sessions';

  // Attendance & Q&A
  static String markAttendance(String sessionId) =>
      '$baseUrl/elearning/sessions/$sessionId/attendance';
  static String sessionQuestions(String sessionId) =>
      '$baseUrl/elearning/sessions/$sessionId/questions';

  // Media Stream & Offline Downloads
  static String sessionMediaDownload(String sessionId, String format) =>
      '$baseUrl/elearning/sessions/$sessionId/download?format=$format';
}
