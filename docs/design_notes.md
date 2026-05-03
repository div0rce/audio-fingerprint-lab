# Design Notes

## Pipeline
The project is organized as a staged audio-processing pipeline:
1. ingest WAV files,
2. inspect waveform and metadata,
3. apply FIR filters,
4. compare audio fingerprints.

## Implementation Language
MATLAB is used because it provides direct support for audio I/O, signal visualization, and DSP filter design.

## Stage 1: Ingestion
The ingestion script performs five basic operations:
1. validates that local WAV files exist,
2. loads each file using `audioread`,
3. extracts sample rate and channel metadata,
4. converts stereo signals to mono for plotting,
5. exports time-domain waveform figures.

The script uses a cell-array structure so additional files can be added with minimal changes.

## Pipeline Organization
Each stage is exposed through a separate MATLAB entry point. This keeps ingestion, filtering, and fingerprint matching independently testable as the project grows.
