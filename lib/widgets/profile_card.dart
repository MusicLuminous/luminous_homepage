import 'package:flutter/material.dart';
import '../models/models.dart';

class ProfileCard extends StatefulWidget {
  final UserInfo userInfo;
  final String avatarUrl;

  const ProfileCard({
    super.key,
    required this.userInfo,
    required this.avatarUrl,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: 400,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.avatarUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Image(
                          image: AssetImage('assets/number1.png'),
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.userInfo.nickname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.userInfo.signature,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              widget.userInfo.bio,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}