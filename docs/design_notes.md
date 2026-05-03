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

## Stage 2: FIR Filtering
The filtering stage applies finite impulse response filters to local WAV files.

Implemented filter configurations:
1. 64-order low-pass filter, cutoff frequency 3 kHz
2. 32-order low-pass filter, cutoff frequency 3 kHz
3. 64-order high-pass filter, cutoff frequency 3 kHz

The filters are designed with MATLAB's `fir1` function using a Hamming window. The normalized cutoff is computed as:
```matlab
normalizedCutoff = cutoffFreq / (Fs / 2);
```

The lower-order low-pass filter has a wider transition band than the 64-order version. The higher-order filter gives a sharper cutoff, at the cost of more taps and greater filtering delay.

For each filter, the project exports:
- magnitude response versus rad/sample,
- magnitude response versus Hz,
- phase response versus rad/sample,
- phase response versus Hz.

## Stage 3: Audio Fingerprinting
The fingerprinting stage uses spectrogram-based peak detection. Each WAV file is converted to mono and normalized before the spectrogram is computed.

Local maxima in the magnitude spectrogram are selected as prominent time-frequency peaks. The peak threshold is computed per file from the 99.5th percentile of spectrogram magnitudes, which adapts the detector to different signal levels.

Each fingerprint hash stores a relationship between two nearby peaks:
```text
[f1, f2, deltaT]
```

where `f1` is the anchor peak frequency, `f2` is the target peak frequency, and `deltaT` is the time separation between them. Peaks are sorted by time before hash construction so the paired relationships follow the clip timeline.

The matcher converts each file's hashes into a set of string keys and computes Jaccard similarity:
```text
score = shared_hashes / total_unique_hashes
```

The query is assigned to the database song with the highest score. This simple metric rewards shared spectral peak relationships while penalizing unrelated hashes.

## Pipeline Organization
Each stage is exposed through a separate MATLAB entry point. This keeps ingestion, filtering, and fingerprint matching independently testable as the project grows.

## Asset Boundary
The repository is structured so implementation and documentation can be public while audio assets and generated artifacts remain local. This keeps the Git history focused on source code, reproducible commands, and design notes rather than binary media files.
