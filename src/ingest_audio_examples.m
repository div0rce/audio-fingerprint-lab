%% WAV Ingestion and Waveform Visualization
% Audio Fingerprint Lab
%
% This script loads two local WAV examples, prints metadata, plays each file
% in interactive sessions, converts stereo audio to mono for analysis, plots
% time-domain waveforms, and exports the generated figures.
clear;
clc;
close all;

isBatchMode = ~usejava('desktop');
if isBatchMode
    set(groot, 'defaultFigureVisible', 'off');
end

%% File paths
exampleDir = fullfile('..', 'data', 'examples');
fileNames = {
    'pirates.wav'
    'papas megalitriti.wav'
};

numFiles = length(fileNames);
audioData = cell(numFiles, 1);
sampleRates = zeros(numFiles, 1);
monoAudio = cell(numFiles, 1);
timeVectors = cell(numFiles, 1);

%% Load files
for k = 1:numFiles
    filePath = fullfile(exampleDir, fileNames{k});

    if ~isfile(filePath)
        error('Missing file: %s', filePath);
    end

    [audioData{k}, sampleRates(k)] = audioread(filePath);
    monoAudio{k} = mean(audioData{k}, 2);
    timeVectors{k} = (0:length(monoAudio{k})-1) / sampleRates(k);
end

%% Print metadata
for k = 1:numFiles
    fprintf('\n===== %s =====\n', fileNames{k});
    fprintf('Sampling frequency: %d Hz\n', sampleRates(k));
    fprintf('Number of samples: %d\n', length(monoAudio{k}));
    fprintf('Duration: %.2f seconds\n', length(monoAudio{k}) / sampleRates(k));
    fprintf('Number of channels: %d\n', size(audioData{k}, 2));
end

%% Playback
if isBatchMode
    fprintf('\nSkipping playback in non-interactive MATLAB session.\n');
else
    for k = 1:numFiles
        fprintf('\nPlaying %s...\n', fileNames{k});
        sound(audioData{k}, sampleRates(k));
        pause(length(audioData{k}) / sampleRates(k) + 1);
    end
end

%% Plot and export waveforms
figDir = fullfile('..', 'figures');
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

for k = 1:numFiles
    fig = figure(k);
    plot(timeVectors{k}, monoAudio{k});
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    title(['Waveform of ', fileNames{k}]);
    grid on;

    safeName = erase(fileNames{k}, '.wav');
    safeName = strrep(safeName, ' ', '_');
    exportgraphics(fig, fullfile(figDir, [safeName, '_waveform.png']));
end

fprintf('\nWAV ingestion complete. Figures saved in ../figures/\n');
