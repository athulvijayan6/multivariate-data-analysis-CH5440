Coded by Athul Vijayan
Roll Number : ED11B004

Assignment 2, Question 4

M = csvread('swissData.csv');
original = M(1:100,1:6);
dupe = M(101:200,1:6);

originalMean = mean(original(1:66, 1:6))
dupeMean = mean(dupe(1:66, 1:6))
originalCovarInv = inv(cov(original(1:60, 1:6)))
dupeCovarInv = inv(cov(dupe(1:66, 1:6)))

% PART A starts---------------
for i=67:100
	originalScore = (original(i,1:6)-originalMean)*originalCovarInv*(original(i,1:6)-originalMean)'
	dupeScore = (original(i,1:6)-dupeMean)*dupeCovarInv*(original(i,1:6)-dupeMean)'
	if originalScore<dupeScore
		disp('currency is predicted to be original. and precition is correct');

	elseif originalScore>dupeScore
		disp('predicted not original. but predicted with error 2')
	else
		disp('cannot predict');
	end

	originalScore = (dupe(i,1:6)-originalMean)*originalCovarInv*(dupe(i,1:6)-originalMean)'
	dupeScore = (dupe(i,1:6)-dupeMean)*dupeCovarInv*(dupe(i,1:6)-dupeMean)'
	if originalScore<dupeScore
		disp('currency is predicted to be original. but predicted with error 1');

	elseif originalScore>dupeScore
		disp('predicted not original. and precition is correct')
	else
		disp('cannot predict');
	end

end

%PART A ends-----------