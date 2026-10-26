enum MediaType { audio, video }

enum DownloadStatus { notDownloaded, downloading, downloaded }

class ClassSession {
  final String id;
  final String courseId;
  final String courseTitle;
  final int sessionNumber;
  final String title;
  final String durationLabel;
  final double audioSizeMb;
  final double videoSizeMb;
  final String audioStreamUrl;
  final String videoStreamUrl;
  final bool isAttendanceMarked;
  final bool isCompleted;
  final DownloadStatus downloadStatus;
  final double downloadProgress;
  final MediaType? downloadedMediaType;

  const ClassSession({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.sessionNumber,
    required this.title,
    required this.durationLabel,
    required this.audioSizeMb,
    required this.videoSizeMb,
    this.audioStreamUrl = '',
    this.videoStreamUrl = '',
    this.isAttendanceMarked = false,
    this.isCompleted = false,
    this.downloadStatus = DownloadStatus.notDownloaded,
    this.downloadProgress = 0.0,
    this.downloadedMediaType,
  });

  String get formattedAudioSize =>
      audioSizeMb == audioSizeMb.roundToDouble()
          ? '${audioSizeMb.toInt()} MB'
          : '${audioSizeMb.toStringAsFixed(1)} MB';

  String get formattedVideoSize =>
      videoSizeMb == videoSizeMb.roundToDouble()
          ? '${videoSizeMb.toInt()} MB'
          : '${videoSizeMb.toStringAsFixed(1)} MB';

  ClassSession copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    int? sessionNumber,
    String? title,
    String? durationLabel,
    double? audioSizeMb,
    double? videoSizeMb,
    String? audioStreamUrl,
    String? videoStreamUrl,
    bool? isAttendanceMarked,
    bool? isCompleted,
    DownloadStatus? downloadStatus,
    double? downloadProgress,
    MediaType? downloadedMediaType,
  }) {
    return ClassSession(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      title: title ?? this.title,
      durationLabel: durationLabel ?? this.durationLabel,
      audioSizeMb: audioSizeMb ?? this.audioSizeMb,
      videoSizeMb: videoSizeMb ?? this.videoSizeMb,
      audioStreamUrl: audioStreamUrl ?? this.audioStreamUrl,
      videoStreamUrl: videoStreamUrl ?? this.videoStreamUrl,
      isAttendanceMarked: isAttendanceMarked ?? this.isAttendanceMarked,
      isCompleted: isCompleted ?? this.isCompleted,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadedMediaType: downloadedMediaType ?? this.downloadedMediaType,
    );
  }

  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      courseTitle: json['course_title'] as String? ?? '',
      sessionNumber: json['session_number'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      durationLabel: json['duration_label'] as String? ?? '45m',
      audioSizeMb: (json['audio_size_mb'] as num?)?.toDouble() ?? 45.0,
      videoSizeMb: (json['video_size_mb'] as num?)?.toDouble() ?? 160.0,
      audioStreamUrl: json['audio_stream_url'] as String? ?? '',
      videoStreamUrl: json['video_stream_url'] as String? ?? '',
      isAttendanceMarked: json['is_attendance_marked'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_title': courseTitle,
      'session_number': sessionNumber,
      'title': title,
      'duration_label': durationLabel,
      'audio_size_mb': audioSizeMb,
      'video_size_mb': videoSizeMb,
      'audio_stream_url': audioStreamUrl,
      'video_stream_url': videoStreamUrl,
      'is_attendance_marked': isAttendanceMarked,
      'is_completed': isCompleted,
    };
  }
}
