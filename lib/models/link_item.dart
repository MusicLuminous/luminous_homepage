import 'package:flutter/material.dart';

class LinkItem {
  final String name;
  final IconData icon;
  final String url;

  const LinkItem({
    required this.name,
    required this.icon,
    required this.url,
  });

  static const List<LinkItem> defaultLinks = [
    LinkItem(name: 'B站', icon: Icons.play_circle_filled, url: 'https://space.bilibili.com/452556592?spm_id_from=333.1007.0.0'),
    LinkItem(name: 'GitHub', icon: Icons.code, url: 'https://github.com/MusicLuminous'),
  ];
}
