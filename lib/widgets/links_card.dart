import 'package:flutter/material.dart';
import '../models/models.dart';
import 'dart:html' as html;

class LinksCard extends StatelessWidget {
  final List<LinkItem> links;

  const LinksCard({
    super.key,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '快捷链接',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: links.map((link) => _buildLinkItem(link)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(LinkItem link) {
    return _HoverLinkItem(link: link);
  }
}

class _HoverLinkItem extends StatefulWidget {
  final LinkItem link;

  const _HoverLinkItem({required this.link});

  @override
  State<_HoverLinkItem> createState() => _HoverLinkItemState();
}

class _HoverLinkItemState extends State<_HoverLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.06),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
          border: Border.all(
            color: Colors.black.withOpacity(0.05),
          ),
        ),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () {
              html.window.open(widget.link.url, '_blank');
            },
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Image(
                  image: widget.link.iconImage,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.link,
                      size: 28,
                      color: const Color(0xFF64748B),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}