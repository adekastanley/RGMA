import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/class_session.dart';
import '../models/course.dart';
import '../models/question_answer.dart';
import '../models/student_profile.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class LearningController extends ChangeNotifier {
  final RhemaApiService _apiService;

  StudentProfile _profile = MockRhemaApiService.sampleStudent;
  List<Course> _courses = [];
  List<ClassQuestion> _questions = [];

  String _selectedCourseId = 'course_pneumatology_1';
  int _selectedSessionNumber = 1;
  MediaType _activeMediaType = MediaType.audio;
  bool _isPlaying = false;
  double _playbackPosition = 0.24; // 0.0 to 1.0
  double _playbackSpeed = 1.0;
  bool _wifiOnlyDownloads = true;

  final Map<String, Timer> _downloadTimers = {};

  LearningController({RhemaApiService? apiService})
      : _apiService = apiService ?? const MockRhemaApiService() {
    _initialize();
  }

  StudentProfile get profile => _profile;
  List<Course> get courses => _courses;
  List<Instructor> get instructors => MockRhemaApiService.sampleInstructors;
  MediaType get activeMediaType => _activeMediaType;
  bool get isPlaying => _isPlaying;
  double get playbackPosition => _playbackPosition;
  double get playbackSpeed => _playbackSpeed;
  bool get wifiOnlyDownloads => _wifiOnlyDownloads;

  Course get activeCourse {
    if (_courses.isEmpty) {
      return MockRhemaApiService.buildSampleCourses().first;
    }
    return _courses.firstWhere(
      (c) => c.id == _selectedCourseId,
      orElse: () => _courses.first,
    );
  }

  ClassSession get activeSession {
    final sessions = activeCourse.sessions;
    return sessions.firstWhere(
      (s) => s.sessionNumber == _selectedSessionNumber,
      orElse: () => sessions.first,
    );
  }

  List<ClassQuestion> get activeCourseQuestions {
    return _questions.where((q) => q.courseId == activeCourse.id).toList();
  }

  List<ClassSession> get downloadedSessions {
    final items = <ClassSession>[];
    for (final course in _courses) {
      for (final session in course.sessions) {
        if (session.downloadStatus == DownloadStatus.downloaded ||
            session.downloadStatus == DownloadStatus.downloading) {
          items.add(session);
        }
      }
    }
    return items;
  }

  double get totalDownloadedMb {
    double sum = 0;
    for (final s in downloadedSessions) {
      if (s.downloadStatus == DownloadStatus.downloaded) {
        sum += (s.downloadedMediaType == MediaType.video)
            ? s.videoSizeMb
            : s.audioSizeMb;
      }
    }
    return sum;
  }

  Future<void> _initialize() async {
    _profile = await _apiService.fetchStudentProfile();
    _courses = await _apiService.fetchEnrolledCourses();
    _questions = MockRhemaApiService.buildSampleQuestions();
    notifyListeners();
  }

  void selectCourse(String courseId, {int? sessionNumber}) {
    _selectedCourseId = courseId;
    if (sessionNumber != null) {
      _selectedSessionNumber = sessionNumber;
    } else {
      final course = activeCourse;
      // Default to first uncompleted session or session 1
      final nextIncomplete = course.sessions.where((s) => !s.isAttendanceMarked);
      _selectedSessionNumber = nextIncomplete.isNotEmpty
          ? nextIncomplete.first.sessionNumber
          : 1;
    }
    notifyListeners();
  }

  void selectSession(int sessionNumber, {bool autoPlay = true}) {
    _selectedSessionNumber = sessionNumber;
    _playbackPosition = 0.08;
    if (autoPlay) {
      _isPlaying = true;
    }
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void setMediaType(MediaType type) {
    _activeMediaType = type;
    notifyListeners();
  }

  void seekTo(double normalizedPosition) {
    _playbackPosition = normalizedPosition.clamp(0.0, 1.0);
    notifyListeners();
  }

  void skipForward() {
    _playbackPosition = (_playbackPosition + 0.08).clamp(0.0, 1.0);
    notifyListeners();
  }

  void skipBackward() {
    _playbackPosition = (_playbackPosition - 0.08).clamp(0.0, 1.0);
    notifyListeners();
  }

  void cyclePlaybackSpeed() {
    const speeds = [1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(_playbackSpeed);
    _playbackSpeed = speeds[(currentIndex + 1) % speeds.length];
    notifyListeners();
  }

  void toggleWifiOnlyDownloads(bool value) {
    _wifiOnlyDownloads = value;
    notifyListeners();
  }

  Future<bool> markAttendanceForActiveSession() async {
    final courseId = activeCourse.id;
    final session = activeSession;
    if (session.isAttendanceMarked) return false;

    await _apiService.markSessionAttendance(
      courseId: courseId,
      sessionId: session.id,
    );

    _updateSession(courseId, session.id, (current) {
      return current.copyWith(
        isAttendanceMarked: true,
        isCompleted: true,
      );
    });
    return true;
  }

  void startOrToggleDownload(
    ClassSession session, {
    MediaType? preferredType,
  }) {
    final targetType = preferredType ?? _activeMediaType;

    if (session.downloadStatus == DownloadStatus.downloaded) {
      // Remove offline download
      _downloadTimers[session.id]?.cancel();
      _downloadTimers.remove(session.id);
      _updateSession(session.courseId, session.id, (current) {
        return current.copyWith(
          downloadStatus: DownloadStatus.notDownloaded,
          downloadProgress: 0.0,
        );
      });
      return;
    }

    if (session.downloadStatus == DownloadStatus.downloading) {
      // Cancel ongoing download
      _downloadTimers[session.id]?.cancel();
      _downloadTimers.remove(session.id);
      _updateSession(session.courseId, session.id, (current) {
        return current.copyWith(
          downloadStatus: DownloadStatus.notDownloaded,
          downloadProgress: 0.0,
        );
      });
      return;
    }

    // Begin simulated download progress
    _updateSession(session.courseId, session.id, (current) {
      return current.copyWith(
        downloadStatus: DownloadStatus.downloading,
        downloadProgress: 0.12,
        downloadedMediaType: targetType,
      );
    });

    _downloadTimers[session.id]?.cancel();
    _downloadTimers[session.id] = Timer.periodic(
      const Duration(milliseconds: 220),
      (timer) {
        final foundSession = _findSession(session.courseId, session.id);
        if (foundSession == null) {
          timer.cancel();
          return;
        }
        final nextProgress = foundSession.downloadProgress + 0.22;
        if (nextProgress >= 1.0) {
          timer.cancel();
          _downloadTimers.remove(session.id);
          _updateSession(session.courseId, session.id, (current) {
            return current.copyWith(
              downloadStatus: DownloadStatus.downloaded,
              downloadProgress: 1.0,
              downloadedMediaType: targetType,
            );
          });
        } else {
          _updateSession(session.courseId, session.id, (current) {
            return current.copyWith(downloadProgress: nextProgress);
          });
        }
      },
    );
  }

  Future<void> submitQuestion(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final created = await _apiService.submitClassQuestion(
      courseId: activeCourse.id,
      sessionNumber: activeSession.sessionNumber,
      questionText: trimmed,
    );

    _questions = [created, ..._questions];
    notifyListeners();
  }

  ClassSession? _findSession(String courseId, String sessionId) {
    for (final c in _courses) {
      if (c.id == courseId) {
        for (final s in c.sessions) {
          if (s.id == sessionId) return s;
        }
      }
    }
    return null;
  }

  void _updateSession(
    String courseId,
    String sessionId,
    ClassSession Function(ClassSession current) updater,
  ) {
    _courses = _courses.map((course) {
      if (course.id != courseId) return course;
      final updatedSessions = course.sessions.map((session) {
        if (session.id != sessionId) return session;
        return updater(session);
      }).toList();
      return course.copyWith(sessions: updatedSessions);
    }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _downloadTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
