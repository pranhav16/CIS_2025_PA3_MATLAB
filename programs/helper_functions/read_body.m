function [markers, tip] = read_body(filename)
    thisDir = fileparts(mfilename('fullpath'));
    % Two levels up
    parent2 = fileparts(fileparts((thisDir)));
    addpath(genpath(parent2));
    fid = fopen(filename, 'r');
    if fid == -1
        error('Unable to open file: %s', filename);
    end
    
    
        firstLine = fgetl(fid);
        parsedData = textscan(firstLine, '%d %s', 'Delimiter', ',');
        N_markers = parsedData{1};
        
        markers = zeros(N_markers, 3);
        
        for i = 1:N_markers
            line = fgetl(fid);
            coords = textscan(line, '%f %f %f', 'Delimiter', ',');
            markers(i, 1) = coords{1};
            markers(i, 2) = coords{2};
            markers(i, 3) = coords{3};
        end
        
        tipLine = fgetl(fid);
        tipCoords = textscan(tipLine, '%f %f %f', 'Delimiter', ',');
        tip = [tipCoords{1}, tipCoords{2}, tipCoords{3}];
        
        fclose(fid);
        
end