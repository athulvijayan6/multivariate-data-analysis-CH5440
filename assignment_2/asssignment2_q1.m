% Coded by Athul Vijayan
% Roll Number : ED11B004

% Assignment 2, Question 1


%Question 1 Part A  starts-------------------------
X = [1, 120, 55; 1, 130,50; 1, 108,52; 1, 110,42; 1, 84,40; 1, 90,30; 1, 80,23; 1, 55,12; 1, 64,19; 1, 50,10];  %input varables[x1, x2]
Y = [310; 300; 275; 250; 220; 200; 190; 150; 140; 100];     %output

theta = inv(X'*X)*X'*y;  % matrix containing weight coefficient
disp('weight matrix is');
disp(theta);

if theta(1)>theta(2)
	disp('Labour (x1) has more effect on cost');
elseif theta(1)<theta(2)
	disp('Engineering units (x2) has more effect on cost');
else
	disp('both parameters have same effect on cost');
end

yhat = X*theta;

coeffDetermination = 1-(y'*(y-yhat)/(y'*(y-mean(y))));
disp('Coefficient of determination');
disp(coeffDetermination);
%Question 1 Part A  ends-------------------------


% Question 1 Part B starts-----------------------
X = X(:,2:end);        %delete constant term form X matrix
X(:,1) = (X(:,1)-mean(X(:,1)))/std((X(:,1)));  % scale X row 1 as (x1-mean)/standard deviation
X(:,2) = (X(:,2)-mean(X(:,2)))/std((X(:,2)));  % scale X row 2 as (x1-mean)/standard deviation

Y = (y-mean(y))/std(y);  % scale Y as (y-mean)/standard deviation

[W, D] = pcaeig(X);
% smallest eigenvalue corresponds to eigenvector [0.7071 -0.7071]
% linear regression model y = ax1+bx2 will become y = 0.7071*x1-0.7071*x2
yLinearReg = W(1,1)*X(1,1) + W(2,1)*X(1,2);
disp('estimated cost for given values');
disp(yLinearReg);
% Question 1 Part B ends-------------------------