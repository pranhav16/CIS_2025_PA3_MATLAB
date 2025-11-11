function [c, min_distance] = closest_point_on_mesh(p, vertices, triangles)

p = p(:);

M = size(triangles, 1);
min_distance = inf;
c = zeros(3, 1);
for i = 1:M

    idx1 = triangles(i, 1);
    idx2 = triangles(i, 2);
    idx3 = triangles(i, 3);
    v1 = vertices(idx1, 1:3)';
    v2 = vertices(idx2, 1:3)';
    v3 = vertices(idx3, 1:3)';
    [c_tri, dist_tri] = closest_point_on_triangle(p, v1, v2, v3);
    if dist_tri < min_distance
        min_distance = dist_tri;
        c = c_tri;
    end
end

end