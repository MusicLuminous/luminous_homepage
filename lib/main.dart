import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:js' as js;

// Deferred imports for maximum code splitting
import 'services/time_service.dart' deferred as time_service;
import 'services/image_service.dart' deferred as image_service;
import 'services/weather_service.dart' deferred as weather_service;
import 'services/hitokoto_service.dart' deferred as hitokoto_service;

import 'models/user_info.dart' deferred as user_info;
import 'models/stats_data.dart' deferred as stats_data;
import 'models/link_item.dart' deferred as link_item;
import 'models/activity_item.dart' deferred as activity_item;

import 'widgets/image_card.dart' deferred as image_card;
import 'widgets/profile_card.dart' deferred as profile_card;
import 'widgets/links_card.dart' deferred as links_card;
import 'widgets/stats_card.dart' deferred as stats_card;
import 'widgets/activity_card.dart' deferred as activity_card;
import 'widgets/guestbook_card.dart' deferred as guestbook_card;
import 'widgets/sakana_widget.dart' deferred as sakana_widget;
import 'widgets/footer.dart' deferred as footer;
import 'widgets/hero_section.dart' deferred as hero_section;
import 'widgets/top_info_bar.dart' deferred as top_info_bar;
import 'widgets/dots_background.dart' deferred as dots_background;

void main() {
  runApp(const LuminousHomepage());
}

class LuminousHomepage extends StatelessWidget {
  const LuminousHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminous Homepage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF02539A),
          brightness: Brightness.light,
        ),
        fontFamily: 'MiSansVF',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Services
  dynamic _timeService;
  dynamic _imageService;
  dynamic _weatherService;
  dynamic _hitokotoService;
  
  // Data
  dynamic _userInfo;
  dynamic _stats;
  List<dynamic> _links = [];
  List<dynamic> _activities = [];
  
  // State
  String _weatherInfo = '加载中...';
  String _weatherIcon = '☀';
  String _hitokoto = '加载中...';
  String _imageUrl = '';
  String _avatarUrl = '';
  
  // Loaded libraries
  bool _servicesLoaded = false;
  bool _modelsLoaded = false;
  bool _widgetsLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Phase 1: Load essential services
    await _loadServices();
    
    // Phase 2: Load models and initialize data
    await _loadModels();
    _initializeData();
    
    // Phase 3: Start services
    _startServices();
    
    // Phase 4: Load critical widgets for initial render
    await _loadCriticalWidgets();
    
    // Phase 5: Load remaining widgets in background
    _loadBackgroundWidgets();
  }

  Future<void> _loadServices() async {
    await Future.wait([
      time_service.loadLibrary(),
      image_service.loadLibrary(),
      weather_service.loadLibrary(),
      hitokoto_service.loadLibrary(),
    ]);
    
    _timeService = time_service.TimeService();
    _imageService = image_service.ImageService();
    _weatherService = weather_service.WeatherService();
    _hitokotoService = hitokoto_service.HitokotoService();
    
    setState(() => _servicesLoaded = true);
  }

  Future<void> _loadModels() async {
    await Future.wait([
      user_info.loadLibrary(),
      stats_data.loadLibrary(),
      link_item.loadLibrary(),
      activity_item.loadLibrary(),
    ]);
    
    setState(() => _modelsLoaded = true);
  }

  void _initializeData() {
    _userInfo = user_info.UserInfo.defaultData();
    _stats = stats_data.StatsData.defaultData();
    _links.addAll(link_item.LinkItem.defaultLinks);
    _activities.addAll(activity_item.ActivityItem.defaultActivities);
  }

  void _startServices() {
    _timeService.addListener((time) {
      if (mounted) setState(() {});
    });
    _timeService.start();
    
    _imageService.addListener((url) {
      if (mounted) setState(() => _imageUrl = url);
    });
    _imageService.loadImage();
    
    _weatherService.addListener((weather, icon, temp) {
      if (mounted) {
        setState(() {
          _weatherInfo = temp.isNotEmpty ? '$weather $temp' : weather;
          _weatherIcon = icon;
        });
      }
    });
    _weatherService.loadWeather();
    
    _hitokotoService.addListener((hitokoto) {
      if (mounted) setState(() => _hitokoto = hitokoto);
    });
    _hitokotoService.loadHitokoto();
  }

  Future<void> _loadCriticalWidgets() async {
    await Future.wait([
      image_card.loadLibrary(),
      profile_card.loadLibrary(),
      links_card.loadLibrary(),
      stats_card.loadLibrary(),
      top_info_bar.loadLibrary(),
      hero_section.loadLibrary(),
    ]);
    
    setState(() => _widgetsLoaded = true);
  }

  void _loadBackgroundWidgets() {
    Future.wait([
      activity_card.loadLibrary(),
      guestbook_card.loadLibrary(),
      sakana_widget.loadLibrary(),
      footer.loadLibrary(),
      dots_background.loadLibrary(),
    ]);
  }
  
  @override
  void dispose() {
    if (_servicesLoaded) {
      _timeService.dispose();
      _imageService.dispose();
      _weatherService.dispose();
      _hitokotoService.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_servicesLoaded || !_modelsLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFFEEF2F6),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Mark app as loaded to remove loading screen
    js.context['document'].body?.classList.add('flutter-loaded');

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
                  child: Column(
                    children: [
                      _widgetsLoaded
                          ? top_info_bar.TopInfoBar(
                              greeting: _timeService.getGreeting(),
                              time: _timeService.formatTime(),
                              date: _timeService.formatDate(),
                              weatherText: _weatherInfo,
                              weatherIcon: _weatherIcon,
                            )
                          : const SizedBox(height: 60),
                      const SizedBox(height: 32),
                      _widgetsLoaded
                          ? hero_section.HeroSection(hitokoto: _hitokoto)
                          : const SizedBox(height: 100),
                      const SizedBox(height: 48),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 1024) {
                            return _buildDesktopLayout();
                          } else {
                            return _buildMobileLayout();
                          }
                        },
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _widgetsLoaded
              ? sakana_widget.SakanaWidgetContainer()
              : const SizedBox.shrink(),
        ],
      ),
      backgroundColor: const Color(0xFFEEF2F6),
    );
  }

  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _widgetsLoaded
                      ? image_card.ImageCard(
                          imageUrl: _imageUrl,
                          onRefresh: _imageService.loadImage,
                        )
                      : _buildPlaceholder(),
                ),
                const SizedBox(height: 24),
                _widgetsLoaded
                    ? links_card.LinksCard(links: _links.cast())
                    : const SizedBox.shrink(),
                const Spacer(),
                footer.Footer(),
              ],
            ),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 380,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _widgetsLoaded
                      ? profile_card.ProfileCard(
                          userInfo: _userInfo,
                          avatarUrl: _avatarUrl,
                        )
                      : _buildPlaceholder(),
                ),
                const SizedBox(height: 24),
                _widgetsLoaded
                    ? stats_card.StatsCard(stats: _stats)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _widgetsLoaded
                      ? activity_card.ActivityCard(activities: _activities.cast())
                      : _buildPlaceholder(),
                  const SizedBox(height: 40),
                  guestbook_card.GuestbookCard(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _widgetsLoaded
            ? image_card.ImageCard(
                imageUrl: _imageUrl,
                onRefresh: _imageService.loadImage,
              )
            : _buildPlaceholder(),
        const SizedBox(height: 24),
        _widgetsLoaded
            ? profile_card.ProfileCard(userInfo: _userInfo, avatarUrl: _avatarUrl)
            : _buildPlaceholder(),
        const SizedBox(height: 24),
        _widgetsLoaded
            ? links_card.LinksCard(links: _links.cast())
            : const SizedBox.shrink(),
        const SizedBox(height: 24),
        _widgetsLoaded
            ? stats_card.StatsCard(stats: _stats)
            : const SizedBox.shrink(),
        const Spacer(),
        footer.Footer(),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
