import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/rhema_ui_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onGetStarted;

  /// Optional asset path (e.g. `'assets/images/onboarding_bg.jpg'`) that you can
  /// drop in later. The gradient overlay automatically blends it into the
  /// deep navy bottom section.
  final String? backgroundAssetPath;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
    this.backgroundAssetPath,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _activeSlide = 0;

  static const List<_SlideData> _slides = [
    _SlideData(
      badge: 'RHEMA BIBLE TRAINING CENTER • NIGERIA',
      titleLine1: 'Enhance Your',
      highlightedWord: 'Bible Training',
      titleLine3: 'Experience',
      subtitle:
          'Take your classes anywhere, stream audio or video lessons, and mark attendance right from your phone.',
    ),
    _SlideData(
      badge: 'OFFLINE-FIRST LEARNING',
      titleLine1: 'Download Audio',
      highlightedWord: '& Video Lessons',
      titleLine3: 'For Offline Study',
      subtitle:
          'Save your class sessions once and listen or watch anytime without worrying about mobile data or unstable network.',
    ),
    _SlideData(
      badge: 'INTERACTIVE CLASSROOM',
      titleLine1: 'Track Progress',
      highlightedWord: '& Ask Questions',
      titleLine3: 'In Real Time',
      subtitle:
          'Mark session attendance with one tap, read course syllabuses, and submit questions directly to your instructors.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_activeSlide];

    return Scaffold(
      backgroundColor: AppColors.rhemaNavyDark,
      body: Stack(
        children: [
          // 1. Top Background Image / Placeholder Canvas + Smooth Gradient Fade into Bottom
          Positioned.fill(
            child: _OnboardingHeroBackdrop(
              backgroundAssetPath: widget.backgroundAssetPath,
            ),
          ),

          // 2. Foreground Content (Top Logo + Bottom Editorial Section only)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Centered Brand Title ("RhemaGo")
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const RhemaCrestEmblem(size: 34),
                        const SizedBox(width: 10),
                        const Text(
                          'Rhema',
                          style: TextStyle(
                            color: AppColors.textOnNavy,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.6,
                          ),
                        ),
                        Text(
                          'Go',
                          style: TextStyle(
                            color: AppColors.rhemaGold,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            shadows: [
                              Shadow(
                                color: AppColors.rhemaGold.withValues(alpha: 0.35),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Open upper area reserved for background image (no floating card)
                  const Spacer(),

                  // Campus Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rhemaNavyElevated.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.rhemaNavyBorder),
                    ),
                    child: Text(
                      slide.badge,
                      style: const TextStyle(
                        color: AppColors.rhemaGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Large Editorial Title (swipeable left/right)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: (details) {
                      if ((details.primaryVelocity ?? 0) < 0) {
                        setState(() {
                          _activeSlide = (_activeSlide + 1) % _slides.length;
                        });
                      } else if ((details.primaryVelocity ?? 0) > 0) {
                        setState(() {
                          _activeSlide =
                              (_activeSlide - 1 + _slides.length) % _slides.length;
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide.titleLine1,
                          style: const TextStyle(
                            color: AppColors.textOnNavy,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.14,
                            letterSpacing: -1.0,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              height: 1.14,
                              letterSpacing: -1.0,
                            ),
                            children: [
                              TextSpan(
                                text: '${slide.highlightedWord}\n',
                                style: const TextStyle(
                                  color: AppColors.rhemaGold,
                                ),
                              ),
                              TextSpan(
                                text: slide.titleLine3,
                                style: const TextStyle(
                                  color: AppColors.textOnNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.subtitle,
                          style: const TextStyle(
                            color: AppColors.textOnNavyMuted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bottom Row: Dash Indicators on Left + "Get Started" Pill Button on Right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicator Pills
                      Row(
                        children: List.generate(_slides.length, (index) {
                          final isActive = index == _activeSlide;
                          return GestureDetector(
                            onTap: () => setState(() => _activeSlide = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 8),
                              width: isActive ? 24 : 10,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.rhemaGold
                                    : AppColors.textOnNavyMuted
                                        .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),

                      // Signature Gold + Navy Pill Button
                      NeonPillButton(
                        label: 'Get Started',
                        icon: Icons.arrow_forward_rounded,
                        onTap: widget.onGetStarted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String badge;
  final String titleLine1;
  final String highlightedWord;
  final String titleLine3;
  final String subtitle;

  const _SlideData({
    required this.badge,
    required this.titleLine1,
    required this.highlightedWord,
    required this.titleLine3,
    required this.subtitle,
  });
}

/// Top hero image container with a smooth multi-stop gradient overlay that
/// blends any background photo seamlessly into the deep navy bottom section.
class _OnboardingHeroBackdrop extends StatelessWidget {
  final String? backgroundAssetPath;

  const _OnboardingHeroBackdrop({this.backgroundAssetPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base Navy + Warm Gold atmospheric background (or custom image when provided)
        if (backgroundAssetPath != null)
          Image.asset(
            backgroundAssetPath!,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E375A),
                  Color(0xFF132238),
                  Color(0xFF0B1524),
                ],
              ),
            ),
          ),

        // Subtle warm gold ambient light at top-right (visible even before adding photo)
        Positioned(
          top: -60,
          right: -50,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.rhemaGold.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Multi-stop vertical gradient fade so the top image blends smoothly into the bottom text area
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.62, 0.82, 1.0],
              colors: [
                AppColors.rhemaNavyDark.withValues(alpha: 0.35),
                AppColors.rhemaNavyDark.withValues(alpha: 0.15),
                AppColors.rhemaNavyDark.withValues(alpha: 0.78),
                AppColors.rhemaNavyDark.withValues(alpha: 0.96),
                AppColors.rhemaNavyDark,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
