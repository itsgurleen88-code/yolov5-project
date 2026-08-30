#!/usr/bin/env bash
# ============================================================
# 01_detect_static_image.sh
# Runs YOLOv5s object detection on a static test image.
# Usage:
#   ./01_detect_static_image.sh [path/to/image.jpg] [confidence]
# Defaults to the bundled bus.jpg sample and conf=0.25
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

SOURCE="${1:-data/images/bus.jpg}"
CONF="${2:-0.25}"

echo "== Running detection on: $SOURCE (conf=$CONF) =="
python3 detect.py --source "$SOURCE" --weights yolov5s.pt --conf "$CONF"

echo "== Done. Annotated output saved under yolov5/runs/detect/expN/ =="
