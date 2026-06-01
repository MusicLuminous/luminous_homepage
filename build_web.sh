#!/bin/bash

echo "=== Flutter Web 优化构建脚本 ==="

FLUTTER_CMD=$(which flutter)

if [ -z "$FLUTTER_CMD" ]; then
  echo "Error: Flutter 未安装或未添加到 PATH"
  exit 1
fi

echo "1. 执行 flutter clean..."
$FLUTTER_CMD clean

echo ""
echo "2. 获取依赖..."
$FLUTTER_CMD pub get

echo ""
echo "3. 运行构建（启用 O2 优化）..."
$FLUTTER_CMD build web \
  --release \
  --dart-define=dart2js.optimization=O2 \
  --dart-define=FLUTTER_WEB_USE_SKIA=false

echo ""
echo "4. 构建完成！"
echo "输出目录: build/web/"
echo ""
echo "=== 优化说明 ==="
echo "• O2 优化: 启用最高级别的代码优化"
echo "• HTML 渲染器: 较小的包体积，适合大多数场景"
echo "• 如需 CanvasKit 渲染器，使用: --web-renderer canvaskit"
echo ""
echo "=== 部署建议 ==="
echo "1. 确保服务器启用 gzip/brotli 压缩"
echo "2. 配置正确的 Cache-Control 头"
echo "3. 确保 HTTPS 已启用（Service Worker 需要）"