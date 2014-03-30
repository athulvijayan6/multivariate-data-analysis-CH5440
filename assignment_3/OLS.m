function theta = OLS( X,Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
theta = inv(X'X)*X*Y;


end

