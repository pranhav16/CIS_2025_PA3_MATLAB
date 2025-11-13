%invert_transform.m
%author: pranhav
% this function inverts a rigit body transformation
function [R_inv, t_inv] = invert_transform(R, t)


    R_inv = R';
    t_inv = -R' * t;
end