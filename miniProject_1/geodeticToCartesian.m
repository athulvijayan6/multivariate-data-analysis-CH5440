% The function is used to calculate cartesian coordinates from geodetic GPS data
% [x,y,z] = geodeticToCartesian(lat,lon,alt)

function [ x, y, z ] = geodeticToCartesian( lat, lon, alt )
earthRadius = 6378137;
e = 8.1819190842622e-2;

% (prime vertical radius of curvature)
N = earthRadius ./ sqrt(1 - e^2 .* sin(lat).^2);

x = (N+alt) .* cos(lat) .* cos(lon);
y = (N+alt) .* cos(lat) .* sin(lon);
z = ((1-e^2) .* N + alt) .* sin(lat);
return

end

