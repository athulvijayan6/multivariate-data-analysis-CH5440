load('GPSdata.mat');

%convert to radians
lat = degtorad(Locationdata(:,2));
lon = degtorad(Locationdata(:,3));
time = Locationdata(:,1);

accuracy = Locationdata(:,4);
clear('Locationdata');

Speed = convvel(Speed,'km/h','m/s');        %convert measured speed to m/s

% In the data it is evident that different GPS locations are data present for the same same timestamp
% As this is not physically possible, it is caused by error. So we assign mean of Location data to such time stamps.
[time, ia, ic] = unique(time);
lat = lat(ia);
lon = lon(ia);
clear('ia','ic');
[xRaw, yRaw, zRaw] = geodeticToCartesian(lat,lon,0);   % transformed coordinates in cartesian

% Centralize the data
xMean = mean(xRaw);
yMean = mean(yRaw);
zMean = mean(zRaw);

x = xRaw - xMean*ones(size(xRaw));            %centralize the data to have mean=0
y = yRaw - yMean*ones(size(yRaw));
z = zRaw - zMean*ones(size(zRaw));

clear('xRaw','yRaw','zRaw');   % free up the computer memory from unused variables.each cell is 8 bytes!!!
% Now x, y and z hold data in ECEF coordinates which are not denoised.

% For denoising PCA can be used

