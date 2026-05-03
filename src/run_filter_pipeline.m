%% FIR Filter Pipeline
% Audio Fingerprint Lab
%
% This script applies FIR low-pass and high-pass filters to local WAV files.
%
% Implemented filter configurations:
%   1. 64-order low-pass, cutoff = 3 kHz
%   2. 32-order low-pass, cutoff = 3 kHz
%   3. 64-order high-pass, cutoff = 3 kHz
%
% For each filter, the script:
%   - designs FIR coefficients using a Hamming window,
%   - filters each local WAV file,
%   - writes filtered WAV outputs locally,
%   - exports magnitude and phase response plots.
clear;
clc;
close all;

isBatchMode = batchStartupOptionUsed;
if isBatchMode
    set(groot, 'defaultFigureVisible', 'off');
end

%% Paths
exampleDir = fullfile('..', 'data', 'examples');
outputDir = fullfile('..', 'data', 'processed');
figDir = fullfile('..', 'figures');

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

if ~exist(figDir, 'dir')
    mkdir(figDir);
end

%% Input files
fileNames = {
    'pirates.wav'
    'papas megalitriti.wav'
};

numFiles = length(fileNames);

%% Filter configurations
cutoffFreq = 3000;
filterConfigs = struct( ...
    'name', {'lp64', 'lp32', 'hp64'}, ...
    'label', {'64-order low-pass', '32-order low-pass', '64-order high-pass'}, ...
    'order', {64, 32, 64}, ...
    'type', {'low', 'low', 'high'} ...
);
numConfigs = length(filterConfigs);
firstSampleRate = [];

%% Process each audio file
for fileIdx = 1:numFiles
    fileName = fileNames{fileIdx};
    inputPath = fullfile(exampleDir, fileName);

    if ~isfile(inputPath)
        error('Missing input WAV file: %s', inputPath);
    end

    [audioIn, Fs] = audioread(inputPath);
    if isempty(firstSampleRate)
        firstSampleRate = Fs;
    end

    fprintf('\n===== Input: %s =====\n', fileName);
    fprintf('Sampling frequency: %d Hz\n', Fs);
    fprintf('Samples: %d\n', size(audioIn, 1));
    fprintf('Channels: %d\n', size(audioIn, 2));
    fprintf('Duration: %.2f seconds\n', size(audioIn, 1) / Fs);

    normalizedCutoff = cutoffFreq / (Fs / 2);
    if normalizedCutoff <= 0 || normalizedCutoff >= 1
        error('Invalid normalized cutoff %.4f for Fs = %d Hz.', normalizedCutoff, Fs);
    end

    safeInputName = erase(fileName, '.wav');
    safeInputName = strrep(safeInputName, ' ', '_');

    for cfgIdx = 1:numConfigs
        cfg = filterConfigs(cfgIdx);
        fprintf('\nApplying %s filter to %s...\n', cfg.label, fileName);

        b = fir1(cfg.order, normalizedCutoff, cfg.type, hamming(cfg.order + 1));
        audioOut = filter(b, 1, audioIn);

        outputFileName = sprintf('%s_%s_filtered.wav', safeInputName, cfg.name);
        outputPath = fullfile(outputDir, outputFileName);
        audiowrite(outputPath, audioOut, Fs);
        fprintf('Saved filtered audio: %s\n', outputPath);

        if ~isBatchMode
            fprintf('Playing original audio...\n');
            sound(audioIn, Fs);
            pause(size(audioIn, 1) / Fs + 1);

            fprintf('Playing filtered audio...\n');
            sound(audioOut, Fs);
            pause(size(audioOut, 1) / Fs + 1);
        end
    end

    if isBatchMode
        fprintf('\nSkipping playback in non-interactive MATLAB session.\n');
    end
end

%% Export frequency response plots
nFreq = 4096;
Fs = firstSampleRate;

for cfgIdx = 1:numConfigs
    cfg = filterConfigs(cfgIdx);
    normalizedCutoff = cutoffFreq / (Fs / 2);
    b = fir1(cfg.order, normalizedCutoff, cfg.type, hamming(cfg.order + 1));

    [H, omega] = freqz(b, 1, nFreq);
    freqHz = omega / (2*pi) * Fs;
    magResponse = abs(H);
    phaseResponse = unwrap(angle(H));
    safeCfgName = cfg.name;

    %% Magnitude vs rad/sample
    fig = figure;
    plot(omega, magResponse, 'LineWidth', 1.2);
    xlabel('\omega (rad/sample)');
    ylabel('|H(e^{j\omega})|');
    title(sprintf('Magnitude Response: %s', cfg.label));
    grid on;
    xlim([0 pi]);
    exportgraphics(fig, fullfile(figDir, sprintf('%s_magnitude_rad_per_sample.png', safeCfgName)));

    %% Magnitude vs Hz
    fig = figure;
    plot(freqHz, magResponse, 'LineWidth', 1.2);
    xlabel('Frequency (Hz)');
    ylabel('|H(f)|');
    title(sprintf('Magnitude Response vs Frequency: %s', cfg.label));
    grid on;
    xlim([0 Fs/2]);
    exportgraphics(fig, fullfile(figDir, sprintf('%s_magnitude_hz.png', safeCfgName)));

    %% Phase vs rad/sample
    fig = figure;
    plot(omega, phaseResponse, 'LineWidth', 1.2);
    xlabel('\omega (rad/sample)');
    ylabel('Phase (radians)');
    title(sprintf('Phase Response: %s', cfg.label));
    grid on;
    xlim([0 pi]);
    exportgraphics(fig, fullfile(figDir, sprintf('%s_phase_rad_per_sample.png', safeCfgName)));

    %% Phase vs Hz
    fig = figure;
    plot(freqHz, phaseResponse, 'LineWidth', 1.2);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    title(sprintf('Phase Response vs Frequency: %s', cfg.label));
    grid on;
    xlim([0 Fs/2]);
    exportgraphics(fig, fullfile(figDir, sprintf('%s_phase_hz.png', safeCfgName)));
end

fprintf('\nFIR filter pipeline complete.\n');
fprintf('Filtered audio saved locally in ../data/processed/\n');
fprintf('Frequency response figures saved locally in ../figures/\n');
