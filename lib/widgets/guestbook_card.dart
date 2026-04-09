import 'package:flutter/material.dart';
import 'dart:html' as html;

class GuestbookCard extends StatefulWidget {
  const GuestbookCard({super.key});

  @override
  State<GuestbookCard> createState() => _GuestbookCardState();
}

class _GuestbookCardState extends State<GuestbookCard> {
  final TextEditingController _messageController = TextEditingController();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _loadMessage();
    // 监听 storage 变化，实现多标签页同步
    html.window.onStorage.listen((event) {
      if (event.key == 'guestboard_text') {
        _loadMessage();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _loadMessage() {
    final storage = html.window.localStorage;
    final data = storage['guestboard_text'];
    if (data != null && data != _messageController.text) {
      setState(() {
        _messageController.text = data;
      });
    }
  }

  void _saveMessage(String text) {
    final storage = html.window.localStorage;
    storage['guestboard_text'] = text;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.05),
              blurRadius: _isHovered ? 30 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '留言板',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              onChanged: _saveMessage,
              decoration: InputDecoration(
                hintText: 'Ciallo～(∠・ω< )⌒★',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
