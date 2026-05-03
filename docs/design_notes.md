# Design Notes

## Pipeline
The project is organized as a staged audio-processing pipeline:
1. ingest WAV files,
2. inspect waveform and metadata,
3. apply FIR filters,
4. compare audio fingerprints.

## Implementation Language
MATLAB is used because it provides direct support for audio I/O, signal visualization, and DSP filter design.
