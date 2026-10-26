import '../models/class_session.dart';
import '../models/course.dart';
import '../models/question_answer.dart';
import '../models/student_profile.dart';
import 'api_service.dart';

/// Mock implementation of [RhemaApiService] populated with authentic
/// Rhema Bible Training Center Nigeria curriculum data (matching the web portal).
class MockRhemaApiService implements RhemaApiService {
  const MockRhemaApiService();

  static const StudentProfile sampleStudent = StudentProfile(
    id: 'stu_rhema_2026_01',
    studentCode: 'RBTC/ABJ/26/0419',
    firstName: 'Stanley',
    lastName: 'Adeka',
    email: 'stanley.adeka@rhemangr.org',
    phone: '+234 803 555 0194',
    level: 'Level 1',
    campus: 'Abuja',
    academicSession: '2026–2027 Session',
    overallAttendancePercent: 86.0,
    completedCourses: 3,
    totalCourses: 8,
    completedSessions: 38,
    totalSessions: 96,
  );

  static const List<Instructor> sampleInstructors = [
    Instructor(
      id: 'inst_01',
      name: 'Rev. Tokunbo Adejuwon',
      title: 'National Director • RBTC Nigeria',
      initials: 'TA',
      coursesCount: 4,
      bio:
          'Rev. Tokunbo Adejuwon serves as the National Director of Rhema Nigeria and teaches core modules on Pneumatology, Faith Foundations, and Spirit-Led Ministry across campuses.',
    ),
    Instructor(
      id: 'inst_02',
      name: 'Pastor Chikezie Eze',
      title: 'Senior Faculty • Abuja Campus',
      initials: 'CE',
      coursesCount: 3,
      bio:
          'Pastor Chikezie Eze has over 18 years of teaching ministry at RBTC Nigeria, specializing in Systematic Theology, Bible Doctrines, and Pauline Epistles.',
    ),
    Instructor(
      id: 'inst_03',
      name: 'Rev. Grace Okafor',
      title: 'Elearning Coordinator & Faculty',
      initials: 'GO',
      coursesCount: 2,
      bio:
          'Rev. Grace Okafor leads curriculum delivery for Rhema Elearning and instructs Level 1 students in Prayer Principles and Practical Ministry.',
    ),
  ];

  static List<Course> buildSampleCourses() {
    // Exact session MB sizes from the Rhema Web Portal screenshot for Pneumatology 1
    final pneumatologyAudioSizes = <double>[
      40.7,
      49.5,
      60.3,
      53.1,
      47.8,
      47.2,
      61.7,
      55.3,
      45.0,
      40.6,
      52.4,
      48.9,
    ];

    final pneumatologyTopics = <String>[
      'The Person & Deity of the Holy Spirit',
      'The Indwelling vs. The Infilling of the Spirit',
      'Speaking with Other Tongues: Scriptural Foundations',
      'Seven Purposes of Speaking in Tongues',
      'The Revelation Gifts: Word of Wisdom & Knowledge',
      'Discerning of Spirits in Life & Ministry',
      'The Power Gifts: Special Faith, Healing & Miracles',
      'The Vocal Gifts: Prophecy, Tongues & Interpretation',
      'Developing Sensitivity to the Human Spirit',
      'How to Be Led by the Holy Spirit Daily',
      'The Anointing Within & The Anointing Upon',
      'Operating in the Gifts with Order & Decency',
    ];

    final pneumatologySessions = List<ClassSession>.generate(12, (index) {
      final num = index + 1;
      final audioMb = pneumatologyAudioSizes[index];
      // Pre-mark Sessions 2 & 3 as already downloaded so the Downloads tab looks rich out of the box
      final isPreDownloaded = num == 2 || num == 3;
      return ClassSession(
        id: 'pneu_s$num',
        courseId: 'course_pneumatology_1',
        courseTitle: 'Pneumatology 1',
        sessionNumber: num,
        title: pneumatologyTopics[index],
        durationLabel: '${42 + (index % 4) * 5}m',
        audioSizeMb: audioMb,
        videoSizeMb: double.parse((audioMb * 3.4).toStringAsFixed(1)),
        isAttendanceMarked: false,
        isCompleted: false,
        downloadStatus:
            isPreDownloaded ? DownloadStatus.downloaded : DownloadStatus.notDownloaded,
        downloadProgress: isPreDownloaded ? 1.0 : 0.0,
        downloadedMediaType: isPreDownloaded ? MediaType.audio : null,
      );
    });

    final doctrinesSessions = List<ClassSession>.generate(10, (index) {
      final num = index + 1;
      final audioMb = 38.5 + (index * 2.7);
      final isDone = num <= 4;
      final isPreDownloaded = num == 1;
      return ClassSession(
        id: 'doc_s$num',
        courseId: 'course_bible_doctrines',
        courseTitle: 'Bible Doctrines',
        sessionNumber: num,
        title: 'Foundational Doctrine Part $num',
        durationLabel: '${48 + (index % 3) * 4}m',
        audioSizeMb: double.parse(audioMb.toStringAsFixed(1)),
        videoSizeMb: double.parse((audioMb * 3.2).toStringAsFixed(1)),
        isAttendanceMarked: isDone,
        isCompleted: isDone,
        downloadStatus:
            isPreDownloaded ? DownloadStatus.downloaded : DownloadStatus.notDownloaded,
        downloadProgress: isPreDownloaded ? 1.0 : 0.0,
        downloadedMediaType: isPreDownloaded ? MediaType.video : null,
      );
    });

    final faithSessions = List<ClassSession>.generate(12, (index) {
      final num = index + 1;
      final audioMb = 44.0 + (index * 1.8);
      final isDone = num <= 9;
      return ClassSession(
        id: 'faith_s$num',
        courseId: 'course_faith_foundations',
        courseTitle: 'Faith Foundations',
        sessionNumber: num,
        title: 'What Faith Is & How Faith Works $num',
        durationLabel: '50m',
        audioSizeMb: double.parse(audioMb.toStringAsFixed(1)),
        videoSizeMb: double.parse((audioMb * 3.3).toStringAsFixed(1)),
        isAttendanceMarked: isDone,
        isCompleted: isDone,
      );
    });

    final covenantSessions = List<ClassSession>.generate(8, (index) {
      final num = index + 1;
      return ClassSession(
        id: 'cov_s$num',
        courseId: 'course_blood_covenant',
        courseTitle: 'The Blood Covenant',
        sessionNumber: num,
        title: 'Redemption & Covenant Realities $num',
        durationLabel: '45m',
        audioSizeMb: 41.2 + index * 2.0,
        videoSizeMb: 142.0 + index * 6.5,
        isAttendanceMarked: true,
        isCompleted: true,
      );
    });

    return [
      Course(
        id: 'course_pneumatology_1',
        code: 'RBT-104',
        title: 'Pneumatology 1',
        subtitle: 'The Person, Ministry & Gifts of the Holy Spirit',
        category: 'Ongoing',
        level: 'Level 1',
        totalDuration: '9h 20m',
        scheduleText: 'Mon, 26th Oct. 2026 • 08:00 AM – 11:00 AM',
        syllabusOverview:
            'An intensive biblical study on the Person and work of the Holy Spirit in the life of the believer, covering the baptism in the Holy Spirit, the nine gifts of the Spirit (1 Cor. 12), and practical sensitivity to the inward witness.',
        syllabusObjectives: const [
          'Distinguish between the new birth experience and the infilling of the Holy Spirit.',
          'Understand the scriptural purpose and value of praying in other tongues.',
          'Identify and categorize the 9 gifts of the Holy Spirit into Revelation, Power, and Vocal gifts.',
          'Cultivate daily obedience to the inward witness and voice of the Spirit.',
        ],
        instructor: sampleInstructors[0],
        sessions: pneumatologySessions,
        isOngoing: true,
        rating: 4.9,
        enrolledCount: 215,
      ),
      Course(
        id: 'course_bible_doctrines',
        code: 'RBT-101',
        title: 'Bible Doctrines',
        subtitle: 'Core Truths of the Christian Faith & Redemption',
        category: 'Ongoing',
        level: 'Level 1',
        totalDuration: '7h 45m',
        scheduleText: 'Wed, 28th Oct. 2026 • 09:00 AM – 12:00 PM',
        syllabusOverview:
            'Examines the foundational pillars of New Testament Christianity, the inspiration of Scripture, the nature of the Godhead, man’s creation and fall, and the new creation realities in Christ.',
        syllabusObjectives: const [
          'Establish sound scriptural methods for rightly dividing the Word of Truth.',
          'Examine the substitutionary sacrifice of Christ and the believer’s authority.',
          'Apply New Covenant realities in personal study and teaching.',
        ],
        instructor: sampleInstructors[1],
        sessions: doctrinesSessions,
        isOngoing: true,
        rating: 4.8,
        enrolledCount: 198,
      ),
      Course(
        id: 'course_faith_foundations',
        code: 'RBT-102',
        title: 'Faith Foundations',
        subtitle: 'Biblical Principles of Living by Faith',
        category: 'Ongoing',
        level: 'Level 1',
        totalDuration: '8h 30m',
        scheduleText: 'Fri, 30th Oct. 2026 • 08:00 AM – 11:00 AM',
        syllabusOverview:
            'Based on Hebrews 11:1 and Mark 11:23-24, this course explores the difference between hope and faith, enemies of faith, the law of confession, and corresponding actions.',
        syllabusObjectives: const [
          'Distinguish present-tense heart faith from mental assent and future hope.',
          'Understand how the spirit of faith operates through believing and speaking.',
          'Maintain unwavering faith during seasons of testing.',
        ],
        instructor: sampleInstructors[0],
        sessions: faithSessions,
        isOngoing: true,
        rating: 5.0,
        enrolledCount: 240,
      ),
      Course(
        id: 'course_blood_covenant',
        code: 'RBT-103',
        title: 'The Blood Covenant',
        subtitle: 'Old Shadows vs. New Testament Realities',
        category: 'Completed',
        level: 'Level 1',
        totalDuration: '6h 15m',
        scheduleText: 'Completed • Oct 2026',
        syllabusOverview:
            'Traces the scarlet thread of covenant from Genesis to Calvary, unveiling the legal and vital aspects of our eternal redemption through the blood of Jesus.',
        syllabusObjectives: const [
          'Contrast the Abrahamic and Mosaic covenants with the Better Covenant in Hebrews.',
          'Understand our righteousness and access to the Father through the blood.',
        ],
        instructor: sampleInstructors[2],
        sessions: covenantSessions,
        isOngoing: false,
        rating: 4.9,
        enrolledCount: 210,
      ),
    ];
  }

  static List<ClassQuestion> buildSampleQuestions() {
    return const [
      ClassQuestion(
        id: 'q_01',
        courseId: 'course_pneumatology_1',
        sessionNumber: 1,
        studentName: 'Stanley Adeka',
        questionText:
            'In Session 1, how do we practically explain the difference between the Holy Spirit dwelling with us in the Old Testament versus being in us in John 14:17?',
        createdAt: '2 hours ago',
        instructorReply:
            'Great question, Stanley! Under the Old Covenant, the Spirit came upon prophets, priests, and kings for specific service, whereas in the New Birth (John 14:17, 1 Cor 3:16), our recreated human spirit becomes His permanent dwelling place.',
        repliedBy: 'Rev. Tokunbo Adejuwon',
      ),
    ];
  }

  @override
  Future<StudentProfile> fetchStudentProfile() async {
    return sampleStudent;
  }

  @override
  Future<List<Course>> fetchEnrolledCourses() async {
    return buildSampleCourses();
  }

  @override
  Future<List<ClassSession>> fetchCourseSessions(String courseId) async {
    final courses = buildSampleCourses();
    final match = courses.where((c) => c.id == courseId);
    return match.isNotEmpty ? match.first.sessions : const [];
  }

  @override
  Future<bool> markSessionAttendance({
    required String courseId,
    required String sessionId,
  }) async {
    return true;
  }

  @override
  Future<List<ClassQuestion>> fetchCourseQuestions(String courseId) async {
    return buildSampleQuestions()
        .where((q) => q.courseId == courseId)
        .toList();
  }

  @override
  Future<ClassQuestion> submitClassQuestion({
    required String courseId,
    required int sessionNumber,
    required String questionText,
  }) async {
    return ClassQuestion(
      id: 'q_${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      sessionNumber: sessionNumber,
      studentName: sampleStudent.fullName,
      questionText: questionText,
      createdAt: 'Just now',
    );
  }

  @override
  Future<String> getSessionDownloadUrl({
    required String sessionId,
    required MediaType mediaType,
  }) async {
    return 'https://cdn.rhemangr.org/offline/$sessionId.${mediaType == MediaType.audio ? 'mp3' : 'mp4'}';
  }
}
