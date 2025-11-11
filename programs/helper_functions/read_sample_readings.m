function [a_markers, b_markers, N_samples] = read_sample_readings(filename, N_A, N_B)
        thisDir = fileparts(mfilename('fullpath'));
    % Two levels up
    parent2 = fileparts(fileparts((thisDir)));
    addpath(genpath(parent2));

fid = fopen(filename, 'r');
    
        % Read first line: N_S, N_samples, filename
        firstLine = fgetl(fid);
        parsedData = textscan(firstLine, '%d %d %s', 'Delimiter', ',');
        N_S = parsedData{1};
        N_samples = parsedData{2};
        
        N_D = N_S - N_A - N_B;
        
        % Verify that N_D is non-negative
        if N_D < 0
            error('Invalid marker counts: N_A + N_B (%d) exceeds N_S (%d)', N_A + N_B, N_S);
        end
        
        a_markers = zeros(N_A, 3, N_samples);
        b_markers = zeros(N_B, 3, N_samples);
        
        % Read data for each sample
        for k = 1:N_samples
            % Read N_A lines for A body markers
            for i = 1:N_A
                line = fgetl(fid);
                coords = textscan(line, '%f %f %f', 'Delimiter', ',');
                a_markers(i, 1, k) = coords{1};
                a_markers(i, 2, k) = coords{2};
                a_markers(i, 3, k) = coords{3};
            end
            
            % Read N_B lines for B body markers
            for i = 1:N_B
                line = fgetl(fid);
                coords = textscan(line, '%f %f %f', 'Delimiter', ',');
                b_markers(i, 1, k) = coords{1};
                b_markers(i, 2, k) = coords{2};
                b_markers(i, 3, k) = coords{3};
            end
            
            % Skip N_D dummy marker lines
            for i = 1:N_D
                fgetl(fid);
            end
        end
        
        % Close the file
        fclose(fid);
        
end