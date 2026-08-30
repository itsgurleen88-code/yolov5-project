# YOLOv5-Powered Self-Driving Cars: Perception Module

Object detection system built on YOLOv5 for detecting pedestrians, vehicles,
road signs, and obstacles — usable both with pretrained weights and with a
custom-trained model for domain-specific objects (e.g. autorickshaws,
construction cones, traffic lights).

## Directory layout

```
yolov5-project/
├── README.md
├── scripts/
│   ├── 00_setup.sh                 # clone YOLOv5 + install deps
│   ├── 01_detect_static_image.sh   # Problem Statement 1: static image
│   ├── 02_detect_webcam.sh         # Problem Statement 1: live webcam
│   ├── 03_detect_video.sh          # Problem Statement 1: real-world video
│   ├── 04_validate_dataset.py      # sanity-check custom dataset before training
│   ├── 05_train_custom.sh          # Problem Statement 2: train on custom data
│   ├── 06_validate_model.sh        # Problem Statement 2: evaluate trained model
│   └── 07_detect_custom.sh         # Problem Statement 2: detect with custom weights
├── custom_dataset/
│   ├── custom.yaml                 # dataset config (edit nc/names for your classes)
│   ├── images/{train,val}/         # put your training/validation images here
│   └── labels/{train,val}/         # matching YOLO-format .txt labels
└── (yolov5/ is created here by 00_setup.sh — not included, since it's cloned fresh)
```

## Problem Statement 1 — Real-Time Object Detection

```bash
chmod +x scripts/*.sh
./scripts/00_setup.sh

# Static image (uses bundled sample bus.jpg by default)
./scripts/01_detect_static_image.sh
./scripts/01_detect_static_image.sh data/images/zidane.jpg 0.4

# Live webcam
./scripts/02_detect_webcam.sh 0 0.25

# Real-world street/driving video (download a clip from Pexels.com first)
./scripts/03_detect_video.sh /path/to/traffic_video.mp4 0.25
```

All annotated outputs are saved automatically under `yolov5/runs/detect/expN/`.

## Problem Statement 2 — Custom Object Detection

1. **Collect images** — aim for 1500+ images per class.
2. **Label them** — use [LabelImg](https://github.com/heartexlab/labelImg) or
   [Roboflow](https://roboflow.com); export in YOLO format
   (`<class_id> <x_center> <y_center> <width> <height>`, all normalized 0–1).
3. **Place files** into:
   ```
   custom_dataset/images/train/   custom_dataset/labels/train/
   custom_dataset/images/val/     custom_dataset/labels/val/
   ```
4. **Edit `custom_dataset/custom.yaml`** — set `nc` and `names` to match your classes.
5. **Validate the dataset** before burning GPU time:
   ```bash
   cd scripts
   python3 04_validate_dataset.py --data ../custom_dataset --yaml ../custom_dataset/custom.yaml
   ```
6. **Train**:
   ```bash
   ./scripts/05_train_custom.sh 50 16 640 my_custom_model
   # epochs  batch  img-size  run-name
   ```
   On a low-resource machine, run this same command inside Google Colab with a
   free GPU runtime instead.
7. **Validate performance** (precision, recall, mAP):
   ```bash
   ./scripts/06_validate_model.sh my_custom_model
   ```
8. **Run detection with the custom model**:
   ```bash
   ./scripts/07_detect_custom.sh path/to/test/images my_custom_model 0.25
   # also works with a single image, a video file, or a webcam index (e.g. 0)
   ```

### Demo used in this project: Autorickshaw Detection
`custom.yaml` ships pre-configured with `names: ['car', 'bike', 'autorickshaw']`
as a working example — replace with your own classes as needed.

## Model variant reference

| Model    | Speed    | Accuracy | Typical use case                              |
|----------|----------|----------|------------------------------------------------|
| YOLOv5s  | Fastest  | Lower    | Real-time on edge devices (Raspberry Pi, mobile)|
| YOLOv5m  | Medium   | Good     | Drones, general-purpose tasks                   |
| YOLOv5l  | Slower   | Higher   | Industrial inspection, surveillance             |
| YOLOv5x  | Slowest  | Best     | Research, cloud, high-accuracy requirements     |

This project defaults to **YOLOv5s** for edge-device suitability, per the
problem statement. Swap `--weights yolov5s.pt` for `yolov5m.pt` / `yolov5l.pt` /
`yolov5x.pt` in any script to trade speed for accuracy.

## Submission
Zip the entire `yolov5-project/` directory (excluding the cloned `yolov5/`
folder and any large datasets/weights, unless specifically requested) before
submitting.
