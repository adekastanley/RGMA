import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/course.dart';
import '../../state/learning_controller.dart';
import '../../widgets/rhema_ui_widgets.dart';

class HomeScreen extends StatefulWidget {
  final LearningController controller;
  final ValueChanged<Course> onOpenClassroom;
  final VoidCallback onNavigateToCourses;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.onOpenClassroom,
    required this.onNavigateToCourses,
    required this.onNavigateToProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Ongoing';

  static const List<String> _categories = [
    'All',
    'Ongoing',
    'Audio Classes',
    'Video Classes',
    'Completed',
  ];

  List<Course> get _filteredCourses {
    final all = widget.controller.courses;
    switch (_selectedCategory) {
      case 'Ongoing':
        return all.where((c) => c.isOngoing).toList();
      case 'Completed':
        return all.where((c) => !c.isOngoing).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.controller.profile;
    final featuredCourse = widget.controller.activeCourse;
    final filtered = _filteredCourses;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Bar (Student Avatar on left + Search & Notification pill on right)
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNavigateToProfile,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
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
                          profile.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${profile.firstName}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${profile.level} • ${profile.campus} • ${profile.academicSession}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Dual Search & Notification Container
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      DarkCircleIconButton(
                        icon: Icons.search_rounded,
                        size: 40,
                        onTap: widget.onNavigateToCourses,
                      ),
                      const SizedBox(width: 6),
                      DarkCircleIconButton(
                        icon: Icons.notifications_none_rounded,
                        size: 40,
                        showBadge: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pneumatology 1 (Session 1) is live for the 2026–2027 Session.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 2. Hero Featured Ongoing Class Card (Deep Rhema Navy + Gold Accent)
            _HeroFeaturedClassCard(
              course: featuredCourse,
              onResumeTap: () => widget.onOpenClassroom(featuredCourse),
            ),

            const SizedBox(height: 26),

            // 3. Choose Category / Study Track Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Category',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onNavigateToCourses,
                  child: const Text(
                    'See More',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Category Pills Row (Selected pill in Rhema Gold, unselected in crisp white)
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.rhemaGold
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.rhemaGold
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.rhemaNavy
                              : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 4. Side-by-Side / Horizontal Course Cards (Deep Navy Card + Rhema Gold Highlight Card)
            SizedBox(
              height: 162,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final course = filtered[index];
                  return _CategoryCourseCard(
                    course: course,
                    cardStyleIndex: index,
                    onTap: () => widget.onOpenClassroom(course),
                  );
                },
              ),
            ),

            const SizedBox(height: 26),

            // 5. Instructors Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Instructors',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onNavigateToCourses,
                  child: const Text(
                    'See More',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.instructors.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final instructor = widget.controller.instructors[index];
                  return _InstructorMiniCard(
                    instructor: instructor,
                    onTap: () => _showInstructorBioModal(context, instructor),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstructorBioModal(BuildContext context, Instructor instructor) {
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.rhemaNavy,
                      border: Border.all(color: AppColors.rhemaGold, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      instructor.initials,
                      style: const TextStyle(
                        color: AppColors.rhemaGold,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instructor.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          instructor.title,
                          style: const TextStyle(
                            color: AppColors.rhemaGoldDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                instructor.bio,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
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
                    'Close Bio',
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

class _HeroFeaturedClassCard extends StatelessWidget {
  final Course course;
  final VoidCallback onResumeTap;

  const _HeroFeaturedClassCard({
    required this.course,
    required this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.rhemaNavy,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.rhemaNavyBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.rhemaNavy.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Metadata Strip ("12 Sessions   215 Enrolled   4.9 Rating")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatLabel(
                boldText: '${course.totalSessions}',
                regularText: ' Sessions',
              ),
              _StatLabel(
                boldText: '${course.enrolledCount}',
                regularText: ' Enrolled',
              ),
              _StatLabel(
                boldText: '${course.rating}',
                regularText: ' Rating',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Main Title + Progress Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${course.title}\nOngoing Class',
                  style: const TextStyle(
                    color: AppColors.textOnNavy,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.rhemaNavyElevated,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.rhemaGold),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${course.progressIntPercent}%',
                      style: const TextStyle(
                        color: AppColors.rhemaGold,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Completed',
                    style: TextStyle(
                      color: AppColors.textOnNavyMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Bottom Row: Instructor Info + "Take Class" Gold Pill Button
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.rhemaNavyElevated,
                  border: Border.all(color: AppColors.rhemaGold, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  course.instructor.initials,
                  style: const TextStyle(
                    color: AppColors.textOnNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  course.instructor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textOnNavyMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              NeonPillButton(
                label: 'Take Class',
                isCompact: true,
                onTap: onResumeTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String boldText;
  final String regularText;

  const _StatLabel({
    required this.boldText,
    required this.regularText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13),
        children: [
          TextSpan(
            text: boldText,
            style: const TextStyle(
              color: AppColors.textOnNavy,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: regularText,
            style: const TextStyle(
              color: AppColors.textOnNavyMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCourseCard extends StatelessWidget {
  final Course course;
  final int cardStyleIndex;
  final VoidCallback onTap;

  const _CategoryCourseCard({
    required this.course,
    required this.cardStyleIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Card 0: Deep Rhema Navy, Card 1: Solid Rhema Gold, Card 2+: Crisp White
    final isNavyCard = cardStyleIndex == 0;
    final isGoldCard = cardStyleIndex == 1;

    final Color bgColor;
    final Color primaryText;
    final Color secondaryText;
    final Color borderColor;
    final Color iconColor;

    if (isNavyCard) {
      bgColor = AppColors.rhemaNavy;
      primaryText = AppColors.textOnNavy;
      secondaryText = AppColors.textOnNavyMuted;
      borderColor = AppColors.rhemaNavyBorder;
      iconColor = AppColors.rhemaGold;
    } else if (isGoldCard) {
      bgColor = AppColors.rhemaGold;
      primaryText = AppColors.rhemaNavy;
      secondaryText = AppColors.rhemaNavy.withValues(alpha: 0.75);
      borderColor = AppColors.rhemaGold;
      iconColor = AppColors.rhemaNavy;
    } else {
      bgColor = AppColors.surface;
      primaryText = AppColors.textPrimary;
      secondaryText = AppColors.textSecondary;
      borderColor = AppColors.border;
      iconColor = AppColors.rhemaGoldDark;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 174,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Level + Session Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course.level,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${course.totalSessions} Sess.',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Course Title
            Text(
              course.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.3,
              ),
            ),

            const Spacer(),

            // Bottom Row: Audio/Video Badge + Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: 15,
                      color: iconColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Audio/Video',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  course.totalDuration,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructorMiniCard extends StatelessWidget {
  final Instructor instructor;
  final VoidCallback onTap;

  const _InstructorMiniCard({
    required this.instructor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 136,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.rhemaNavy,
                border: Border.all(color: AppColors.rhemaGold, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                instructor.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            Text(
              instructor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${instructor.coursesCount} Courses',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
