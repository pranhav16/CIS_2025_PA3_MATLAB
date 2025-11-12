% closest_point_on_triangle.m
% author: luiza
% this function finds the closest point c on a single triangle to a point p

function [c,dist] = closest_point_on_triangle(p, v1, v2, v3)
p = p(:);
v1 = v1(:);
v2 = v2(:);
v3 = v3(:);

%Compute edge vectors
e1 = v2 - v1;  % edge from v1 to v2
e2 = v3 - v1;  % edge from v1 to v3

%Compute vector from v1 to query point
w = p - v1;

%Compute dot products for barycentric coordinates
a = dot(e1, e1);  % |e1|^2
b = dot(e1, e2);  % e1 · e2
c = dot(e2, e2);  % |e2|^2
d = dot(e1, w);   % e1 · w
e = dot(e2, w);   % e2 · w

% Compute barycentric coordinates
denom = a * c - b * b;

% Barycentric coordinates (v, w) where point = v1 + v*e1 + w*e2
v = (c * d - b * e) / denom;
w = (a * e - b * d) / denom;


% Regions:
%  0  inside triangle
%  1  outside edge v1-v2 (v < 0)
%  2  outside vertex v2 (v+w > 1, v >= 0)
%  3  outside edge v2-v3 (w < 0, v+w > 1)
%  4  outside vertex v3 (w < 0, v >= 0, v+w <= 1)
%  5  outside edge v1-v3 (w < 0, v < 0)
%  6  outside vertex v1 (v < 0, w < 0)

if v >= 0 && w >= 0 && (v + w) <= 1
%region 0: Inside triangle
    c = v1 + v * e1 + w * e2;
    
elseif v < 0
%region 1, 5 or 6
    if w < 0
%region 6: Closest to vertex v1
        c = v1;
    elseif e < 0
%region 5: Closest to edge v1-v3
        t = max(0, min(1, e / c));
        c = v1 + t * e2;
    else
%region 1: Closest to edge v1-v2
        t = max(0, min(1, d / a));
        c = v1 + t * e1;
    end
    
elseif w < 0
%region 1 or 4
    if d < 0
%region 4: Closest to vertex v1
        c = v1;
    else
%region 1: Closest to edge v1-v2
        t = max(0, min(1, d / a));
        c = v1 + t * e1;
    end
    
elseif (v + w) > 1
%region 2 or 3
    e3 = v3 - v2;
    w2 = p - v2;
    
    a3 = dot(e3, e3);
    d3 = dot(e3, w2);
    
    if d3 < 0
%closest is vertex v2
        c = v2;
    elseif d3 > a3
% closest is vertex v3
        c = v3;
    else
% closest is edge v2 - v3
        t = d3 / a3;
        c = v2 + t * e3;
    end 
end
dist = norm(p-c);
end