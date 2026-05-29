import 'package:camera/camera.dart';
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
                body: '앱 안에서 실제 카메라를 열어 줌, 초점, 노출, 플래시를 조절하며 촬영하세요.',
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
                onPressed: () async {
                  final captured = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => CameraLabPage(mission: mission),
                    ),
                  );
                  if (captured == true) {
                    onComplete();
                  }
                },
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text(
                  '인앱 카메라로 촬영',
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

class CameraLabPage extends StatefulWidget {
  const CameraLabPage({super.key, required this.mission});

  final CameraMission mission;

  @override
  State<CameraLabPage> createState() => _CameraLabPageState();
}

class _CameraLabPageState extends State<CameraLabPage> with WidgetsBindingObserver {
  final flashModes = const [
    FlashMode.off,
    FlashMode.auto,
    FlashMode.always,
    FlashMode.torch,
  ];

  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? lastShot;
  String statusMessage = '카메라를 준비하고 있어요.';
  double minZoom = 1;
  double maxZoom = 1;
  double zoom = 1;
  double minExposure = 0;
  double maxExposure = 0;
  double exposure = 0;
  FlashMode flashMode = FlashMode.off;
  FocusMode focusMode = FocusMode.auto;
  ExposureMode exposureMode = ExposureMode.auto;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final activeController = controller;
    if (activeController == null || !activeController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      activeController.dispose();
    } else if (state == AppLifecycleState.resumed && cameras.isNotEmpty) {
      _initializeCamera(activeController.description);
    }
  }

  Future<void> _loadCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        _setStatus('사용 가능한 카메라를 찾지 못했어요.');
        return;
      }
      await _initializeCamera(cameras.first);
    } on CameraException catch (error) {
      _setStatus('카메라를 열 수 없어요: ${error.description ?? error.code}');
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    setState(() {
      isBusy = true;
      statusMessage = '카메라를 여는 중이에요.';
    });

    final previous = controller;
    final next = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await previous?.dispose();
      await next.initialize();
      minZoom = await next.getMinZoomLevel();
      maxZoom = await next.getMaxZoomLevel();
      minExposure = await next.getMinExposureOffset();
      maxExposure = await next.getMaxExposureOffset();
      zoom = minZoom.clamp(minZoom, maxZoom);
      exposure = 0.clamp(minExposure, maxExposure).toDouble();
      await next.setZoomLevel(zoom);
      await next.setExposureOffset(exposure);
      await next.setFlashMode(flashMode);

      if (!mounted) return;
      setState(() {
        controller = next;
        isBusy = false;
        statusMessage = '화면을 탭하면 초점과 노출 기준점이 이동해요.';
      });
    } on CameraException catch (error) {
      await next.dispose();
      if (!mounted) return;
      setState(() {
        isBusy = false;
        statusMessage = '카메라 초기화 실패: ${error.description ?? error.code}';
      });
    }
  }

  Future<void> _switchCamera() async {
    if (cameras.length < 2 || isBusy) return;
    final active = controller?.description;
    final currentIndex = active == null ? 0 : cameras.indexOf(active);
    final nextIndex = (currentIndex + 1) % cameras.length;
    await _initializeCamera(cameras[nextIndex]);
  }

  Future<void> _setZoom(double value) async {
    final activeController = controller;
    if (activeController == null) return;
    final next = value.clamp(minZoom, maxZoom).toDouble();
    setState(() => zoom = next);
    try {
      await activeController.setZoomLevel(next);
    } on CameraException catch (error) {
      _setStatus('줌 조절 실패: ${error.description ?? error.code}');
    }
  }

  Future<void> _setExposure(double value) async {
    final activeController = controller;
    if (activeController == null) return;
    final next = value.clamp(minExposure, maxExposure).toDouble();
    setState(() => exposure = next);
    try {
      await activeController.setExposureOffset(next);
    } on CameraException catch (error) {
      _setStatus('노출 조절 실패: ${error.description ?? error.code}');
    }
  }

  Future<void> _setFlash(FlashMode mode) async {
    final activeController = controller;
    if (activeController == null) return;
    try {
      await activeController.setFlashMode(mode);
      setState(() => flashMode = mode);
    } on CameraException catch (error) {
      _setStatus('이 기기에서 해당 플래시 모드를 지원하지 않아요: ${error.description ?? error.code}');
    }
  }

  Future<void> _toggleFocusMode() async {
    final activeController = controller;
    if (activeController == null) return;
    final next = focusMode == FocusMode.auto ? FocusMode.locked : FocusMode.auto;
    try {
      await activeController.setFocusMode(next);
      setState(() => focusMode = next);
    } on CameraException catch (error) {
      _setStatus('초점 모드 변경 실패: ${error.description ?? error.code}');
    }
  }

  Future<void> _toggleExposureMode() async {
    final activeController = controller;
    if (activeController == null) return;
    final next = exposureMode == ExposureMode.auto ? ExposureMode.locked : ExposureMode.auto;
    try {
      await activeController.setExposureMode(next);
      setState(() => exposureMode = next);
    } on CameraException catch (error) {
      _setStatus('노출 모드 변경 실패: ${error.description ?? error.code}');
    }
  }

  Future<void> _focusAt(TapDownDetails details, BoxConstraints constraints) async {
    final activeController = controller;
    if (activeController == null || !activeController.value.isInitialized) return;

    final point = Offset(
      (details.localPosition.dx / constraints.maxWidth).clamp(0, 1).toDouble(),
      (details.localPosition.dy / constraints.maxHeight).clamp(0, 1).toDouble(),
    );

    try {
      await activeController.setFocusPoint(point);
      await activeController.setExposurePoint(point);
      _setStatus('초점/노출 기준점: ${(point.dx * 100).round()}%, ${(point.dy * 100).round()}%');
    } on CameraException catch (error) {
      _setStatus('터치 초점 실패: ${error.description ?? error.code}');
    }
  }

  Future<void> _takePicture() async {
    final activeController = controller;
    if (activeController == null || !activeController.value.isInitialized || isBusy) {
      return;
    }

    setState(() => isBusy = true);
    try {
      final shot = await activeController.takePicture();
      if (!mounted) return;
      setState(() {
        lastShot = shot;
        isBusy = false;
        statusMessage = '촬영 완료: ${shot.name}';
      });
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        isBusy = false;
        statusMessage = '촬영 실패: ${error.description ?? error.code}';
      });
    }
  }

  void _setStatus(String message) {
    if (!mounted) return;
    setState(() => statusMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    final activeController = controller;
    final ready = activeController != null && activeController.value.isInitialized;

    return Scaffold(
      backgroundColor: const Color(0xFF171412),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171412),
        foregroundColor: Colors.white,
        title: Text(widget.mission.title),
        actions: [
          IconButton(
            tooltip: '카메라 전환',
            onPressed: cameras.length > 1 ? _switchCamera : null,
            icon: const Icon(Icons.cameraswitch_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: ColoredBox(
                  color: Colors.black,
                  child: ready
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              onTapDown: (details) => _focusAt(details, constraints),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Center(
                                    child: CameraPreview(activeController),
                                  ),
                                  const _CameraGridOverlay(),
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                    child: _CameraStatusPill(text: statusMessage),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              statusMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          _CameraControlPanel(
            zoom: zoom,
            minZoom: minZoom,
            maxZoom: maxZoom,
            exposure: exposure,
            minExposure: minExposure,
            maxExposure: maxExposure,
            flashMode: flashMode,
            focusMode: focusMode,
            exposureMode: exposureMode,
            flashModes: flashModes,
            lastShotName: lastShot?.name,
            isBusy: isBusy,
            onZoomChanged: ready ? _setZoom : null,
            onExposureChanged: ready ? _setExposure : null,
            onFlashChanged: ready ? _setFlash : null,
            onFocusToggle: ready ? _toggleFocusMode : null,
            onExposureToggle: ready ? _toggleExposureMode : null,
            onCapture: ready ? _takePicture : null,
            onSubmit: lastShot == null ? null : () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}

class _CameraGridOverlay extends StatelessWidget {
  const _CameraGridOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _CameraGridPainter()),
    );
  }
}

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0), Offset(size.width * 2 / 3, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3), Offset(size.width, size.height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CameraStatusPill extends StatelessWidget {
  const _CameraStatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _CameraControlPanel extends StatelessWidget {
  const _CameraControlPanel({
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.exposure,
    required this.minExposure,
    required this.maxExposure,
    required this.flashMode,
    required this.focusMode,
    required this.exposureMode,
    required this.flashModes,
    required this.lastShotName,
    required this.isBusy,
    required this.onZoomChanged,
    required this.onExposureChanged,
    required this.onFlashChanged,
    required this.onFocusToggle,
    required this.onExposureToggle,
    required this.onCapture,
    required this.onSubmit,
  });

  final double zoom;
  final double minZoom;
  final double maxZoom;
  final double exposure;
  final double minExposure;
  final double maxExposure;
  final FlashMode flashMode;
  final FocusMode focusMode;
  final ExposureMode exposureMode;
  final List<FlashMode> flashModes;
  final String? lastShotName;
  final bool isBusy;
  final ValueChanged<double>? onZoomChanged;
  final ValueChanged<double>? onExposureChanged;
  final ValueChanged<FlashMode>? onFlashChanged;
  final VoidCallback? onFocusToggle;
  final VoidCallback? onExposureToggle;
  final VoidCallback? onCapture;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    '카메라 실습실',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
                _ModeChip(label: '조리개: 기기 고정', icon: Icons.blur_on_rounded),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Android 공개 카메라 API에서 지원하는 기능만 제어됩니다.',
              style: TextStyle(color: Colors.brown.shade500, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _LabeledSlider(
              label: '줌 ${zoom.toStringAsFixed(1)}x',
              value: zoom,
              min: minZoom,
              max: maxZoom,
              onChanged: onZoomChanged,
            ),
            _LabeledSlider(
              label: '노출 ${exposure.toStringAsFixed(1)}',
              value: exposure,
              min: minExposure,
              max: maxExposure,
              onChanged: onExposureChanged,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mode in flashModes)
                  ChoiceChip(
                    label: Text(_flashLabel(mode)),
                    selected: flashMode == mode,
                    onSelected: onFlashChanged == null ? null : (_) => onFlashChanged!(mode),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.center_focus_strong_rounded, size: 18),
                  label: Text(focusMode == FocusMode.auto ? '초점 자동' : '초점 잠금'),
                  onPressed: onFocusToggle,
                ),
                ActionChip(
                  avatar: const Icon(Icons.exposure_rounded, size: 18),
                  label: Text(exposureMode == ExposureMode.auto ? '노출 자동' : '노출 잠금'),
                  onPressed: onExposureToggle,
                ),
              ],
            ),
            if (lastShotName != null) ...[
              const SizedBox(height: 10),
              Text(
                '마지막 촬영: $lastShotName',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: const Color(0xFFFF7A59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: isBusy ? null : onCapture,
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(isBusy ? '처리 중' : '촬영'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: const Color(0xFF2F2A25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onSubmit,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('미션 제출'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _flashLabel(FlashMode mode) {
    return switch (mode) {
      FlashMode.off => '플래시 끔',
      FlashMode.auto => '자동',
      FlashMode.always => '켜짐',
      FlashMode.torch => '조명',
    };
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE1D5),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFFF7A59)),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null && max > min;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max <= min ? min + 1 : max,
          onChanged: enabled ? onChanged : null,
        ),
      ],
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
