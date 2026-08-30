#!/usr/bin/env bash
# ============================================================
# 07_detect_custom.sh
# Runs detection using your custom-trained weights.
# Works with an image folder, a single image, a video file,
# or a webcam index as the source.
# Usage:
#   ./07_detect_custom.sh <source> [run_name] [confidence]
# Example:
#   ./07_detect_custom.sh path/to/test/images my_custom_model 0.25
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

if [ -z "$1" ]; then
    echo "Usage: $0 <source> [run_name] [confidence]"
    exit 1
fi

SOURCE="$1"
NAME="${2:-my_custom_model}"
CONF="${3:-0.25}"
WEIGHTS="runs/train/$NAME/weights/best.pt"

if [ ! -f "$WEIGHTS" ]; then
    echo "Weights not found at $WEIGHTS. Run 05_train_custom.sh first."
    exit 1
fi

echo "== Running detection with custom weights: $WEIGHTS =="
echo "   source=$SOURCE conf=$CONF"
python3 detect.py --weights "$WEIGHTS" --source "$SOURCE" --conf "$CONF"

echo "== Done. Output saved under yolov5/runs/detect/expN/ =="
