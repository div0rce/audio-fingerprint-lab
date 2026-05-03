# Audio Fingerprint Lab
A MATLAB-based audio analysis pipeline for WAV ingestion, waveform visualization, filtering, and simple fingerprint-based matching.

## Overview
This project explores core digital signal processing techniques through audio data.

The pipeline is designed around four stages:
1. audio ingestion from WAV files,
2. waveform inspection and metadata extraction,
3. FIR-based filtering,
4. spectrogram-driven fingerprint comparison.

The current implementation focuses on the ingestion, waveform visualization, and FIR filtering stages.

## Features
| Area | Status | Description |
|---|---:|---|
| WAV ingestion | Implemented | Loads local WAV files using MATLAB |
| Metadata extraction | Implemented | Reports sample rate, duration, samples, and channels |
| Waveform visualization | Implemented | Plots mono time-domain waveform |
| Figure export | Implemented | Saves generated plots to `figures/` |
| FIR filtering | Implemented | Applies low-pass and high-pass FIR filters to local WAV files |
| Frequency response plots | Implemented | Exports magnitude and phase plots versus rad/sample and Hz |
| Fingerprint generation | Implemented | Extracts spectrogram peaks and generates hash-style fingerprint rows |
| Fingerprint matching | Implemented | Compares query fingerprints against a 9-song local database |

## Project Goals
- Load WAV files into MATLAB.
- Inspect sample rate, duration, channel count, and sample count.
- Convert stereo files to mono for analysis.
- Plot time-domain waveforms.
- Save generated figures for documentation.
- Extend the pipeline toward audio fingerprinting.

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
- FIR low-pass filtering
- FIR high-pass filtering
- frequency response plotting
- local-only filtered audio export
- spectrogram analysis
- fingerprint-based matching

## Technical Stack
- MATLAB
- WAV audio I/O
- Time-domain signal visualization
- FIR filtering
- Frequency response analysis
- Spectrogram analysis
- Fingerprint matching

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

## Running the FIR Filter Pipeline
The filtering pipeline expects local WAV files in:
```text
data/examples/
```

Required default files:
```text
data/examples/pirates.wav
data/examples/papas megalitriti.wav
```

Run from the repository root:
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "cd src; run_filter_pipeline"
```

The script generates local-only filtered audio files in:
```text
data/processed/
```

and local-only frequency response plots in:
```text
figures/
```

These generated files are ignored by Git.

## Running the Fingerprint Matcher
The fingerprint matcher expects a local 9-song WAV database:
```text
data/fingerprint_db/song01.wav
data/fingerprint_db/song02.wav
data/fingerprint_db/song03.wav
data/fingerprint_db/song04.wav
data/fingerprint_db/song05.wav
data/fingerprint_db/song06.wav
data/fingerprint_db/song07.wav
data/fingerprint_db/song08.wav
data/fingerprint_db/song09.wav
```

It also expects a local query file:
```text
data/queries/query.wav
```

Run:
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "cd src; run_fingerprint_matcher"
```

The script builds fingerprints for the 9-song database, fingerprints the query clip, compares the query against each database entry, and prints the closest song index.

Local WAV files are ignored by Git.

## Audio Assets
This repository expects local WAV files for demos and tests.

The initial ingestion demo looks for:
```text
data/examples/pirates.wav
data/examples/papas megalitriti.wav
```

These files may be omitted from the public repository if they are course-provided, copyrighted, or otherwise not suitable for redistribution.

To run the project, place compatible WAV files in `data/examples/` using the expected filenames, or edit the `fileNames` list in `src/ingest_audio_examples.m`.

## Pipeline Scripts
Pipeline stages are organized as explicit MATLAB entry points:
```text
src/ingest_audio_examples.m
src/run_filter_pipeline.m
src/run_fingerprint_matcher.m
```

The ingestion, FIR filtering, and fingerprint matching scripts are implemented.

## Engineering Notes
The project is intentionally organized as a staged pipeline instead of a single script. This makes each processing stage easier to test, replace, and extend.
