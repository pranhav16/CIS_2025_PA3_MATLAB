% analyze_pa3_results.m
%author: luiza
% This script automates the results section of the report
% 1. Runs pa3.m for all debug and unknown datasets.
% 2. Analyzes the debug results against the provided solution files.
% 3. Tabulates the unknown results for the report.

clear; clc; close all;
currentDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(currentDir, '..')));

fprintf('--- PA3 Full Results and Analysis Script ---\n\n');

%% --- CONFIGURATION ---
my_output_dir = fullfile(currentDir, '..', 'output');
provided_output_dir = fullfile(currentDir, '..', '2025_pa345_student_data', '2025 PA345 Student Data');
% --- Datasets ---
debug_datasets = {'A', 'B', 'C', 'D', 'E', 'F'};
unknown_datasets = {'G', 'H', 'J'};

%% === PART 1: Run pa3 for all datasets ===
fprintf('=== Part 1: Running pa3 for all datasets... ===\n');
fprintf('Running Debug Datasets (A-F)...\n');
for i = 1:length(debug_datasets)
    dataset = debug_datasets{i};
    fprintf('  Running pa3("Debug", "%s")...\n', dataset);
    try
        pa3('Debug', dataset);
    catch ME
        fprintf('    ERROR running pa3 for Debug %s: %s\n', dataset, ME.message);
    end
end
fprintf('Running Unknown Datasets (G, H, J)...\n');
for i = 1:length(unknown_datasets)
    dataset = unknown_datasets{i};
    fprintf('  Running pa3("Unknown", "%s")...\n', dataset);
    try
        pa3('Unknown', dataset);
    catch ME
        fprintf('    ERROR running pa3 for Unknown %s: %s\n', dataset, ME.message);
    end
end
fprintf('All pa3 runs complete.\n\n');

%% === PART 2: Analyze Debug Datasets ===
fprintf('=== Part 2: Analyzing Debug Dataset Results ===\n');
fprintf('Comparing outputs in: %s\n', my_output_dir);
fprintf('     against ground truth in: %s\n\n', provided_output_dir);
fprintf('Analysis of Debug Datasets (PA3)\n');
fprintf('| Dataset | RMSE for c_k (mm) | MAE for |d-c| (mm) |\n');
fprintf('|:-------:|:-----------------:|:--------------------:|\n');

for i = 1:length(debug_datasets)
    dataset = debug_datasets{i};
    my_file = fullfile(my_output_dir, sprintf('PA3-%s-Debug-Output.txt', dataset));
    provided_file = fullfile(provided_output_dir, sprintf('PA3-%s-Debug-Output.txt', dataset));
    
        my_data = read_output_file(my_file);
        provided_data = read_output_file(provided_file);
        my_c_k = my_data(:, 4:6);
        provided_c_k = provided_data(:, 4:6);
        my_dist = my_data(:, 7);
        provided_dist = provided_data(:, 7); 
        sq_errors = sum((my_c_k - provided_c_k).^2, 2);
        rmse_c_k = sqrt(mean(sq_errors));
        mae_dist = mean(abs(my_dist - provided_dist));
        
        fprintf('|    %s    |     %.6e      |       %.6e       |\n', ...
            dataset, rmse_c_k, mae_dist);

end

%% === PART 3: Tabulate Unknown Datasets ===
fprintf('\n=== Part 3: Tabulating Unknown Dataset Results ===\n');
frames_to_show = [1, 10, 20]; % Frames to display in the report
fprintf('Tabular Data for Unknown Datasets (PA3) - Frames %s\n', mat2str(frames_to_show));
fprintf('-------------------------------------------------------------------------------------------------------\n');
fprintf('| Dataset | Frame |  d_x (mm) |  d_y (mm) |  d_z (mm) |  c_x (mm) |  c_y (mm) |  c_z (mm) | |d-c| (mm) |\n');
fprintf('|:-------:|:-----:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|:----------:|\n');

for i = 1:length(unknown_datasets)
    dataset = unknown_datasets{i};
    my_file = fullfile(my_output_dir, sprintf('PA3-%s-Unknown-Output.txt', dataset));
    
    try
        data = read_output_file(my_file);
        
        for j = 1:length(frames_to_show)
            frame_num = frames_to_show(j);
            if frame_num <= size(data, 1)
                frame_data = data(frame_num, :);
                fprintf('|    %s    |  %4d | %9.2f | %9.2f | %9.2f | %9.2f | %9.2f | %9.2f | %10.2f |\n', ...
                    dataset, frame_num, frame_data(1), frame_data(2), frame_data(3), ...
                    frame_data(4), frame_data(5), frame_data(6), frame_data(7));
            else
                fprintf('|    %s    |  %4d | (Frame not available in output file)\n', dataset, frame_num);
            end
        end
        
    catch ME
        fprintf('|    %s    |   --  | FAILED: %s\n', dataset, ME.message);
         if contains(ME.message, 'File not found')
             fprintf('|         |   --  | -> Did the `pa3("Unknown", "%s")` run correctly in Part 1?\n', dataset);
        end
    end
end
fprintf('-------------------------------------------------------------------------------------------------------\n');
fprintf('\nAnalysis complete.\n');

%% --- Helper function to read the PA3 output file format ---
function data = read_output_file(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('File not found: %s', filename);
    end
    
    try
        fgetl(fid); 
        data = cell2mat(textscan(fid, '%f %f %f %f %f %f %f', 'Delimiter', ','));
        fclose(fid);
    catch ME
        fclose(fid);
        rethrow(ME);
    end
end