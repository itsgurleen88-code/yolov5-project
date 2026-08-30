#!/usr/bin/env python3
"""
04_validate_dataset.py

Sanity-checks a YOLOv5 custom dataset before training:
  - images/train, images/val, labels/train, labels/val all exist
  - every image has a matching label file (and vice versa)
  - every label line has 5 normalized values (class x y w h) in [0,1]
  - warns if class count is below the recommended 1500+ images/class

Usage:
    python3 04_validate_dataset.py --data ../custom_dataset --yaml ../custom_dataset/custom.yaml
"""
import argparse
import os
import sys
from collections import Counter

IMG_EXTS = {".jpg", ".jpeg", ".png", ".bmp"}


def load_yaml_names(yaml_path):
    names = []
    nc = None
    with open(yaml_path, "r") as f:
        for line in f:
            line = line.strip()
            if line.startswith("nc:"):
                nc = int(line.split(":", 1)[1].strip())
            if line.startswith("names:"):
                # names: ['car', 'bike', 'autorickshaw']
                raw = line.split(":", 1)[1].strip()
                raw = raw.strip("[]")
                names = [n.strip().strip("'\"") for n in raw.split(",") if n.strip()]
    return nc, names


def check_split(images_dir, labels_dir, split_name):
    if not os.path.isdir(images_dir):
        print(f"  [MISSING] {images_dir}")
        return Counter(), 0
    if not os.path.isdir(labels_dir):
        print(f"  [MISSING] {labels_dir}")
        return Counter(), 0

    images = {os.path.splitext(f)[0]: f for f in os.listdir(images_dir)
              if os.path.splitext(f)[1].lower() in IMG_EXTS}
    labels = {os.path.splitext(f)[0]: f for f in os.listdir(labels_dir)
              if f.endswith(".txt")}

    missing_labels = set(images) - set(labels)
    missing_images = set(labels) - set(images)

    if missing_labels:
        print(f"  [{split_name}] {len(missing_labels)} image(s) missing a label file, e.g. {list(missing_labels)[:3]}")
    if missing_images:
        print(f"  [{split_name}] {len(missing_images)} label(s) with no matching image, e.g. {list(missing_images)[:3]}")

    class_counts = Counter()
    bad_lines = 0
    for stem, fname in labels.items():
        path = os.path.join(labels_dir, fname)
        with open(path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                parts = line.split()
                if len(parts) != 5:
                    bad_lines += 1
                    continue
                try:
                    cls = int(parts[0])
                    x, y, w, h = map(float, parts[1:])
                except ValueError:
                    bad_lines += 1
                    continue
                if not all(0.0 <= v <= 1.0 for v in (x, y, w, h)):
                    bad_lines += 1
                    continue
                class_counts[cls] += 1

    if bad_lines:
        print(f"  [{split_name}] {bad_lines} malformed label line(s) found (expected: 'class x y w h' normalized 0-1)")

    print(f"  [{split_name}] {len(images)} images, {len(labels)} label files, {sum(class_counts.values())} annotated objects")
    return class_counts, len(images)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", default="../custom_dataset", help="Path to custom_dataset directory")
    ap.add_argument("--yaml", default="../custom_dataset/custom.yaml", help="Path to dataset YAML")
    args = ap.parse_args()

    if not os.path.isfile(args.yaml):
        print(f"YAML not found: {args.yaml}")
        sys.exit(1)

    nc, names = load_yaml_names(args.yaml)
    print(f"== custom.yaml declares nc={nc}, names={names} ==\n")

    print("Checking train split:")
    train_counts, train_n = check_split(
        os.path.join(args.data, "images/train"),
        os.path.join(args.data, "labels/train"),
        "train",
    )
    print("\nChecking val split:")
    val_counts, val_n = check_split(
        os.path.join(args.data, "images/val"),
        os.path.join(args.data, "labels/val"),
        "val",
    )

    print("\n== Per-class object counts (train) ==")
    for i, name in enumerate(names):
        count = train_counts.get(i, 0)
        flag = "  <-- consider gathering more (recommended 1500+ images/class)" if train_n and train_n < 1500 else ""
        print(f"  [{i}] {name}: {count} objects")
    if train_n and train_n < 1500:
        print(f"\nNote: only {train_n} training images total; the brief recommends 1500+ images PER CLASS for good performance.")

    unknown_classes = set(train_counts) | set(val_counts)
    for c in unknown_classes:
        if c >= len(names) or c < 0:
            print(f"\n[WARNING] Label file references class id {c}, which has no entry in `names` (0..{len(names)-1}).")

    print("\n== Validation complete ==")


if __name__ == "__main__":
    main()
