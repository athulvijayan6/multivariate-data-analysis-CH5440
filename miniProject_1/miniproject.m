load('GPSdata.mat');

%convert to radians
time = Locationdata(:,1);
lat = degtorad(Locationdata(:,2));
lon = degtorad(Locationdata(:,3));
accuracy = Locationdata(:,4);

clear('Locationdata'); % free up memory

% In the data it is evident that different GPS locations are data present for the same same timestamp
% As this is not physically possible, it is caused by error. So we assign mean of Location data to such time stamps.
[time, goodIndices, ic] = unique(time);
lat = lat(goodIndices);
lon = lon(goodIndices);
accuracy = accuracy(goodIndices);
clear('ic', 'goodIndices');

% Centralize the data
latMean = mean(lat);
lonMean = mean(lon);

lat = lat - latMean*ones(size(lat));            %centralize the data to have mean=0
lon = lon - lonMean*ones(size(lon));
%If we convert the data to cartesian coordinates before denoising, the associated errors will also get scaled up
% So we will fit the latitude and longitude in a cubic spline
% By fitting the data in a cubic smoothing spline, we do a denoising
% Also by differentiating this, we get the angular velovity in theta and phi directions

% We use csaps function of matlab for fitting

% this does minimize sum(W*|y - f(x)|^2 + (1-p)*integral(lambda*|f''(t)|^2)dt)
% The default value for the piecewise constant weight function λ in the roughness measure is the constant function 1.
% is often near 1/(1 + h^3/6), with h the average spacing of the data sites.
% for uniformly spaced data, p= 1/(1 + h^3/0.6).

h = (time(end)-time(1))/size(time,1);
p = 1/(1+(h^3)/60);

% we use weight function w as 1/accuracy^2
weights = 1./accuracy.^2;

latFunction = csaps(time, lat, p, [], weights); %Latitude fitted in fuction
lonFunction = csaps(time, lon, p, [], weights); %Longitude fitted in fuction
% Differentiating this will give velocity in each axes
latDotFunction = fnder(latFunction);  % angular velocity function in latitude direction
lonDotFunction = fnder(lonFunction);  % angular velocity function in longitude direction

%to verify our curve fitting, we can plot the initial points and fitted curve
subplot(2,2,1);
fnplt(latFunction,'r');
xlabel('time in seconds');
ylabel('latitude in radians');
hold on;
plot(time, lat,'x');
legend('fitted function','measured coordinates');

subplot(2,2,2);
fnplt(lonFunction,'r');
xlabel('time in seconds');
ylabel('longitude in radians');
hold on;
plot(time, lon,'x');
legend('fitted function','measured coordinates');
% It is clear that all functions are fitted with a good accuracy

% now we predict the velocities taken independently at timestamps
% Please refer to function getCartesianVelocity inthe parent directory
theta = fnval(latFunction,Timestamps); %temporary variable
phi = fnval(lonFunction,Timestamps);   %temporary variable
thetaDot = fnval(latDotFunction,Timestamps);  %temporary variable
phiDot = fnval(lonDotFunction, Timestamps);   %temporary variable
[xVelocityPredicted, yVelocityPredicted, zVelocityPredicted] = getCartesianVelocity(theta, phi, thetaDot, phiDot);
clear('theta', 'phiDot', 'thetaDot', 'phi'); % free up memory

% The speed i. e. the magnitude is calculated 
speedPredicted = sqrt(xVelocityPredicted.^2+yVelocityPredicted.^2+zVelocityPredicted.^2);

speedPredicted = convvel(speedPredicted,'m/s', 'km/h')    % convert speed to km/hour

errors = speedPredicted-Speed    % display errors in each reading.
meanError = mean(errors)    % average error.

subplot(2,2,3);
plot(errors,'*');
ylabel('speed in km/hr');
xlabel('Error in each predictions');
refline([0 meanError]);
legend('error','average error in predictions');

% it is possible to have error since the reading from analog speedometer does not accurately say the speed of travel

% For calculating distance travelled,
% we assume that vehicle travelled straight if we consider consecutive time gaps of 3 seconds.
tempTime = 0:3:time(end);
