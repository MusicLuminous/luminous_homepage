import 'package:flutter/material.dart';

class HeroSection extends StatefulWidget {
  final String hitokoto;

  const HeroSection({
    super.key,
    this.hitokoto = '但尽人事，莫问前程。',
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          children: [
            Text(
              '"${widget.hitokoto}"',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
            Positioned(
              left: -30,
              top: -20,
              child: Text(
                '"',
                style: TextStyle(
                  fontSize: 64,
                  fontFamily: 'Georgia',
                  color: const Color(0xFF02539A).withOpacity(0.2),
                  height: 1,
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -40,
              child: Text(
                '"',
                style: TextStyle(
                  fontSize: 64,
                  fontFamily: 'Georgia',
                  color: const Color(0xFF02539A).withOpacity(0.2),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
