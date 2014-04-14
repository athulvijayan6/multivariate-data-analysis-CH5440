% The function is used to calculate cartesian coordinates from geodetic GPS data
% [x,y,z] = geodeticToCartesian(lat,lon,alt)

function [ xDot, yDot, zDot ] = getCartesianVelocity( lat, lon, latDot, lonDot)
majorAxis = 6378137;
minorAxis = 6356752.314245
e = sqrt(1-(minorAxis/majorAxis)^2);

% (prime vertical radius of curvature)
N = majorAxis ./ sqrt(1 - e^2 .* sin(lat).^2);

x = N.* cos(lat) .* cos(lon);
y = N.* cos(lat) .* sin(lon);
z = (N .*(1-e^2)) .* sin(lat);

xDot = ((N .*(e^2-1)).*sin(lat).*cos(lon)./(1-e^2 .* sin(lat).^2)).*latDot+(N.*-1.*cos(lat).*sin(lon)).*lonDot;
yDot = ((N .*(e^2-1)).*sin(lat).*sin(lon)./(1-e^2 .* sin(lat).^2)).*latDot+(N.*cos(lat).*cos(lon)).*lonDot;
zDot = ((N .*(1-e^2)).*cos(lat)./(1-e^2 * sin(lat).^2)).*latDot;
return

end

