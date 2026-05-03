# Validation

Run these checks from the repository root after placing local WAV files in the expected folders.

## Ingestion
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "cd src; ingest_audio_examples"
```

Expected result:
- both example WAV files load,
- metadata prints for each file,
- waveform figures export to `figures/`.

## FIR Filtering
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "assert(~isempty(which('fir1')), 'fir1 unavailable'); cd src; run_filter_pipeline"
```

Expected result:
- both example WAV files load,
- three FIR configurations run for each file,
- filtered WAV files export to `data/processed/`,
- response plots export to `figures/`.

## Fingerprint Matching
```bash
/Applications/MATLAB_R2025b.app/bin/matlab -batch "assert(~isempty(which('spectrogram')), 'spectrogram unavailable'); cd src; run_fingerprint_matcher"
```

Expected result:
- nine local database WAV files load,
- query WAV loads,
- fingerprint hash counts print,
- scores print for all nine database entries,
- best match index prints.

## Git Hygiene
```bash
git status --short
git check-ignore -v data/examples/pirates.wav data/processed/pirates_lp64_filtered.wav data/fingerprint_db/song01.wav data/queries/query.wav private/exercise1_report_notes.md
```

Expected result:
- local audio and private notes are ignored,
- only intentional source or documentation changes appear in Git status.
