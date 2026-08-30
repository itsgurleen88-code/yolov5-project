#!/usr/bin/env bash
# ============================================================
# 02_detect_webcam.sh
# Real-time object detection from a live webcam feed.
# Usage:
#   ./02_detect_webcam.sh [camera_index] [confidence]
# camera_index: 0 = default webcam, 1/2/... for other cameras
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

CAM="${1:-0}"
CONF="${2:-0.25}"

echo "== Starting live detection on camera index $CAM (conf=$CONF) =="
echo "== Press 'q' in the display window to stop. =="
python3 detect.py --source "$CAM" --weights yolov5s.pt --conf "$CONF"
