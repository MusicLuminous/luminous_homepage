import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            '© 2026 殷灵涵 Luminous',
            style: TextStyle(
              color: const Color(0xFF5577AD),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'API 感谢：pivix.mwm.moe',
            style: TextStyle(
              color: const Color(0xFF5577AD).withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}