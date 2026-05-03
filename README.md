# Audio Fingerprint Lab
A MATLAB-based audio analysis pipeline for WAV ingestion, waveform visualization, filtering, and simple fingerprint-based matching.

## Overview
This project explores core digital signal processing techniques through audio data.

The pipeline is designed around four stages:
1. audio ingestion from WAV files,
2. waveform inspection and metadata extraction,
3. FIR-based filtering,
4. spectrogram-driven fingerprint comparison.

The current implementation focuses on the ingestion and waveform visualization stage.

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
- WAV file ingestion with `audioread`
- playback with `sound`
- metadata extraction
- stereo-to-mono conversion for analysis
- time-domain waveform plotting
- figure export

Planned:
- FIR filtering
- spectrogram analysis
- fingerprint-based matching

## Running the Ingestion Demo
Place the local example WAV files in:
```text
data/examples/
```

Expected initial files:
```text
data/examples/pirates.wav
data/examples/papas megalitriti.wav
```

From MATLAB, run:
```matlab
cd src
ingest_audio_examples
```

Generated waveform plots are exported to:
```text
figures/
```

## Audio Assets
This repository expects local WAV files for demos and tests.

The initial ingestion demo looks for:
```text
data/examples/pirates.wav
data/examples/papas megalitriti.wav
```

These files may be omitted from the public repository if they are course-provided, copyrighted, or otherwise not suitable for redistribution.

To run the project, place compatible WAV files in `data/examples/` using the expected filenames, or edit the `fileNames` list in `src/ingest_audio_examples.m`.
