# Audio Fingerprint Lab - Portfolio Summary

## One-Line Description
A MATLAB DSP project that ingests WAV files, visualizes waveforms, applies FIR filters, and matches audio clips using spectrogram-based fingerprints.

## Current Implementation
The pipeline supports:
- WAV ingestion and metadata extraction,
- stereo-to-mono waveform visualization,
- FIR low-pass and high-pass filtering,
- magnitude and phase response plotting,
- local-only filtered audio export,
- spectrogram-based fingerprint generation,
- query-to-database fingerprint matching.

## Technical Signals
- MATLAB scripting with clear stage entry points
- WAV audio I/O and sample-rate-aware processing
- FIR filter design with Hamming windows
- frequency-response and phase-response analysis
- spectrogram analysis and local peak detection
- hash-style feature construction
- Jaccard similarity scoring
- batch-compatible validation commands
- clean public/private asset separation

## Reviewer Takeaway
This repository demonstrates practical DSP implementation rather than a single throwaway script: the code is organized by pipeline stage, validates local inputs, keeps generated artifacts out of Git, and documents the signal-processing choices behind filtering and fingerprint matching.
