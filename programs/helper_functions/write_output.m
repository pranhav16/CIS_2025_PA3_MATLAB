function write_output(filename, d_array, c_array, diff_array)
    thisDir = fileparts(mfilename('fullpath'));
    % Two levels up
    parent2 = fileparts(fileparts((thisDir)));
    addpath(genpath(parent2));
    output_dir = fullfile(thisDir, '..', '..', 'OUTPUT');
    output_filename = fullfile(output_dir, filename);
N_samps = size(d_array, 1);
fid = fopen(output_filename, 'w');

    fprintf(fid, '%d, %s\n', N_samps, filename);
    
    for k = 1:N_samps
        d_x = d_array(k, 1);
        d_y = d_array(k, 2);
        d_z = d_array(k, 3);
        
        c_x = c_array(k, 1);
        c_y = c_array(k, 2);
        c_z = c_array(k, 3);
        
        diff = diff_array(k);
        
        fprintf(fid, '%.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f\n',d_x, d_y, d_z, c_x, c_y, c_z, diff);
    end
    
    fclose(fid);
    

    


end