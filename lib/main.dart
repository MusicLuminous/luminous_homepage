import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;
import 'models/models.dart';
import 'services/services.dart';
import 'widgets/widgets.dart';

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
  final TimeService _timeService = TimeService();
  final ImageService _imageService = ImageService();
  final WeatherService _weatherService = WeatherService();
  final HitokotoService _hitokotoService = HitokotoService();
  
  String _weatherInfo = '加载中...';
  String _weatherIcon = '☀';
  
  final UserInfo _userInfo = UserInfo.defaultData();
  final StatsData _stats = StatsData.defaultData();
  final List<LinkItem> _links = LinkItem.defaultLinks;
  final List<ActivityItem> _activities = ActivityItem.defaultActivities;
  
  String _hitokoto = '加载中...';
  String _imageUrl = '';
  String _avatarUrl = '';
  
  @override
  void initState() {
    super.initState();
    _initServices();
    _loadImage();
    _loadWeather();
    _loadHitokoto();
  }

  void _initServices() {
    _timeService.addListener((time) {
      if (mounted) {
        setState(() {});
      }
    });
    _timeService.start();
    
    _imageService.addListener((url) {
      if (mounted) {
        setState(() {
          _imageUrl = url;
        });
      }
    });
    
    _weatherService.addListener((weather, icon, temp) {
      if (mounted) {
        setState(() {
          _weatherInfo = temp.isNotEmpty ? '$weather $temp' : weather;
          _weatherIcon = icon;
        });
      }
    });
    
    _hitokotoService.addListener((hitokoto) {
      if (mounted) {
        setState(() {
          _hitokoto = hitokoto;
        });
      }
    });
    
    html.document.body?.classes.add('flutter-loaded');
  }

  @override
  void dispose() {
    _timeService.dispose();
    _imageService.dispose();
    _weatherService.dispose();
    _hitokotoService.dispose();
    super.dispose();
  }

  void _loadImage() {
    _imageService.loadImage();
  }

  Future<void> _loadWeather() async {
    await _weatherService.loadWeather();
  }

  Future<void> _loadHitokoto() async {
    await _hitokotoService.loadHitokoto();
  }


  @override
  Widget build(BuildContext context) {
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
                      TopInfoBar(
                        greeting: _timeService.getGreeting(),
                        time: _timeService.formatTime(),
                        date: _timeService.formatDate(),
                        weatherText: _weatherInfo,
                        weatherIcon: _weatherIcon,
                      ),
                      const SizedBox(height: 32),
                      HeroSection(hitokoto: _hitokoto),
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
                      const SizedBox(height: 40),
                      ActivityCard(activities: _activities),
                      const SizedBox(height: 24),
                      const GuestbookCard(),
                      const Footer(),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sakana 挂件
          const SakanaWidgetContainer(),
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
                  child: ImageCard(
                    imageUrl: _imageUrl,
                    onRefresh: _loadImage,
                  ),
                ),
                const SizedBox(height: 24),
                LinksCard(links: _links),
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
                  child: ProfileCard(
                    userInfo: _userInfo,
                    avatarUrl: _avatarUrl,
                  ),
                ),
                const SizedBox(height: 24),
                StatsCard(stats: _stats),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        ImageCard(
          imageUrl: _imageUrl,
          onRefresh: _loadImage,
        ),
        const SizedBox(height: 24),
        ProfileCard(userInfo: _userInfo, avatarUrl: _avatarUrl),
        const SizedBox(height: 24),
        LinksCard(links: _links),
        const SizedBox(height: 24),
        StatsCard(stats: _stats),
      ],
    );
  }
}
