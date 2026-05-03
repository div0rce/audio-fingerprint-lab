# Audio Fingerprint Lab
A MATLAB-based audio analysis pipeline for WAV ingestion, waveform visualization, filtering, and simple fingerprint-based matching.

## Overview
This project explores core digital signal processing techniques through audio data.

The pipeline is designed around four stages:
1. audio ingestion from WAV files,
2. waveform inspection and metadata extraction,
3. FIR-based filtering,
4. spectrogram-driven fingerprint comparison.

The current implementation focuses on the repository scaffold.

## Project Goals
- Load WAV files into MATLAB.
- Inspect sample rate, duration, channel count, and sample count.
- Convert stereo files to mono for analysis.
- Plot time-domain waveforms.
- Save generated figures for documentation.
- Extend the pipeline toward filtering and audio fingerprinting.

## Repository Structure
```text
audio-fingerprint-lab/
|
├── data/
|   ├── examples/
|   └── recordings/
|
├── src/
|   ├── ingest_audio_examples.m
|   ├── run_filter_pipeline.m
|   └── run_fingerprint_matcher.m
|
├── figures/
├── docs/
└── portfolio/
```

## Current Status
Implemented:
- repository scaffold

Planned:
- WAV ingestion and waveform visualization
- FIR filtering
- fingerprint-based audio matching
