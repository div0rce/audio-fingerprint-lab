# Audio Fingerprint Lab
MATLAB audio-processing pipeline for WAV ingestion, waveform analysis, FIR filtering, and spectrogram-based fingerprint matching.

## Highlights
- Processes local WAV audio through a staged DSP pipeline.
- Extracts sample metadata, mono waveforms, FIR-filtered audio, filter responses, and compact audio fingerprints.
- Matches a query clip against a 9-song local database using hash-style spectrogram peak features.
- Keeps source audio, generated audio, and generated figures local-only so the public repository stays clean.

## Features
| Area | Status | Engineering Signal |
|---|---:|---|
| WAV ingestion | Implemented | Uses MATLAB audio I/O with file validation and metadata extraction |
| Waveform analysis | Implemented | Converts stereo inputs to mono and exports time-domain plots |
| FIR filtering | Implemented | Applies 64-order low-pass, 32-order low-pass, and 64-order high-pass filters at 3 kHz |
| Response analysis | Implemented | Exports magnitude and phase response plots versus rad/sample and Hz |
| Fingerprint generation | Implemented | Builds spectrogram peak-pair hashes from local WAV clips |
| Fingerprint matching | Implemented | Scores query clips against a 9-song database with Jaccard similarity |

## Pipeline
```text
WAV files
  -> ingest_audio_examples.m
  -> run_filter_pipeline.m
  -> run_fingerprint_matcher.m
```

The scripts are intentionally separate entry points so each processing stage can be run, validated, and extended independently.

## Repository Structure
```text
audio-fingerprint-lab/
|
├── data/
|   ├── examples/          local ingestion/filtering WAV inputs
|   └── recordings/        optional local recordings
|
├── src/
|   ├── ingest_audio_examples.m
|   ├── run_filter_pipeline.m
|   └── run_fingerprint_matcher.m
|
├── figures/               generated plots, ignored by Git
├── docs/
└── portfolio/
```

Additional local-only folders are created when running the full pipeline:
```text
data/processed/
data/source_audio/
data/fingerprint_db/
data/queries/
```

## Running The Pipeline
Use MATLAB from the repository root.

Ingestion and waveform export:
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "cd src; ingest_audio_examples"
```

FIR filtering and response plots:
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "assert(~isempty(which('fir1')), 'fir1 unavailable'); cd src; run_filter_pipeline"
```

Fingerprint matching:
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "assert(~isempty(which('spectrogram')), 'spectrogram unavailable'); cd src; run_fingerprint_matcher"
```

## Local Audio Layout
The ingestion and filtering scripts expect:
```text
data/examples/pirates.wav
data/examples/papas megalitriti.wav
```

The fingerprint matcher expects:
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
data/queries/query.wav
```

Local WAV files and generated artifacts are intentionally ignored by Git.

## Implementation Notes
- FIR filters are designed with `fir1` and Hamming windows.
- The 32-order low-pass filter demonstrates the wider transition band that comes from reducing filter order.
- Fingerprints are generated from local maxima in the magnitude spectrogram.
- Each fingerprint row stores `[f1, f2, deltaT]`, linking two nearby spectral peaks.
- Query matching uses Jaccard similarity over unique fingerprint hashes.

## Technical Stack
- MATLAB R2025b
- Signal Processing Toolbox
- WAV audio I/O
- FIR filter design
- Spectrogram analysis
- Local peak detection
- Hash-based similarity scoring

## Local Data Policy
This repository is designed to be public without redistributing audio assets. Source audio, processed WAV files, generated figures, and private notes remain local-only.
