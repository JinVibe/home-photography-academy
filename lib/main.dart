import 'package:flutter/material.dart';

void main() {
  runApp(const PhotoAcademyApp());
}

class PhotoAcademyApp extends StatelessWidget {
  const PhotoAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '방구석 사진학원',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFF8EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A65),
          primary: const Color(0xFFFF7A59),
          secondary: const Color(0xFF4DB6AC),
          tertiary: const Color(0xFFFFC857),
          surface: const Color(0xFFFFF8EF),
        ),
      ),
      home: const AcademyHomePage(),
    );
  }
}

class AcademyHomePage extends StatefulWidget {
  const AcademyHomePage({super.key});

  @override
  State<AcademyHomePage> createState() => _AcademyHomePageState();
}

class _AcademyHomePageState extends State<AcademyHomePage> {
  int selectedIndex = 0;
  int xp = 120;
  int completedMissions = 2;

  final missions = const [
    CameraMission(
      title: '수평 잡기 훈련',
      feature: '격자',
      reward: 40,
      difficulty: '쉬움',
      instruction: '책상 위 컵을 격자 가운데에 두고 기울지 않게 찍어보세요.',
      icon: Icons.grid_4x4_rounded,
      color: Color(0xFFFFC857),
    ),
    CameraMission(
      title: '초점 콕 찍기',
      feature: '터치 초점',
      reward: 50,
      difficulty: '쉬움',
      instruction: '가까운 물건 하나를 터치해서 초점을 맞춘 뒤 배경을 흐리게 만들어보세요.',
      icon: Icons.center_focus_strong_rounded,
      color: Color(0xFF4DB6AC),
    ),
    CameraMission(
      title: '밝기 마법사',
      feature: '노출 조절',
      reward: 60,
      difficulty: '보통',
      instruction: '창가 사물을 밝게 한 장, 어둡게 한 장 찍고 차이를 비교하세요.',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFFF8A65),
    ),
    CameraMission(
      title: '0.5x 탐험',
      feature: '광각',
      reward: 70,
      difficulty: '보통',
      instruction: '같은 방을 1x와 0.5x로 찍고 넓어지는 느낌을 확인하세요.',
      icon: Icons.zoom_out_map_rounded,
      color: Color(0xFF7E8CE0),
    ),
  ];

  void completeMission(CameraMission mission) {
    setState(() {
      xp += mission.reward;
      completedMissions += 1;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Text('${mission.reward}XP 획득! 사진 감각이 조금 더 좋아졌어요.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(
        xp: xp,
        completedMissions: completedMissions,
        missions: missions,
        onMissionTap: openMission,
      ),
      _MissionTab(missions: missions, onMissionTap: openMission),
      _GrowthTab(xp: xp, completedMissions: completedMissions),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            height: 68,
            selectedIndex: selectedIndex,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFFFE1D5),
            onDestinationSelected: (index) {
              setState(() => selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                selectedIcon: Icon(Icons.home_rounded),
                label: '홈',
              ),
              NavigationDestination(
                icon: Icon(Icons.flag_rounded),
                selectedIcon: Icon(Icons.flag_rounded),
                label: '미션',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_rounded),
                selectedIcon: Icon(Icons.emoji_events_rounded),
                label: '성장',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openMission(CameraMission mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MissionSheet(
          mission: mission,
          onComplete: () => completeMission(mission),
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.xp,
    required this.completedMissions,
    required this.missions,
    required this.onMissionTap,
  });

  final int xp;
  final int completedMissions;
  final List<CameraMission> missions;
  final ValueChanged<CameraMission> onMissionTap;

  @override
  Widget build(BuildContext context) {
    final level = (xp ~/ 100) + 1;
    final progress = (xp % 100) / 100;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '방구석 사진학원',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2F2A25),
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '오늘은 폰카 기능 하나를 게임처럼 익혀요.',
                    style: TextStyle(
                      color: Colors.brown.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const _MascotBadge(size: 74),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _softCardDecoration(const Color(0xFFFFE1D5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF7A59)),
                  const SizedBox(width: 8),
                  Text(
                    'Lv.$level 방구석 사진가',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 14,
                  value: progress,
                  backgroundColor: Colors.white,
                  color: const Color(0xFFFF7A59),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$xp XP · 완료 미션 $completedMissions개',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          '오늘의 추천 미션',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _FeaturedMissionCard(mission: missions.first, onTap: onMissionTap),
        const SizedBox(height: 22),
        const Text(
          '기능 퀘스트',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        ...missions.skip(1).map(
              (mission) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MissionCard(mission: mission, onTap: onMissionTap),
              ),
            ),
      ],
    );
  }
}

class _MissionTab extends StatelessWidget {
  const _MissionTab({required this.missions, required this.onMissionTap});

  final List<CameraMission> missions;
  final ValueChanged<CameraMission> onMissionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '미션 지도',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          '쉬운 촬영 과제부터 하나씩 클리어하세요.',
          style: TextStyle(color: Colors.brown.shade500, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        for (final mission in missions)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _MissionCard(mission: mission, onTap: onMissionTap),
          ),
      ],
    );
  }
}

class _GrowthTab extends StatelessWidget {
  const _GrowthTab({required this.xp, required this.completedMissions});

  final int xp;
  final int completedMissions;

  @override
  Widget build(BuildContext context) {
    final badges = [
      ('첫 촬영', Icons.camera_alt_rounded, true),
      ('격자 입문', Icons.grid_4x4_rounded, completedMissions >= 1),
      ('초점 견습', Icons.center_focus_strong_rounded, completedMissions >= 2),
      ('빛 조절자', Icons.wb_sunny_rounded, completedMissions >= 3),
      ('광각 탐험가', Icons.zoom_out_map_rounded, completedMissions >= 4),
      ('7일 출석', Icons.local_fire_department_rounded, false),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '내 성장',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: _softCardDecoration(const Color(0xFFE0F4F1)),
          child: Row(
            children: [
              const _MascotBadge(size: 86),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '코치 포토리',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '지금까지 $completedMissions개의 촬영 미션을 클리어했어요. 다음 목표는 밝기 조절입니다.',
                      style: const TextStyle(height: 1.35, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _softCardDecoration(Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'XP', value: '$xp'),
              _StatItem(label: '미션', value: '$completedMissions'),
              _StatItem(label: '배지', value: '${badges.where((b) => b.$3).length}'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          '배지',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final badge = badges[index];
            return _BadgeCard(label: badge.$1, icon: badge.$2, unlocked: badge.$3);
          },
        ),
      ],
    );
  }
}

class _FeaturedMissionCard extends StatelessWidget {
  const _FeaturedMissionCard({required this.mission, required this.onTap});

  final CameraMission mission;
  final ValueChanged<CameraMission> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => onTap(mission),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: _softCardDecoration(mission.color),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Icon(mission.icon, size: 38, color: const Color(0xFF2F2A25)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${mission.feature} · ${mission.reward}XP',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2F2A25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () => onTap(mission),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('시작'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission, required this.onTap});

  final CameraMission mission;
  final ValueChanged<CameraMission> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => onTap(mission),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _softCardDecoration(Colors.white),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: mission.color.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(mission.icon, color: const Color(0xFF2F2A25)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${mission.feature} · ${mission.difficulty} · ${mission.reward}XP',
                    style: TextStyle(color: Colors.brown.shade500, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _MissionSheet extends StatelessWidget {
  const _MissionSheet({required this.mission, required this.onComplete});

  final CameraMission mission;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.74,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF8EF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: _softCardDecoration(mission.color),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(mission.icon, size: 48, color: const Color(0xFF2F2A25)),
                    const SizedBox(height: 16),
                    Text(
                      mission.title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${mission.feature} 기능 · ${mission.reward}XP',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _GuideBlock(
                title: '미션',
                body: mission.instruction,
                icon: Icons.flag_rounded,
              ),
              const SizedBox(height: 12),
              const _GuideBlock(
                title: '촬영 팁',
                body: '카메라 앱을 열고 기능을 직접 켠 다음 촬영하세요. 제출 버튼은 MVP라서 완료 처리만 합니다.',
                icon: Icons.lightbulb_rounded,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  backgroundColor: const Color(0xFFFF7A59),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: onComplete,
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text(
                  '찍었다고 치고 제출',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GuideBlock extends StatelessWidget {
  const _GuideBlock({required this.title, required this.body, required this.icon});

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _softCardDecoration(Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFF7A59)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(height: 1.45, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MascotPainter()),
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final s = size.width;

    paint.color = const Color(0xFFFFC857);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(s * 0.08, s * 0.12, s * 0.84, s * 0.78), Radius.circular(s * 0.28)),
      paint,
    );

    paint.color = const Color(0xFF2F2A25);
    canvas.drawCircle(Offset(s * 0.36, s * 0.45), s * 0.055, paint);
    canvas.drawCircle(Offset(s * 0.64, s * 0.45), s * 0.055, paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.045
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(s * 0.5, s * 0.54), width: s * 0.28, height: s * 0.22),
      0.15,
      2.85,
      false,
      paint,
    );

    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFF7A59);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(s * 0.25, s * 0.03, s * 0.5, s * 0.22), Radius.circular(s * 0.08)),
      paint,
    );

    paint.color = Colors.white;
    canvas.drawCircle(Offset(s * 0.5, s * 0.14), s * 0.07, paint);

    paint.color = const Color(0xFF2F2A25);
    canvas.drawCircle(Offset(s * 0.5, s * 0.14), s * 0.035, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.brown.shade500, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.label, required this.icon, required this.unlocked});

  final String label;
  final IconData icon;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _softCardDecoration(unlocked ? const Color(0xFFFFE1D5) : Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: unlocked ? const Color(0xFFFF7A59) : Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: unlocked ? const Color(0xFF2F2A25) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _softCardDecoration(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(28),
    boxShadow: [
      BoxShadow(
        color: Colors.brown.withValues(alpha: 0.08),
        blurRadius: 22,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

class CameraMission {
  const CameraMission({
    required this.title,
    required this.feature,
    required this.reward,
    required this.difficulty,
    required this.instruction,
    required this.icon,
    required this.color,
  });

  final String title;
  final String feature;
  final int reward;
  final String difficulty;
  final String instruction;
  final IconData icon;
  final Color color;
}
