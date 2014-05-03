% Coded by Athul Vijayan
% Roll Number : ED11B004

% Assignment 2, Question 4

M = csvread('swissData.csv');
original = M(1:100,1:6);
dupe = M(101:200,1:6);

originalMean = mean(original(1:66, 1:6))
dupeMean = mean(dupe(1:66, 1:6))
originalCovarInv = inv(cov(original(1:60, 1:6)))
dupeCovarInv = inv(cov(dupe(1:66, 1:6)))

% PART A starts---------------
correctPredictionCount = 0;
wrongPredictionCount = 0;
for i=67:100
	originalScore = (original(i,1:6)-originalMean)*originalCovarInv*(original(i,1:6)-originalMean)'
	dupeScore = (original(i,1:6)-dupeMean)*dupeCovarInv*(original(i,1:6)-dupeMean)'
	if originalScore<dupeScore
		disp('currency is predicted to be original. and precition is correct');
		correctPredictionCount = correctPredictionCount+1;
	elseif originalScore>dupeScore
		disp('predicted not original. but predicted with error 2');
		wrongPredictionCount= wrongPredictionCount+1;
	else
		disp('cannot predict');
	end
	originalScore = (dupe(i,1:6)-originalMean)*originalCovarInv*(dupe(i,1:6)-originalMean)'
	dupeScore = (dupe(i,1:6)-dupeMean)*dupeCovarInv*(dupe(i,1:6)-dupeMean)'
	if originalScore<dupeScore
		disp('currency is predicted to be original. but predicted with error 1');
		wrongPredictionCount= wrongPredictionCount+1;
	elseif originalScore>dupeScore
		disp('predicted not original. and precition is correct');
		correctPredictionCount = correctPredictionCount+1;
	else
		disp('cannot predict');
	end
	wrongPredictionCount
	correctPredictionCount
end

%PART A ends-----------

% PART B starts------

[W,D] = pcaeig(original(1:66,:))
% First for factors give 92% variance. so we neglect last two for finding original score
%W = W(:,1:4)
% we recreate the data
originalPCA = zscore(original(1:66,:))*W;
% same process for duplicates
[W,D] = pcaeig(dupe(1:66,:))
% First for factors give 92% variance. so we neglect last two for finding original score
W = W(:,1:4)
% we recreate the data
dupePCA = zscore(dupe(1:66,:))*W;

% Now scores can be found using PCA outputs. Note that PCA output will have mean=0
correctPredictionCount = 0;
wrongPredictionCount = 0;
for i=67:100
	originalScore = (original(i,1:4)-originalMean(1:4))*inv(cov(originalPCA))*(original(i,1:4)-originalMean(1:4))'
	dupeScore = (original(i,1:4)-dupeMean(1:4))*inv(cov(dupePCA))*(original(i,1:4)-dupeMean(1:4))'
	if originalScore<dupeScore
		disp('currency is predicted to be original. and precition is correct');
		correctPredictionCount = correctPredictionCount+1;
	elseif originalScore>dupeScore
		disp('predicted not original. but predicted with error 2');
		wrongPredictionCount= wrongPredictionCount+1;
	else
		disp('cannot predict');
	end
	originalScore = (dupe(i,1:4)-originalMean(1:4))*inv(cov(originalPCA))*(dupe(i,1:4)-originalMean(1:4))'
	dupeScore = (dupe(i,1:4)-dupeMean(1:4))*inv(cov(dupePCA))*(dupe(i,1:4)-dupeMean(1:4))'
	if originalScore<dupeScore
		disp('currency is predicted to be original. but predicted with error 1');
		wrongPredictionCount= wrongPredictionCount+1;
	elseif originalScore>dupeScore
		disp('predicted not original. and precition is correct');
		correctPredictionCount = correctPredictionCount+1;
	else
		disp('cannot predict');
	end
end
wrongPredictionCount
correctPredictionCount

