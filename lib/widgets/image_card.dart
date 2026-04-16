import 'package:flutter/material.dart';

class ImageCard extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onRefresh;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.onRefresh,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isHovered = false;
  bool _isRefreshHovered = false;
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (event) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(event.position);
        final refreshRect = Rect.fromLTWH(
          renderBox.size.width - 60,
          renderBox.size.height - 60,
          44,
          44,
        );
        setState(() {
          _mousePosition = localPosition;
          _isRefreshHovered = refreshRect.contains(localPosition);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.05),
              blurRadius: _isHovered ? 30 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 400,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
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
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                // 鼠标光效 - 纯白色
                if (_isHovered && !_isRefreshHovered)
                  Positioned(
                    left: _mousePosition.dx - 100,
                    top: _mousePosition.dy - 100,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                // 刷新按钮
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onRefresh,
                      borderRadius: BorderRadius.circular(22),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _isRefreshHovered 
                              ? const Color(0xFF02539A) 
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AnimatedRotation(
                          turns: _isRefreshHovered ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.refresh,
                            size: 20,
                            color: _isRefreshHovered ? Colors.white : const Color.fromARGB(255, 85, 119, 173),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
