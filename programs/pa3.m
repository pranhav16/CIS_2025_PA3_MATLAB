% pa3.m
%authors: luiza and pranhav
% this is the main function for pa3, calls the helper functions
% it reads data for rigid bodies and a mesh, calculates the pointer tip position for various samples, and finds the closest point on the mesh to that tip
function pa3(type, dataset)

    thisDir = fileparts(mfilename('fullpath'));
    parent1 = fileparts((thisDir));
    addpath(genpath(parent1));  %add everything to MATLAB path  
%% 1. SETUP - Define input file names

body_A_file = 'Problem3-BodyA.txt';
body_B_file = 'Problem3-BodyB.txt';
mesh_file = 'Problem3Mesh.sur';
sample_file = sprintf('PA3-%s-%s-SampleReadingsTest.txt', dataset,type);

%% 2. READ INPUT FILES
% Read body A (pointer with tip)
[A_markers, A_tip] = read_body(body_A_file);
N_A = size(A_markers, 1);

% Read body B (base/reference body)
[B_markers, B_tip] = read_body(body_B_file);
N_B = size(B_markers, 1);

% Read mesh surface
[vertices, triangles] = read_mesh(mesh_file);
N_vertices = size(vertices, 1);
N_triangles = size(triangles, 1);

% Read sample readings from tracker
[a_readings, b_readings, N_samps] = read_sample_readings(sample_file, N_A, N_B);

%% 3. PROCESS SAMPLE FRAME
% Preallocate output arrays
d_k_array = zeros(N_samps, 3);  % Pointer tip positions in B frame
c_k_array = zeros(N_samps, 3);  % Closest points on mesh
differences = zeros(N_samps, 1); % Distances ||d_k - c_k||

for k = 1:N_samps
    
    %% a. Get marker readings
    a_k = a_readings(:, :, k);  % N_A x 3 
    b_k = b_readings(:, :, k);  % N_B x 3 
    
    %% b. Compute F_A
    [R_A, t_A] = find_transformation(A_markers, a_k);
       F_A_k = [R_A, t_A; 0 0 0 1];  % 4x4 transformation matrix
    
    %% Compute F_B
    [R_B, t_B] = find_transformation(B_markers, b_k);
    
    F_B_k = [R_B, t_B; 0 0 0 1];  % 4x4 transformation matrix
    
    %% Compute d_k (pointer tip position in B body frame)
    [R_B_inv, t_B_inv] = invert_transform(R_B, t_B);
    F_B_k_inv = [R_B_inv, t_B_inv; 0 0 0 1];
    
    A_tip_homog = [A_tip(:); 1];  % 4x1 vector
    
    d_k_homog = F_B_k_inv * F_A_k * A_tip_homog;
    
    d_k = d_k_homog(1:3)/d_k_homog(4);
    
    %% Find closest point on mesh to d_k
    [c_k, dist] = closest_point_on_mesh(d_k, vertices, triangles);
    
    %% Store results
    d_k_array(k, :) = d_k';
    c_k_array(k, :) = c_k';
    differences(k) = dist;
end
% write output file
output_file = sprintf('PA3-%s-%s-Output.txt', dataset,type);
    current_file_path = fileparts(mfilename('fullpath'));
    
    output_dir = fullfile(current_file_path, '..', 'output');
    % ensure directory exists
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
        fprintf('Created directory: %s\n', output_dir);
    else
        fprintf('Directory already exists: %s\n', output_dir);
    end
    %call helper function
write_output(output_file, d_k_array, c_k_array, differences);

end
