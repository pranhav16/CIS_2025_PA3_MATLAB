% run_validation_tests.m
%author: luiza
% This script performs unit tests on major functions

currentDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(currentDir, '..')));

fprintf('--- Validation Script for PA3 ---\n\n');

%% 1. Validation of find_transformation.m
% Test: Create a known transformation (R, t), apply it to a set of
% "model" points (P) to get "measured" points (Q).
% Then, use the function to see if it can recover the original (R, t).
    P = [ 0  0  0;
         10  0  0;
          0 10  0;
          0  0 10;
          5  5  5;
         -5  5 10 ];
    N = size(P, 1);
 % 45-degree rotation around Z
    theta = pi / 4; 
    R_true = [ cos(theta) -sin(theta) 0;
               sin(theta)  cos(theta) 0;
               0           0          1 ];
        t_true = [50; -30; 100]; 
        Q_perfect = (R_true * P' + t_true)';
        [R_calc, t_calc] = find_transformation(P, Q_perfect);
        R_error = norm(R_true - R_calc, 'fro'); % Frobenius norm for matrices
        t_error = norm(t_true - t_calc);         % Euclidean norm for vectors
    
    fprintf('  Test Case 1: Perfect Data (Fake)\n');
    fprintf('    Rotation Error (Frobenius Norm): %e\n', R_error);
    fprintf('    Translation Error (Euclidean Norm): %e\n', t_error);
    
    % 6. Test with noisy data
    noise_level = 0.1; % 0.1mm standard deviation
    Q_noisy = Q_perfect + noise_level * randn(size(Q_perfect));
    
    [R_calc_n, t_calc_n] = find_transformation(P, Q_noisy);
    
        P_transformed_noisy = (R_calc_n * P' + t_calc_n)';
        errors = P_transformed_noisy - Q_noisy;
        squared_errors = sum(errors.^2, 2);
        fre = sqrt(mean(squared_errors));
    
    fprintf('  Test Case 2: Noisy Data (Fake, Noise=%.2fmm)\n', noise_level);
    fprintf('    Fiducial Registration Error (RMSE): %f mm\n\n', fre);

%% 2. Validation of closest_point_on_triangle.m
% Test: Create a simple triangle and test points in known regions:
% First, A point inside the triangle.
% Then, A point closest to a vertex.
% Then ,A point closest to an edge.
fprintf('--- Testing closest_point_on_triangle.m ---\n');
% 1. Define a simple triangle in the XY plane
v1_tri = [0; 0; 0];
v2_tri = [10; 0; 0];
v3_tri = [0; 10; 0];
% 2. First test
p_inside = [2; 2; 0];
p_inside_expected = [2; 2; 0];
[c_inside, ~] = closest_point_on_triangle(p_inside, v1_tri, v2_tri, v3_tri);
fprintf('  Case 1 (Inside):       Query = [2; 2; 0]\n');
fprintf('    Expected: [%.1f; %.1f; %.1f], Got: [%.1f; %.1f; %.1f]\n', ...
    p_inside_expected, c_inside);
% 3. Second test
p_vertex = [-5; -5; 0];
p_vertex_expected = [0; 0; 0];
[c_vertex, ~] = closest_point_on_triangle(p_vertex, v1_tri, v2_tri, v3_tri);
fprintf('  Case 2 (Near Vertex):  Query = [-5; -5; 0]\n');
fprintf('    Expected: [%.1f; %.1f; %.1f], Got: [%.1f; %.1f; %.1f]\n', ...
    p_vertex_expected, c_vertex);
% 4. Third test
p_edge = [5; -5; 0];
p_edge_expected = [5; 0; 0];
[c_edge, ~] = closest_point_on_triangle(p_edge, v1_tri, v2_tri, v3_tri);
fprintf('  Case 3 (Near Edge):    Query = [5; -5; 0]\n');
fprintf('    Expected: [%.1f; %.1f; %.1f], Got: [%.1f; %.1f; %.1f]\n\n', ...
    p_edge_expected, c_edge);

%% 3. Validation of closest_point_on_mesh.m
% simple mesh with two far triangles
% T1 points should return T1 and T2 points should return T2
% Triangle 1 (T1) vertices (indices 1, 2, 3)
v1 = [0, 0, 0];
v2 = [10, 0, 0];
v3 = [0, 10, 0];
% Triangle 2 (T2) vertices (indices 4, 5, 6)
v4 = [100, 0, 0];
v5 = [110, 0, 0];
v6 = [100, 0, 10];

vertices = [v1; v2; v3; v4; v5; v6];
triangles = [ 1, 2, 3, -1, -1, -1;
              4, 5, 6, -1, -1, -1 ];
p1_mesh = [2; 2; 0]; 
p1_mesh_expected = [2; 2; 0];
[c1_mesh, dist1_mesh] = closest_point_on_mesh(p1_mesh, vertices, triangles);
fprintf('  Case 1 (Point on T1):  Query = [2; 2; 0]\n');
fprintf('    Expected: [%.1f; %.1f; %.1f], Got: [%.1f; %.1f; %.1f] (Dist: %.2f)\n', ...
    p1_mesh_expected, c1_mesh, dist1_mesh);

p2_mesh = [101; 0; 1]; 
p2_mesh_expected = [101; 0; 1];
[c2_mesh, dist2_mesh] = closest_point_on_mesh(p2_mesh, vertices, triangles);
fprintf('  Case 2 (Point on T2):  Query = [101; 0; 1]\n');
fprintf('    Expected: [%.1f; %.1f; %.1f], Got: [%.1f; %.1f; %.1f] (Dist: %.2f)\n', ...
    p2_mesh_expected, c2_mesh, dist2_mesh);

fprintf('\nValidation complete.\n');