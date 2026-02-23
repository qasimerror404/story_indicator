import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:story_indicator/story_indicator.dart';

void main() => runApp(const _StoryIndicatorExampleApp());

class _Story {
  const _Story({
    required this.username,
    required this.timeAgo,
    required this.gradientColors,
    required this.headline,
    required this.caption,
    required this.ctaLabel,
    required this.avatarEmoji,
  });

  final String username;
  final String timeAgo;
  final List<Color> gradientColors;
  final String headline;
  final String caption;
  final String ctaLabel;
  final String avatarEmoji;
}

class _StoryIndicatorExampleApp extends StatelessWidget {
  const _StoryIndicatorExampleApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Indicator Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const _StoriesViewerPage(),
    );
  }
}

class _StoriesViewerPage extends StatefulWidget {
  const _StoriesViewerPage();

  @override
  State<_StoriesViewerPage> createState() => _StoriesViewerPageState();
}

class _StoriesViewerPageState extends State<_StoriesViewerPage>
    with TickerProviderStateMixin {
  static const Duration _segmentDuration = Duration(seconds: 5);

  static final List<_Story> _stories = <_Story>[
    const _Story(
      username: '@aurora',
      timeAgo: 'just now',
      gradientColors: [
        Color(0xFF1a0a2e),
        Color(0xFF16213e),
        Color(0xFF0f3460),
      ],
      headline: 'Northern Lights Tonight',
      caption:
          'Rare aurora borealis visible across the northern hemisphere',
      ctaLabel: 'Set Reminder',
      avatarEmoji: '🌌',
    ),
    const _Story(
      username: '@wavelength',
      timeAgo: '2m ago',
      gradientColors: [
        Color(0xFF0d3b3b),
        Color(0xFF0f4c4c),
        Color(0xFF1a5f5f),
      ],
      headline: 'New Drop: Vol. 12',
      caption: 'Limited vinyl pressing. Only 200 copies worldwide.',
      ctaLabel: 'Shop Now',
      avatarEmoji: '🎵',
    ),
    const _Story(
      username: '@solstice',
      timeAgo: '5m ago',
      gradientColors: [
        Color(0xFF8B4513),
        Color(0xFFCD5C5C),
        Color(0xFF8B0000),
      ],
      headline: 'Golden Hour Hike',
      caption: 'Join our sunrise trail run this Saturday at 5:30am',
      ctaLabel: 'RSVP Free',
      avatarEmoji: '🏔️',
    ),
    const _Story(
      username: '@neoncraft',
      timeAgo: '12m ago',
      gradientColors: [
        Color(0xFF0a0a1a),
        Color(0xFF1a1a3e),
        Color(0xFF4a0a6a),
      ],
      headline: 'Behind the Build',
      caption:
          'How we designed our new studio from scratch in 30 days',
      ctaLabel: 'Watch Now',
      avatarEmoji: '⚡',
    ),
  ];

  late final AnimationController _timerController;
  int _currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: _segmentDuration,
    )..addStatusListener(_onTimerStatus);
    _timerController.forward();
  }

  void _onTimerStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _timerController.removeStatusListener(_onTimerStatus);
    _advanceStory();
    _timerController.addStatusListener(_onTimerStatus);
  }

  void _advanceStory() {
    final next = _currentStoryIndex + 1;
    setState(() {
      _currentStoryIndex = next >= _stories.length ? 0 : next;
    });
    _timerController.forward(from: 0.0);
  }

  void _goToStory(int index) {
    if (index == _currentStoryIndex) return;
    setState(() => _currentStoryIndex = index.clamp(0, _stories.length - 1));
    _timerController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _timerController.removeStatusListener(_onTimerStatus);
    _timerController.dispose();
    super.dispose();
  }

  double get _progress =>
      _currentStoryIndex.toDouble() + _timerController.value;

  @override
  Widget build(BuildContext context) {
    final story = _stories[_currentStoryIndex];
    final size = MediaQuery.sizeOf(context);
    const leftTapFraction = 0.35;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // [0] Full-screen gradient background
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Container(
                key: ValueKey<int>(_currentStoryIndex),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: story.gradientColors,
                  ),
                ),
              ),
            ),
          ),
          // [1] Decorative blurred background circle
          Positioned(
            top: size.height * 0.25,
            right: -size.width * 0.3,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          // [2] SafeArea + content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedBuilder(
                    animation: _timerController,
                    builder: (BuildContext context, Widget? child) {
                      return StoryIndicator(
                        count: _stories.length,
                        progress: _progress,
                        trackColor: const Color(0x55FFFFFF),
                        fillColor: Colors.white,
                        height: 3,
                        gap: 4,
                        radius: const BorderRadius.all(Radius.circular(100)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      _FrostedAvatar(emoji: story.avatarEmoji),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              story.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              story.timeAgo,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        story.headline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          shadows: <Shadow>[
                            Shadow(
                              color: Color(0x80000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.caption,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(100),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            child: Text(
                              story.ctaLabel,
                              style: const TextStyle(
                                color: Color(0xFF1a1a1a),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // [3] Tap zones
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: size.width * leftTapFraction,
            child: GestureDetector(
              onTap: () {
                if (_currentStoryIndex > 0) {
                  _goToStory(_currentStoryIndex - 1);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: size.width * leftTapFraction,
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                if (_currentStoryIndex < _stories.length - 1) {
                  _goToStory(_currentStoryIndex + 1);
                } else {
                  _advanceStory();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedAvatar extends StatelessWidget {
  const _FrostedAvatar({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
