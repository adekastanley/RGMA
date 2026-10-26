import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/class_session.dart';
import '../../models/course.dart';
import '../../state/learning_controller.dart';
import '../../widgets/rhema_ui_widgets.dart';

class ClassroomScreen extends StatefulWidget {
  final LearningController controller;

  const ClassroomScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  int _selectedTabIndex = 0; // 0 = Sessions (12), 1 = Q&A
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final course = widget.controller.activeCourse;
        final session = widget.controller.activeSession;
        final mediaType = widget.controller.activeMediaType;
        final isAudio = mediaType == MediaType.audio;
        final activeSizeText =
            isAudio ? session.formattedAudioSize : session.formattedVideoSize;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Navigation Row (Back button, Audio/Video toggle, Download icon)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DarkCircleIconButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          // Audio / Video Switcher Pill
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MediaModeChip(
                                  label: 'Audio',
                                  icon: Icons.headphones_rounded,
                                  isSelected: isAudio,
                                  onTap: () => widget.controller
                                      .setMediaType(MediaType.audio),
                                ),
                                _MediaModeChip(
                                  label: 'Video',
                                  icon: Icons.videocam_rounded,
                                  isSelected: !isAudio,
                                  onTap: () => widget.controller
                                      .setMediaType(MediaType.video),
                                ),
                              ],
                            ),
                          ),
                          DarkCircleIconButton(
                            icon: session.downloadStatus ==
                                    DownloadStatus.downloaded
                                ? Icons.download_done_rounded
                                : Icons.download_rounded,
                            iconColor: session.downloadStatus ==
                                    DownloadStatus.downloaded
                                ? AppColors.rhemaGoldDark
                                : AppColors.rhemaNavy,
                            onTap: () {
                              widget.controller.startOrToggleDownload(session);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    session.downloadStatus ==
                                            DownloadStatus.downloaded
                                        ? 'Removed offline copy for Session ${session.sessionNumber}'
                                        : 'Downloading Session ${session.sessionNumber} ($activeSizeText) for offline play...',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // 2. Hero Media Player Card (Deep Rhema Navy + Gold Ribbon)
                      _MediaViewportCard(
                        course: course,
                        session: session,
                        controller: widget.controller,
                      ),

                      const SizedBox(height: 20),

                      // 3. Session Title & Active Topic
                      Text(
                        '(${isAudio ? "Audio" : "Video"}) Session ${session.sessionNumber} : ${course.title}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.title,
                        style: const TextStyle(
                          color: AppColors.rhemaGoldDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // 4. Instructor Row
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.rhemaNavy,
                              border: Border.all(
                                color: AppColors.rhemaGold,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              course.instructor.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.instructor.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  course.instructor.title,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (session.isAttendanceMarked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.rhemaGoldMuted,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.rhemaGold,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.rhemaGoldDark,
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Attended',
                                    style: TextStyle(
                                      color: AppColors.rhemaNavy,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 5. Quick Action Buttons from Web App:
                      // "Read Course Syllabus" & "Instructor Bio"
                      Row(
                        children: [
                          Expanded(
                            child: _OutlineActionButton(
                              label: 'Read Course Syllabus',
                              icon: Icons.description_outlined,
                              onTap: () => _showSyllabusSheet(context, course),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _OutlineActionButton(
                              label: 'Instructor Bio',
                              icon: Icons.person_outline_rounded,
                              onTap: () =>
                                  _showInstructorSheet(context, course.instructor),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 6. Class Progress Card (from Web App top-right card)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      color: AppColors.rhemaGoldDark,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Class Progress • No. of Sessions Completed',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${course.progressIntPercent}%',
                                  style: const TextStyle(
                                    color: AppColors.rhemaNavy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: course.progressPercent,
                                minHeight: 6,
                                backgroundColor: AppColors.surfaceElevated,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.rhemaGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 7. Segmented Tab Bar: Sessions [12] | Questions & Answers
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _TabPillButton(
                                title:
                                    '${isAudio ? "Audio" : "Video"} [${course.totalSessions} Sessions]',
                                isSelected: _selectedTabIndex == 0,
                                onTap: () =>
                                    setState(() => _selectedTabIndex = 0),
                              ),
                            ),
                            Expanded(
                              child: _TabPillButton(
                                title:
                                    'Q&A (${widget.controller.activeCourseQuestions.length})',
                                isSelected: _selectedTabIndex == 1,
                                onTap: () =>
                                    setState(() => _selectedTabIndex = 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 8. Tab Content Area
                      if (_selectedTabIndex == 0)
                        _SessionsListSection(
                          course: course,
                          activeSession: session,
                          isAudioMode: isAudio,
                          controller: widget.controller,
                        )
                      else
                        _QuestionsAndAnswersSection(
                          controller: widget.controller,
                          questionTextController: _questionController,
                        ),
                    ],
                  ),
                ),

                // 9. Sticky Deep Navy Bottom Action Dock (with Rhema Gold Pill Button)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rhemaNavy,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(color: AppColors.rhemaNavyBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.rhemaNavy.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        NeonPillButton(
                          label: session.isAttendanceMarked
                              ? 'Attendance Marked'
                              : 'Mark Attendance',
                          icon: Icons.check_circle_outline_rounded,
                          onTap: () async {
                            final newlyMarked = await widget.controller
                                .markAttendanceForActiveSession();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  newlyMarked
                                      ? 'Attendance recorded for Session ${session.sessionNumber}!'
                                      : 'Attendance is already marked for Session ${session.sessionNumber}.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        Text(
                          '›››',
                          style: TextStyle(
                            color: AppColors.textOnNavyMuted
                                .withValues(alpha: 0.7),
                            fontSize: 18,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                activeSizeText,
                                style: const TextStyle(
                                  color: AppColors.textOnNavy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                session.downloadStatus ==
                                        DownloadStatus.downloaded
                                    ? 'Saved Offline'
                                    : 'Session ${session.sessionNumber}/${course.totalSessions}',
                                style: const TextStyle(
                                  color: AppColors.rhemaGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSyllabusSheet(BuildContext context, Course course) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rhemaGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.code,
                      style: const TextStyle(
                        color: AppColors.rhemaNavy,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${course.title} • Course Syllabus',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                course.syllabusOverview,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Learning Objectives',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              ...course.syllabusObjectives.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.rhemaGoldDark,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.rhemaNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Done Reading',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInstructorSheet(BuildContext context, Instructor instructor) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                instructor.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                instructor.title,
                style: const TextStyle(
                  color: AppColors.rhemaGoldDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                instructor.bio,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.rhemaNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MediaViewportCard extends StatelessWidget {
  final Course course;
  final ClassSession session;
  final LearningController controller;

  const _MediaViewportCard({
    required this.course,
    required this.session,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller.isPlaying;
    final isAudio = controller.activeMediaType == MediaType.audio;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.rhemaNavy,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.rhemaNavyBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.rhemaNavy.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Top Metadata Strip ("12 Sessions   Level 1 • Abuja   4.9 Rating")
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${course.totalSessions} Sessions',
                  style: const TextStyle(
                    color: AppColors.textOnNavyMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${course.level} • Abuja',
                  style: const TextStyle(
                    color: AppColors.rhemaGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${course.rating} Rating',
                  style: const TextStyle(
                    color: AppColors.textOnNavyMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Main Media Stage with Decorative Rhema Gold Wave & Starburst Sticker
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background canvas
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isAudio
                            ? const [Color(0xFF1A3150), Color(0xFF0E1B2E)]
                            : const [Color(0xFF142742), Color(0xFF0A1422)],
                      ),
                    ),
                  ),
                ),

                // Signature Rhema Gold Curved Wave Ribbon
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GoldWaveRibbonPainter(),
                  ),
                ),

                // Top-Left Starburst Sticker Badge
                Positioned(
                  top: 14,
                  left: 18,
                  child: StarburstStickerBadge(
                    topText: 'S-${session.sessionNumber}',
                    bottomText: isAudio
                        ? session.formattedAudioSize
                        : session.formattedVideoSize,
                    size: 64,
                  ),
                ),

                // Top-Right Rhema Seal Watermark
                const Positioned(
                  top: 14,
                  right: 18,
                  child: RhemaCrestEmblem(size: 52),
                ),

                // Center Play/Pause Button & Session Banner
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: controller.togglePlayPause,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.rhemaNavyDark.withValues(alpha: 0.7),
                          border: Border.all(
                            color: AppColors.rhemaGold,
                            width: 2.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.rhemaGold.withValues(alpha: 0.25),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rhemaNavyDark.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.rhemaGold.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        'SESSION ${session.sessionNumber} • ${isPlaying ? "PLAYING" : "CLICK TO PLAY"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Interactive Playback Controls Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            color: AppColors.rhemaNavy,
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: AppColors.rhemaGold,
                    inactiveTrackColor: AppColors.rhemaNavyDark,
                    thumbColor: AppColors.rhemaGold,
                  ),
                  child: Slider(
                    value: controller.playbackPosition,
                    onChanged: controller.seekTo,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatElapsed(controller.playbackPosition),
                      style: const TextStyle(
                        color: AppColors.textOnNavyMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: controller.skipBackward,
                          icon: const Icon(
                            Icons.replay_10_rounded,
                            size: 20,
                            color: AppColors.textOnNavy,
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: controller.togglePlayPause,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            size: 28,
                            color: AppColors.rhemaGold,
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: controller.skipForward,
                          icon: const Icon(
                            Icons.forward_10_rounded,
                            size: 20,
                            color: AppColors.textOnNavy,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: controller.cyclePlaybackSpeed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.rhemaNavyElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.rhemaNavyBorder),
                        ),
                        child: Text(
                          '${controller.playbackSpeed}x',
                          style: const TextStyle(
                            color: AppColors.rhemaGold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatElapsed(double ratio) {
    const totalMinutes = 45;
    final currentSeconds = (totalMinutes * 60 * ratio).round();
    final mins = (currentSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (currentSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs / 45:00';
  }
}

class _GoldWaveRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rhemaGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(-10, size.height * 0.85);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.65,
      size.height * 0.68,
      size.width + 15,
      size.height * 0.18,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MediaModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MediaModeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rhemaNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppColors.rhemaGold : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: AppColors.rhemaNavy),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabPillButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPillButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rhemaNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SessionsListSection extends StatelessWidget {
  final Course course;
  final ClassSession activeSession;
  final bool isAudioMode;
  final LearningController controller;

  const _SessionsListSection({
    required this.course,
    required this.activeSession,
    required this.isAudioMode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: course.sessions.map((session) {
        final isCurrent = session.sessionNumber == activeSession.sessionNumber;
        final sizeText = isAudioMode
            ? session.formattedAudioSize
            : session.formattedVideoSize;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            // Matches the soft coral/blush active session row from the Rhema Web Portal screenshot!
            color: isCurrent
                ? AppColors.activeCoralSurface
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => controller.selectSession(session.sessionNumber),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.activeCoralBorder
                        : AppColors.border,
                    width: isCurrent ? 1.4 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Play / Equalizer Icon Circle (matching the coral icon in the web app)
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? Colors.white
                            : AppColors.surfaceElevated,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.activeCoralBorder
                              : AppColors.border,
                        ),
                      ),
                      child: Icon(
                        isCurrent
                            ? Icons.graphic_eq_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.activeCoral,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Session Title & Topic
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isCurrent
                                    ? 'Session ${session.sessionNumber} (Playing)'
                                    : 'Session ${session.sessionNumber}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (session.isAttendanceMarked) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.success,
                                  size: 14,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // File Size (40.7 MB, 49.5 MB, etc.)
                    Text(
                      sizeText,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Offline Download Action Button
                    _SessionDownloadButton(
                      session: session,
                      onTap: () => controller.startOrToggleDownload(session),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SessionDownloadButton extends StatelessWidget {
  final ClassSession session;
  final VoidCallback onTap;

  const _SessionDownloadButton({
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (session.downloadStatus) {
      case DownloadStatus.notDownloaded:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.download_rounded,
              color: AppColors.rhemaNavy,
              size: 17,
            ),
          ),
        );
      case DownloadStatus.downloading:
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 34,
            height: 34,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: session.downloadProgress,
                  strokeWidth: 2.5,
                  color: AppColors.rhemaNavy,
                  backgroundColor: AppColors.border,
                ),
                Text(
                  '${(session.downloadProgress * 100).round()}%',
                  style: const TextStyle(
                    color: AppColors.rhemaNavy,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      case DownloadStatus.downloaded:
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.rhemaNavy,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.offline_pin_rounded,
              color: AppColors.rhemaGold,
              size: 18,
            ),
          ),
        );
    }
  }
}

class _QuestionsAndAnswersSection extends StatelessWidget {
  final LearningController controller;
  final TextEditingController questionTextController;

  const _QuestionsAndAnswersSection({
    required this.controller,
    required this.questionTextController,
  });

  @override
  Widget build(BuildContext context) {
    final questions = controller.activeCourseQuestions;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Questions & Answers',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ask questions about this class. Only you, admin and eventually, instructor, can see your questions.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: questionTextController,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Ask a question about this class..',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.rhemaNavy),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.rhemaNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (questionTextController.text.trim().isEmpty) return;
                controller.submitQuestion(questionTextController.text);
                questionTextController.clear();
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(
                Icons.send_rounded,
                size: 16,
                color: AppColors.rhemaGold,
              ),
              label: const Text(
                'Send Question',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
          if (questions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            ...questions.map(
              (q) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${q.studentName} • Session ${q.sessionNumber}',
                          style: const TextStyle(
                            color: AppColors.rhemaNavy,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          q.createdAt,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      q.questionText,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    if (q.instructorReply != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reply • ${q.repliedBy ?? "Instructor"}',
                              style: const TextStyle(
                                color: AppColors.rhemaGoldDark,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              q.instructorReply!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
