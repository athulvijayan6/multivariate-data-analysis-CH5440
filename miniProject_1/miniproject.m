load('GPSdata.mat');

%convert to radians
lat = degtorad(Locationdata(:,2));
lon = degtorad(Locationdata(:,3));
% alt = Locationdata(:,5);
time = Locationdata(:,1);

accuracy = Locationdata(:,4);
% clear('Locationdata');

Speed = convvel(Speed,'km/h','m/s');        %convert measured speed to m/s

% In the data it is evident that different GPS locations are data present for the same same timestamp
% As this is not physically possible, it is caused by error. So we assign mean of Location data to such time stamps.
[time, goodIndices, ic] = unique(time);
lat = lat(goodIndices);
lon = lon(goodIndices);
% alt = alt(goodIndices);
accuracy = accuracy(goodIndices);
clear('ic');

% Centralize the data
latMean = mean(lat);
lonMean = mean(lon);

lat = lat - latMean*ones(size(lat));            %centralize the data to have mean=0
lon = lon - lonMean*ones(size(lon));

h = (time(end)-time(1))/size(time,1);
p = 1/(1+(h^3)/0.6);

% we use weight function w as 1/accuracy^2
weights = 1./accuracy.^2;

latFunction = csaps(time, lat, p, [], weights);
lonFunction = csaps(time, lon, p, [], weights);
latDotFunction = fnder(latFunction);
lonDotFunction = fnder(lonFunction);


% Now x, y and z hold data in ECEF coordinates which are not denoised.

% By fitting the data in a cubic smoothing spline, 
% we do a denoising (though not very effective considering existance of outliers). 
% Also by differentiating this, we get the velovity

% We use csaps function of matlab

% this does minimize sum(W*|y - f(x)|^2 + (1-p)*integral(lambda*|f''(t)|^2)dt)
% The default value for the piecewise constant weight function λ in the roughness measure is the constant function 1.
% is often near 1/(1 + h^3/6), with h the average spacing of the data sites.
% for uniformly spaced data, p= 1/(1 + h^3/0.6).


% xFunction = spap2(optknt(time,4),time, x);
% yFunction = spap2(optknt(time,4),time, y);
% zFunction = spap2(optknt(time,4),time, z);

%to verify our curve fitting, we can plot the initial points and fitted curve
fnplt(latFunction,'r');
hold on;
plot(time, lat,'x');

fnplt(lonFunction,'r');
hold on;
plot(time, lon,'x');

% It is clear that all functions are fitted with a good accuracy

% Differentiating this will give velocity in each axes

% now we predict the velocities taken independently at timestamps
[xVelocityPredicted, yVelocityPredicted, zVelocityPredicted] = getCartesianVelocity(fnval(latFunction,Timestamps), fnval(lonFunction,Timestamps), fnval(latDotFunction,Timestamps), fnval(lonDotFunction, Timestamps));

speedPredicted = sqrt(xVelocityPredicted.^2+yVelocityPredicted.^2+zVelocityPredicted.^2);
speedPredicted-Speed
