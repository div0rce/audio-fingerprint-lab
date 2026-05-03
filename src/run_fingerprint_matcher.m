%% Audio Fingerprint Matcher
% Audio Fingerprint Lab
%
% This script builds a small local fingerprint database from 9 WAV files
% and matches a query WAV file to the closest database entry.
%
% Fingerprints are generated from spectrogram peaks. Each hash row contains:
%   [f1, f2, deltaT]
%
% where:
%   f1     = anchor peak frequency
%   f2     = target peak frequency
%   deltaT = time difference between the two peaks
clear;
clc;
close all;

%% Paths
dbDir = fullfile('..', 'data', 'fingerprint_db');
queryDir = fullfile('..', 'data', 'queries');
dbFiles = {
    'song01.wav'
    'song02.wav'
    'song03.wav'
    'song04.wav'
    'song05.wav'
    'song06.wav'
    'song07.wav'
    'song08.wav'
    'song09.wav'
};
queryFile = 'query.wav';

%% Fingerprint parameters
params.windowSize = 4096;
params.overlap = 2048;
params.fanOut = 5;
params.peakPercentile = 99.5;
params.neighborhoodSize = 3;
numSongs = length(dbFiles);

%% Validate database files
for k = 1:numSongs
    filePath = fullfile(dbDir, dbFiles{k});
    if ~isfile(filePath)
        error('Missing database WAV file: %s', filePath);
    end
end

queryPath = fullfile(queryDir, queryFile);
if ~isfile(queryPath)
    error('Missing query WAV file: %s', queryPath);
end

%% Build fingerprint database
database = cell(numSongs, 1);
fprintf('\nBuilding fingerprint database...\n');
for k = 1:numSongs
    filePath = fullfile(dbDir, dbFiles{k});
    fprintf('Fingerprinting database song %d: %s\n', k, dbFiles{k});
    hashes = createAudioFingerprint(filePath, params);
    database{k} = hashes;
    fprintf('  Hash count: %d\n', size(hashes, 1));
end

%% Fingerprint query
fprintf('\nFingerprinting query: %s\n', queryFile);
queryHashes = createAudioFingerprint(queryPath, params);
fprintf('Query hash count: %d\n', size(queryHashes, 1));

%% Match query against database
[scores, bestIndex] = matchFingerprint(queryHashes, database);

%% Print result
fprintf('\n===== Match Results =====\n');
for k = 1:numSongs
    fprintf('Song %d (%s): score = %.4f\n', k, dbFiles{k}, scores(k));
end
fprintf('\nBest match index: %d\n', bestIndex);
fprintf('Best match file: %s\n', dbFiles{bestIndex});

%% Local functions
function hashes = createAudioFingerprint(filename, params)
    [x, Fs] = audioread(filename);
    x = mean(x, 2);
    if max(abs(x)) > 0
        x = x / max(abs(x));
    end

    [S, F, T] = spectrogram(x, params.windowSize, params.overlap, [], Fs);
    S = abs(S);

    ampMin = percentileThreshold(S, params.peakPercentile);
    peaks = detectLocalPeaks(S, ampMin, params.neighborhoodSize);
    [peakFreqIdx, peakTimeIdx] = find(peaks);
    [~, order] = sort(peakTimeIdx);
    peakFreqIdx = peakFreqIdx(order);
    peakTimeIdx = peakTimeIdx(order);

    hashes = generateHashes(peakFreqIdx, peakTimeIdx, F, T, params.fanOut);
    if isempty(hashes)
        warning('No hashes generated for file: %s', filename);
    end
end

function threshold = percentileThreshold(S, percentile)
    values = sort(S(:));
    if isempty(values)
        threshold = 0;
        return;
    end

    idx = ceil((percentile / 100) * numel(values));
    idx = min(max(idx, 1), numel(values));
    threshold = values(idx);
end

function peaks = detectLocalPeaks(S, ampMin, neighborhoodSize)
    peaks = false(size(S));
    [nFreqBins, nTimeBins] = size(S);

    for t = (1 + neighborhoodSize):(nTimeBins - neighborhoodSize)
        for f = (1 + neighborhoodSize):(nFreqBins - neighborhoodSize)
            localWindow = S(f - neighborhoodSize:f + neighborhoodSize, ...
                            t - neighborhoodSize:t + neighborhoodSize);
            localMax = max(localWindow(:));

            if S(f, t) == localMax && S(f, t) > ampMin
                peaks(f, t) = true;
            end
        end
    end
end

function hashes = generateHashes(peakFreqIdx, peakTimeIdx, F, T, fanOut)
    hashes = [];
    numPeaks = length(peakTimeIdx);

    for i = 1:numPeaks
        for j = 1:fanOut
            if i + j <= numPeaks
                t1 = T(peakTimeIdx(i));
                t2 = T(peakTimeIdx(i + j));
                f1 = F(peakFreqIdx(i));
                f2 = F(peakFreqIdx(i + j));
                deltaT = t2 - t1;
                hashRow = [round(f1), round(f2), round(deltaT, 2)];
                hashes(end + 1, :) = hashRow; %#ok<AGROW>
            end
        end
    end
end

function [scores, bestIndex] = matchFingerprint(queryHashes, database)
    numSongs = length(database);
    scores = zeros(numSongs, 1);

    if isempty(queryHashes)
        error('Query generated no hashes. Cannot match.');
    end

    queryKeys = string(queryHashes(:, 1)) + "_" + ...
                string(queryHashes(:, 2)) + "_" + ...
                string(queryHashes(:, 3));
    querySet = unique(queryKeys);

    for k = 1:numSongs
        dbHashes = database{k};
        if isempty(dbHashes)
            scores(k) = 0;
            continue;
        end

        dbKeys = string(dbHashes(:, 1)) + "_" + ...
                 string(dbHashes(:, 2)) + "_" + ...
                 string(dbHashes(:, 3));
        dbSet = unique(dbKeys);

        intersectionCount = length(intersect(querySet, dbSet));
        unionCount = length(union(querySet, dbSet));

        if unionCount == 0
            scores(k) = 0;
        else
            scores(k) = intersectionCount / unionCount;
        end
    end

    [~, bestIndex] = max(scores);
end
