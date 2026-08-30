#!/usr/bin/env bash
# ============================================================
# 05_train_custom.sh
# Trains YOLOv5s on your custom dataset.
# Usage:
#   ./05_train_custom.sh [epochs] [batch_size] [img_size] [run_name]
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

EPOCHS="${1:-50}"
BATCH="${2:-16}"
IMG="${3:-640}"
NAME="${4:-my_custom_model}"
DATA_YAML="../custom_dataset/custom.yaml"

echo "== Training YOLOv5s custom model =="
echo "   epochs=$EPOCHS batch=$BATCH img=$IMG name=$NAME"
echo "   data=$DATA_YAML"

python3 train.py \
    --img "$IMG" \
    --batch "$BATCH" \
    --epochs "$EPOCHS" \
    --data "$DATA_YAML" \
    --weights yolov5s.pt \
    --name "$NAME"

echo "== Training complete. Weights saved to runs/train/$NAME/weights/best.pt =="
echo "   (If on a low-resource machine, prefer running this on Google Colab with a free GPU.)"
