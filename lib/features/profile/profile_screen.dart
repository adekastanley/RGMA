import 'package:flutter/material.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../state/learning_controller.dart';
import '../../widgets/rhema_ui_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final LearningController controller;
  final VoidCallback onReturnToOnboarding;

  const ProfileScreen({
    super.key,
    required this.controller,
    required this.onReturnToOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Student Profile',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${profile.campus} Campus • ${profile.academicSession}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            // 1. Official Student E-Learning ID Card (Deep Rhema Navy + Gold Trim)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.rhemaNavy,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.rhemaGold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rhemaNavy.withValues(alpha: 0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.rhemaGold,
                            width: 2.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          profile.initials,
                          style: const TextStyle(
                            color: AppColors.rhemaNavy,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                color: AppColors.textOnNavy,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.studentCode,
                              style: const TextStyle(
                                color: AppColors.rhemaGold,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              style: const TextStyle(
                                color: AppColors.textOnNavyMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const RhemaCrestEmblem(size: 50),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.rhemaNavyBorder),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProfileBadgeColumn(
                        label: 'LEVEL',
                        value: profile.level,
                      ),
                      _ProfileBadgeColumn(
                        label: 'CAMPUS',
                        value: profile.campus,
                      ),
                      const _ProfileBadgeColumn(
                        label: 'SESSION',
                        value: '2026–2027',
                      ),
                      _ProfileBadgeColumn(
                        label: 'ATTENDANCE',
                        value: '${profile.overallAttendancePercent.toInt()}%',
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Academic Progress Report Summary
            const Text(
              'Progress Report',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatMetricCard(
                    title: 'Courses Completed',
                    value: '${profile.completedCourses}/${profile.totalCourses}',
                    subtitle: 'Level 1 Track',
                    icon: Icons.menu_book_rounded,
                    isGold: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatMetricCard(
                    title: 'Offline Storage',
                    value:
                        '${controller.totalDownloadedMb.toStringAsFixed(1)} MB',
                    subtitle:
                        '${controller.downloadedSessions.length} Saved Sessions',
                    icon: Icons.download_done_rounded,
                    isGold: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 3. Offline & Learning Preferences
            const Text(
              'App Preferences',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeThumbColor: AppColors.rhemaNavy,
                    activeTrackColor: AppColors.rhemaGold,
                    title: const Text(
                      'Download Over Wi-Fi Only',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: const Text(
                      'Save mobile data when downloading large video sessions',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    value: controller.wifiOnlyDownloads,
                    onChanged: controller.toggleWifiOnlyDownloads,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.integration_instructions_outlined,
                      color: AppColors.rhemaNavy,
                    ),
                    title: const Text(
                      'API Integration Ready',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: const Text(
                      'Endpoints configured in lib/services/api_service.dart',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rhemaNavy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Modular',
                        style: TextStyle(
                          color: AppColors.rhemaGold,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 4. Web Portal Handoff Banner (Tuition & Payments handled on Web)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: AppColors.rhemaGoldDark,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tuition & Portal Administration',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Rhema Go is dedicated to your classroom and offline study experience. Tuition payments, orientation forms, and official transcripts are managed on the Rhema Web Portal.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          ApiEndpoints.webPortalTuitionUrl,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.rhemaNavy,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.rhemaNavy,
                          foregroundColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Redirecting to elearning.rhemangr.org in browser...',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          size: 14,
                          color: AppColors.rhemaGold,
                        ),
                        label: const Text('Web Portal'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: TextButton.icon(
                onPressed: onReturnToOnboarding,
                icon: const Icon(
                  Icons.slideshow_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                label: const Text(
                  'Preview Welcome / Onboarding Screen',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadgeColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ProfileBadgeColumn({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textOnNavyMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.rhemaGold : AppColors.textOnNavy,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StatMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool isGold;

  const _StatMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.isGold,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isGold ? AppColors.rhemaGold : AppColors.surface;
    final fg = isGold ? AppColors.rhemaNavy : AppColors.textPrimary;
    final sub = isGold
        ? AppColors.rhemaNavy.withValues(alpha: 0.75)
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isGold ? AppColors.rhemaGold : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isGold ? AppColors.rhemaNavy : AppColors.rhemaGoldDark,
            size: 22,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: fg,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: sub,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
