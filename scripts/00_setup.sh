#!/usr/bin/env bash
# ============================================================
# 00_setup.sh
# Installs YOLOv5 and its dependencies.
# Run this once before anything else.
# ============================================================
set -e

echo "== Checking prerequisites =="
python3 --version || { echo "Python 3.7+ is required."; exit 1; }
git --version || { echo "git is required."; exit 1; }

echo "== Cloning YOLOv5 (Ultralytics) =="
if [ ! -d "yolov5" ]; then
    git clone https://github.com/ultralytics/yolov5.git
else
    echo "yolov5/ already exists, skipping clone."
fi

cd yolov5

echo "== Installing Python dependencies =="
pip install -r requirements.txt --break-system-packages 2>/dev/null || pip install -r requirements.txt

echo "== Downloading pretrained yolov5s weights (auto-downloads on first run too) =="
python3 -c "import torch; torch.hub.download_url_to_file('https://github.com/ultralytics/yolov5/releases/download/v7.0/yolov5s.pt', 'yolov5s.pt')" || \
    echo "Weights will auto-download the first time detect.py runs if this step failed."

echo "== Setup complete. yolov5/ is ready. =="
