# Audio Fingerprint Lab - Portfolio Summary

## One-Line Description
A MATLAB audio-processing pipeline for WAV ingestion, waveform visualization, FIR filtering, and fingerprint-based matching.

## Current Implementation
The current pipeline supports:
- local WAV ingestion,
- sample-rate and duration inspection,
- stereo-to-mono waveform visualization,
- FIR low-pass filtering,
- FIR high-pass filtering,
- filter response plotting,
- local-only filtered audio export,
- spectrogram-based fingerprint generation,
- query-to-database fingerprint matching.

## Technical Signals
- MATLAB scripting
- WAV audio I/O
- FIR filter design
- Hamming-window filter construction
- frequency-response analysis
- phase-response analysis
- spectrogram analysis
- local peak detection
- hash-style feature construction
- Jaccard similarity scoring
- batch-compatible MATLAB execution

## Planned Extensions
- larger local fingerprint datasets
- noisy-query matching experiments
- compact fingerprint storage
