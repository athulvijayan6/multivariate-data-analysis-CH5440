% Coded by Athul Vijayan
% Roll Number : ED11B004

% Assignment 2, Question 2

S = [7,21,34; 21,64,102; 34,102,186];
Xmean = [9 68 129];

%--------PART A---------
[V, D] = eig(S);
disp(D);
disp(V);
% correspoding to 250.4-->
eigenVector = V(:,3)
% ----------PART A ends

% PART B starts----------
% choosing eigenvalues so that atleast 95% of variance is caputerd
% 250.4/(250.4+6.509+0.0896)*100 = 97.43  implies taking only 250.4 as 
% eigen value will capture atleast 95% of variance

% PART B ends----------

% PART C starts-----------
D = diag(D)';
D = D ./ sum(D); % percent variance accounted for
% we need to sort the weights by D to put them in descending order
[y,i]=sort(D); i=fliplr(i);
V=V(:,i)
D=D(i)
%with eigen value of 250.4 alone, we were able to capture more than 95% of variance
%which implies we have two linear relationships relating x1, x2, and x3. among them if we take 
%linear relationship which capture least percentage of variance, we get the linear equation
%    X*V(:,3) = Const      (x1v31+x2v31+x3v31 = C)
%to find the constant, select (x1, x2, x3) as given mean values because they will aproximately
%obey the linear relationship.

C = Xmean*V(:,3)
%PART C ends -------------------

%PART D starts -------------------

%Score for lizard ==> y value
%with more than 95% variance capture, weight matrix will become [0.1619, 0.4877, 0.8579]
givenX = [10.1 73 135.5]
score = givenX*V(:,1)  %first row of V which captures 97.4% variance

%PART D ends -------------------

%PART E starts -------------------
%we have a linear relationship from part C of this question with which we can approximate mass
syms temp;
mass = double(solve([temp, 75, 141]*V(:,3)==C))
%PART E ends -------------------





