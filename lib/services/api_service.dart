import '../core/constants/api_endpoints.dart';
import '../models/class_session.dart';
import '../models/course.dart';
import '../models/question_answer.dart';
import '../models/student_profile.dart';

/// Contract for all Rhema Go backend operations.
///
/// The UI layer depends strictly on this contract via [LearningController].
/// To switch from mock UI data to the live backend, inject [RemoteRhemaApiService]
/// instead of [MockRhemaApiService] in `main.dart`.
abstract class RhemaApiService {
  /// Fetches the authenticated student's profile, campus, and academic session.
  Future<StudentProfile> fetchStudentProfile();

  /// Fetches all enrolled courses (ongoing and completed) for the student's level.
  Future<List<Course>> fetchEnrolledCourses();

  /// Fetches sessions for a specific course.
  Future<List<ClassSession>> fetchCourseSessions(String courseId);

  /// Marks attendance for a specific class session.
  /// Returns `true` when the server records the attendance.
  Future<bool> markSessionAttendance({
    required String courseId,
    required String sessionId,
  });

  /// Fetches student Q&A threads for a specific course.
  Future<List<ClassQuestion>> fetchCourseQuestions(String courseId);

  /// Submits a private class question to the admin & course instructor.
  Future<ClassQuestion> submitClassQuestion({
    required String courseId,
    required int sessionNumber,
    required String questionText,
  });

  /// Requests the signed download URL for offline audio or video storage.
  Future<String> getSessionDownloadUrl({
    required String sessionId,
    required MediaType mediaType,
  });
}

/// Production API client stub ready for the Rhema backend engineering team.
///
/// Each method below documents the target endpoint in [ApiEndpoints], HTTP method,
/// and expected JSON payload so hooking up `http` or `dio` takes minutes.
class RemoteRhemaApiService implements RhemaApiService {
  final String? authToken;

  const RemoteRhemaApiService({this.authToken});

  @override
  Future<StudentProfile> fetchStudentProfile() async {
    // TODO(backend-team): Connect GET [ApiEndpoints.studentProfile]
    // Example:
    // final response = await http.get(
    //   Uri.parse(ApiEndpoints.studentProfile),
    //   headers: {'Authorization': 'Bearer $authToken'},
    // );
    // return StudentProfile.fromJson(jsonDecode(response.body)['data']);
    throw UnimplementedError(
      'Hook up GET ${ApiEndpoints.studentProfile} in RemoteRhemaApiService',
    );
  }

  @override
  Future<List<Course>> fetchEnrolledCourses() async {
    // TODO(backend-team): Connect GET [ApiEndpoints.allCourses]
    throw UnimplementedError(
      'Hook up GET ${ApiEndpoints.allCourses} in RemoteRhemaApiService',
    );
  }

  @override
  Future<List<ClassSession>> fetchCourseSessions(String courseId) async {
    // TODO(backend-team): Connect GET [ApiEndpoints.courseSessions(courseId)]
    throw UnimplementedError(
      'Hook up GET ${ApiEndpoints.courseSessions(courseId)} in RemoteRhemaApiService',
    );
  }

  @override
  Future<bool> markSessionAttendance({
    required String courseId,
    required String sessionId,
  }) async {
    // TODO(backend-team): Connect POST [ApiEndpoints.markAttendance(sessionId)]
    // Payload: { 'course_id': courseId, 'session_id': sessionId, 'timestamp': DateTime.now().toIso8601String() }
    throw UnimplementedError(
      'Hook up POST ${ApiEndpoints.markAttendance(sessionId)} in RemoteRhemaApiService',
    );
  }

  @override
  Future<List<ClassQuestion>> fetchCourseQuestions(String courseId) async {
    // TODO(backend-team): Connect GET [ApiEndpoints.sessionQuestions(courseId)]
    throw UnimplementedError(
      'Hook up GET ${ApiEndpoints.sessionQuestions(courseId)} in RemoteRhemaApiService',
    );
  }

  @override
  Future<ClassQuestion> submitClassQuestion({
    required String courseId,
    required int sessionNumber,
    required String questionText,
  }) async {
    // TODO(backend-team): Connect POST [ApiEndpoints.sessionQuestions(courseId)]
    // Payload: { 'course_id': courseId, 'session_number': sessionNumber, 'question_text': questionText }
    throw UnimplementedError(
      'Hook up POST ${ApiEndpoints.sessionQuestions(courseId)} in RemoteRhemaApiService',
    );
  }

  @override
  Future<String> getSessionDownloadUrl({
    required String sessionId,
    required MediaType mediaType,
  }) async {
    final format = mediaType == MediaType.audio ? 'mp3' : 'mp4';
    // TODO(backend-team): Connect GET [ApiEndpoints.sessionMediaDownload(sessionId, format)]
    throw UnimplementedError(
      'Hook up GET ${ApiEndpoints.sessionMediaDownload(sessionId, format)} in RemoteRhemaApiService',
    );
  }
}
