#!/usr/bin/env bash
# ============================================================
# 03_detect_video.sh
# Runs detection on a real-world street/driving video to
# simulate a self-driving perception pipeline.
# Get a sample clip from Pexels.com (street/traffic scene).
# Usage:
#   ./03_detect_video.sh path/to/video.mp4 [confidence]
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

if [ -z "$1" ]; then
    echo "Usage: $0 path/to/video.mp4 [confidence]"
    exit 1
fi

VIDEO="$1"
CONF="${2:-0.25}"

echo "== Running detection on video: $VIDEO (conf=$CONF) =="
python3 detect.py --source "$VIDEO" --weights yolov5s.pt --conf "$CONF"

echo "== Done. Annotated video saved under yolov5/runs/detect/expN/ =="
