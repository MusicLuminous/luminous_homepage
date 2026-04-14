import 'package:flutter/material.dart';

class LinkItem {
  final String name;
  final IconData icon;
  final String url;
  final ImageProvider iconImage;

  const LinkItem({
    required this.name,
    required this.icon,
    required this.url,
    required this.iconImage,
  });

  static const List<LinkItem> defaultLinks = [
    LinkItem(name: 'B站', icon: Icons.video_library, url: 'https://space.bilibili.com/452556592?spm_id_from=333.1007.0.0', iconImage: AssetImage('assets/icons/bilibili_icon.png')),
    LinkItem(name: 'GitHub', icon: Icons.code, url: 'https://github.com/MusicLuminous', iconImage: AssetImage('assets/icons/github_icon.png')),
  ];
}
