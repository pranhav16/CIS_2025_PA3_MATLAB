function [vertices, triangles] = read_mesh(filename)
    thisDir = fileparts(mfilename('fullpath'));
    % Two levels up
    parent2 = fileparts(fileparts((thisDir)));
    addpath(genpath(parent2));
    fid = fopen(filename, 'r');
    
    % Check if file opened successfully
    if fid == -1
        error('Unable to open file: %s', filename);
    end
    
        % Read N_vertices
        line = fgetl(fid);
        N_vertices = str2double(line);
        vertices = zeros(N_vertices, 3);
        
        for i = 1:N_vertices
            line = fgetl(fid);
            coords = textscan(line, '%f %f %f', 'Delimiter', ',');
            vertices(i, 1) = coords{1};
            vertices(i, 2) = coords{2};
            vertices(i, 3) = coords{3};
        end
        
        line = fgetl(fid);
        N_triangles = str2double(line);
        triangles = zeros(N_triangles, 6);
          for i = 1:N_triangles
            line = fgetl(fid);
            indices = textscan(line, '%d %d %d %d %d %d', 'Delimiter', ',');
            triangles(i, 1) = indices{1} + 1;  % i1
            triangles(i, 2) = indices{2} + 1;  % i2
            triangles(i, 3) = indices{3} + 1;  % i3
            
            triangles(i, 4) = indices{4};  % n1
            triangles(i, 5) = indices{5};  % n2
            triangles(i, 6) = indices{6};  % n3
            if triangles(i, 4) >= 0
                triangles(i, 4) = triangles(i, 4) + 1;
            end
            if triangles(i, 5) >= 0
                triangles(i, 5) = triangles(i, 5) + 1;
            end
            if triangles(i, 6) >= 0
                triangles(i, 6) = triangles(i, 6) + 1;
            end
          end
        fclose(fid);
        
end