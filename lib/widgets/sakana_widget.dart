import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class SakanaWidgetView extends StatefulWidget {
  final String character;
  final double size;
  final bool isLeft;

  const SakanaWidgetView({
    super.key,
    this.character = 'chisato',
    this.size = 200,
    this.isLeft = false,
  });

  @override
  State<SakanaWidgetView> createState() => _SakanaWidgetViewState();
}

class _SakanaWidgetViewState extends State<SakanaWidgetView> {
  late final String _viewType = 'sakana-widget-${widget.character}-${widget.isLeft}';

  @override
  void initState() {
    super.initState();
    // 注册平台视图
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final div = html.DivElement()
          ..id = 'sakana-${widget.character}-${viewId}'
          ..style.width = '${widget.size}px'
          ..style.height = '${widget.size}px';
        
        // 创建 Sakana Widget 脚本
        final script = html.ScriptElement()
          ..type = 'text/javascript'
          ..text = '''
            (function() {
              // 等待 SakanaWidget 库加载
              function initSakana() {
                if (typeof SakanaWidget !== 'undefined') {
                  new SakanaWidget({
                    character: '${widget.character}',
                    size: ${widget.size.toInt()},
                    autoFit: false,
                    controls: false,
                  }).mount('#sakana-${widget.character}-${viewId}');
                } else {
                  // 如果库还没加载，等待 100ms 后重试
                  setTimeout(initSakana, 100);
                }
              }
              initSakana();
            })();
          ''';
        
        div.append(script);
        return div;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 移动端不显示
    if (MediaQuery.of(context).size.width <= 1024) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

// Sakana 挂件容器 - 放在页面角落
class SakanaWidgetContainer extends StatelessWidget {
  const SakanaWidgetContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // 移动端不显示
    if (MediaQuery.of(context).size.width <= 1024) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // 右侧挂件 (千束)
        Positioned(
          right: 30,
          bottom: 0,
          child: SakanaWidgetView(
            character: 'chisato',
            size: 200,
            isLeft: false,
          ),
        ),
        // 左侧挂件 (泷奈)
        Positioned(
          left: 30,
          bottom: 0,
          child: SakanaWidgetView(
            character: 'takina',
            size: 200,
            isLeft: true,
          ),
        ),
      ],
    );
  }
}
