#!/usr/bin/env bash
# ============================================================
# 06_validate_model.sh
# Evaluates the trained custom model (precision, recall, mAP).
# Usage:
#   ./06_validate_model.sh [run_name]
# ============================================================
set -e
cd "$(dirname "$0")/../yolov5"

NAME="${1:-my_custom_model}"
WEIGHTS="runs/train/$NAME/weights/best.pt"
DATA_YAML="../custom_dataset/custom.yaml"

if [ ! -f "$WEIGHTS" ]; then
    echo "Weights not found at $WEIGHTS. Run 05_train_custom.sh first."
    exit 1
fi

echo "== Validating $WEIGHTS =="
python3 val.py --data "$DATA_YAML" --weights "$WEIGHTS"
