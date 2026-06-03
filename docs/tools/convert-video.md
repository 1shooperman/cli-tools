---
layout: default
title: convert-video
parent: Tools
nav_order: 4
---

# convert-video

Converts a video file to H.264/AAC MP4 using ffmpeg.

## Usage

```sh
convert-video [--silent] <input-file>
```

## Arguments

| Argument | Description |
|----------|-------------|
| `input-file` | Path to the source video file (any format ffmpeg can read) |
| `--silent` | Suppress ffmpeg output |

## Examples

```sh
convert-video recording.mov         # → recording.mp4
convert-video --silent clip.avi     # → clip.mp4, no output
```

Output is written to the same directory as the input with the extension replaced by `.mp4`.

## Encoding settings

| Stream | Codec | Settings |
|--------|-------|----------|
| Video | `libx264` | CRF 23, `medium` preset |
| Audio | `aac` | 128k bitrate |

CRF 23 is the ffmpeg default and gives a good quality/size balance for most content.

## Requirements

| Requirement | Install |
|-------------|---------|
| `ffmpeg` | `brew install ffmpeg` |
