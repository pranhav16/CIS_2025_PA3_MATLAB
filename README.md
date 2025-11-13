# CIS I - Programming Assignment 3 (Matlab)
Luiza Brunelli and Pranhav Sundararajan

# Project Organization
The CIS_2025_PA3_MATLAB folder contains four directories: `programs`, `2025_pa345_student_data`, `output`, and validation/analysis scripts are located in the `programs` directory. 
For the main `pa3_run.m` script, the `2025_pa345_student_data` directory must contain all of the input text files and must be at the same level as `programs`. 
Inside the `programs` directory and inside `helper_functions` is where all the code files are located and used by the main script `pa3_run.m` and the main function `pa3.m`. 
For proper use, one has to simply download the zip file for this repository or clone it, enter into `CIS_2025_PA3_MATLAB/programs` and run the `pa3_run.m` script. 
This will create an `output` directory inside `CIS_2025_PA3_MATLAB` in which the resulting output file will be placed. 
Upon downloading this repository, the output folder will already contain output files for each dataset. 
These files are produced from our code inside this repository. These files will be overwritten when the `pa3_run.m` script is run again.

## Files
pa3_run.m - Main script that when run calls `pa3.m`. This script allows the user to set the parameters for `pa3.m`, choosing whether the input is a 'Debug' or 'Unknown' file and what file letter to use.

pa3.m - Main function for PA3. Reads all input data, computes transformations $F_A$ and $F_B$, finds the pointer tip $\vec{d}_k$, calls `closest_point_on_mesh` to get $\vec{c}_k$, and writes the final output file.

find_transformation.m - Calculates the rigid transformation (rotation and translation) between two sets of 3D points.

invert_transform.m - Inverts a rigid body transformation (R, t) to its inverse (R', -R'*t).

closest_point_on_triangle.m - Finds the closest point on a single 3D triangle to a query point using barycentric coordinates.

closest_point_on_mesh.m - Finds the globally closest point on a surface mesh by performing a linear search over all triangles.

read_body.m - Reads a 'ProblemX-BodyY.txt' file to extract the N marker coordinates and the tip coordinate.

read_mesh.m - Reads a 'ProblemXMesh.sur' file to extract the vertex list and triangle index list.

read_sample_readings.m - Reads a '...-SampleReadingsTest.txt' file to extract all A-body and B-body marker readings for all sample frames.

write_output.m - Writes the final $\vec{d}_k$, $\vec{c}_k$, and distance data to the specified 'pa3-X-Output.txt' file format.

run_validation_tests.m - Performs unit tests on `find_transformation`, `closest_point_on_triangle`, and `closest_point_on_mesh`.

analyze_pa3_results.m - runs program on all datasets and analyzes the debug output files against the provided solutions and prints an error table.