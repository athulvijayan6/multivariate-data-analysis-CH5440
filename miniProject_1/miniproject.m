load('GPSdata.mat');

%convert to radians
lat = degtorad(Locationdata(:,2));
lon = degtorad(Locationdata(:,3));
alt = Locationdata(:,5);
time = Locationdata(:,1);

accuracy = Locationdata(:,4);
% clear('Locationdata');

Speed = convvel(Speed,'km/h','m/s');        %convert measured speed to m/s

% In the data it is evident that different GPS locations are data present for the same same timestamp
% As this is not physically possible, it is caused by error. So we assign mean of Location data to such time stamps.
[time, goodIndices, ic] = unique(time);
lat = lat(goodIndices);
lon = lon(goodIndices);
alt = alt(goodIndices);
accuracy = accuracy(goodIndices);
clear('ic');

[xRaw, yRaw, zRaw] = geodeticToCartesian(lat,lon,alt);   % transformed coordinates in cartesian

% Centralize the data
xMean = mean(xRaw);
yMean = mean(yRaw);
zMean = mean(zRaw);

x = xRaw - xMean*ones(size(xRaw));            %centralize the data to have mean=0
y = yRaw - yMean*ones(size(yRaw));
z = zRaw - zMean*ones(size(zRaw));

clear('xRaw','yRaw','zRaw');   % free up the computer memory from unused variables.each cell is 8 bytes!!!
% Now x, y and z hold data in ECEF coordinates which are not denoised.

% By fitting the data in a cubic smoothing spline, 
% we do a denoising (though not very effective considering existance of outliers). 
% Also by differentiating this, we get the velovity

% We use csaps function of matlab

% this does minimize sum(W*|y - f(x)|^2 + (1-p)*integral(lambda*|dd(f(t))|^2)dt)
% The default value for the piecewise constant weight function λ in the roughness measure is the constant function 1.
% is often near 1/(1 + h3/6), with h the average spacing of the data sites.
% for uniformly spaced data, p= 1/(1 + h^3/0.6).
h = (time(end)-time(1))/size(time,1);
p = 1/(1+(h^3)/0.6);

% we use weight function w as 1/accuracy^2
weights = 1./accuracy.^2;

xFunction = csaps(time, x, p, [], weights);
yFunction = csaps(time, y, p, [], weights);
zFunction = csaps(time, z, p, [], weights);
%to verify our curve fitting, we can plot the initial points and fitted curve
fnplt(xFunction);
hold on;
plot(time, x,'r+','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g','MarkerSize',1)

fnplt(yFunction);
hold on;
plot(time, y,'r+','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g','MarkerSize',1)

fnplt(zFunction);
hold on;
plot(time, z,'r+','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g','MarkerSize',1)

% It is clear that all functions are fitted with a good accuracy

% Differentiating this will give velocity in each axes
xVelocity = fnder(xFunction);
yVelocity = fnder(yFunction);
zVelocity = fnder(zFunction);

% now we predict the velocities taken independently

xVelocityPredicted = fnval(xVelocity, Timestamps);
yVelocityPredicted = fnval(yVelocity, Timestamps);
zVelocityPredicted = fnval(zVelocity, Timestamps);

speedPredicted = sqrt(xVelocityPredicted.^2+yVelocityPredicted.^2+zVelocityPredicted.^2);
convvel(speedPredicted-Speed,'m/s','km/h')
