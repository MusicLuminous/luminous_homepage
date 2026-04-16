import 'package:flutter/material.dart';

class LinkItem {
  final String name;
  final String url;
  final ImageProvider iconImage;

  const LinkItem({
    required this.name,
    required this.url,
    required this.iconImage,
  });

  static final List<LinkItem> defaultLinks = [
    LinkItem(name: 'B站', url: 'https://space.bilibili.com/452556592?spm_id_from=333.1007.0.0', iconImage: const AssetImage('assets/icons/bilibili_icon.png')),
    LinkItem(name: 'GitHub',url: 'https://github.com/MusicLuminous', iconImage: const AssetImage('assets/icons/github_icon.webp')),
    LinkItem(name: '网易云音乐',url: 'https://music.163.com/#/artist?id=35233383', iconImage: const AssetImage('assets/icons/netease_music.png')),
    LinkItem(name: '邮箱',url: 'mailto:musicluminous@outlook.com', iconImage: const AssetImage('assets/icons/outlook_icon.png')),
  ];
}