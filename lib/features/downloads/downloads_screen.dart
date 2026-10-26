import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/class_session.dart';
import '../../state/learning_controller.dart';
import '../../widgets/rhema_ui_widgets.dart';

class DownloadsScreen extends StatefulWidget {
  final LearningController controller;
  final void Function(String courseId, int sessionNumber) onPlayDownloadedSession;

  const DownloadsScreen({
    super.key,
    required this.controller,
    required this.onPlayDownloadedSession,
  });

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  String _selectedTypeFilter = 'All'; // All, Audio, Video

  @override
  Widget build(BuildContext context) {
    final downloaded = widget.controller.downloadedSessions.where((session) {
      if (_selectedTypeFilter == 'Audio') {
        return (session.downloadedMediaType ?? MediaType.audio) ==
            MediaType.audio;
      }
      if (_selectedTypeFilter == 'Video') {
        return session.downloadedMediaType == MediaType.video;
      }
      return true;
    }).toList();

    final usedMb = widget.controller.totalDownloadedMb;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Offline Downloads',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Play your saved audio & video classes anytime without internet.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            // Storage Meter Card (Deep Rhema Navy + Gold Progress)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.rhemaNavy,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.rhemaNavyBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.rhemaGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sd_storage_rounded,
                          color: AppColors.rhemaNavy,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rhema Offline Storage',
                              style: TextStyle(
                                color: AppColors.textOnNavy,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${usedMb.toStringAsFixed(1)} MB used • ${downloaded.length} saved lessons',
                              style: const TextStyle(
                                color: AppColors.textOnNavyMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.rhemaNavyElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.rhemaGold),
                        ),
                        child: const Text(
                          'Offline Ready',
                          style: TextStyle(
                            color: AppColors.rhemaGold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (usedMb / 1024).clamp(0.05, 1.0),
                      minHeight: 7,
                      backgroundColor: AppColors.rhemaNavyDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.rhemaGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips (All, Audio, Video)
            Row(
              children: ['All', 'Audio', 'Video'].map((type) {
                final isSelected = _selectedTypeFilter == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTypeFilter = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.rhemaGold
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.rhemaGold
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.rhemaNavy
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            if (downloaded.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 42,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_download_outlined,
                      color: AppColors.rhemaNavy,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No Offline Lessons in This Filter',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Download any class audio or video session to listen offline anytime.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    NeonPillButton(
                      label: 'Download Session 1 (40.7 MB)',
                      icon: Icons.download_rounded,
                      isCompact: true,
                      onTap: () {
                        final firstSession =
                            widget.controller.activeCourse.sessions.first;
                        widget.controller.startOrToggleDownload(
                          firstSession,
                          preferredType: MediaType.audio,
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              ...downloaded.map((session) {
                final isVideo = session.downloadedMediaType == MediaType.video;
                final sizeLabel = isVideo
                    ? session.formattedVideoSize
                    : session.formattedAudioSize;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.rhemaNavy,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isVideo
                                ? Icons.videocam_rounded
                                : Icons.headphones_rounded,
                            color: AppColors.rhemaGold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.rhemaGold,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isVideo ? 'VIDEO' : 'AUDIO',
                                      style: const TextStyle(
                                        color: AppColors.rhemaNavy,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${session.courseTitle} • Session ${session.sessionNumber}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                session.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$sizeLabel • ${session.durationLabel}',
                                style: const TextStyle(
                                  color: AppColors.rhemaGoldDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Play Offline',
                          onPressed: () {
                            widget.controller.setMediaType(
                              isVideo ? MediaType.video : MediaType.audio,
                            );
                            widget.onPlayDownloadedSession(
                              session.courseId,
                              session.sessionNumber,
                            );
                          },
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.rhemaNavy,
                            size: 34,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove Download',
                          onPressed: () =>
                              widget.controller.startOrToggleDownload(session),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
