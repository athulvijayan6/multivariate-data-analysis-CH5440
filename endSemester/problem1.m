% @Author: Athul Vijayan
% @Date:   2014-05-09 13:41:05
% @Last Modified by:   Athul Vijayan
% @Last Modified time: 2014-05-10 11:16:49

clear all
clc

load ('WDNdata.mat');

% ======================== Problem 1 Part (a) =====================================

% In first principles, we do not use data mining concepts, 
% instead we use relations from physics assuming that readings are error free
A = [1 -1 0 0 -1 0,
     0 1 -1 -1 0 0
     0 0 0 1 1 -1];
% lets calculate the error when assuming first principle
firstPrinError = 0;
for i=1:size(Fmeas,1)
	firstPrinError = firstPrinError + mean((A*Fmeas(i,:)').^2);          % Actual value = 0
end
firstPrinError = sqrt(firstPrinError/size(Fmeas,1));
disp('With assuming first principle, the RMSE in values are')
firstPrinError
% That is a huge error !!!
% ======================== Problem 1 Part (b) =====================================
% Now we consider each flow rates as input features and we assume no relation between these features,
% We try to find the constraint matrix using PCA in this approach
[eigVecs, scores, eigVals] = princomp(Fmeas);
clear('scores')              % We do not want this scores, which is calculated taking all eigen values
disp('Ideally we should retain 3 PCs since we know there are 3 independent variables')
%%%%%%%%%%%%%%%%%%%%%%%%%%   (i)  %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we check how many PCs capture 95% variance
variance = 0;
i=1;
while(variance<0.95)
	variance = sum(eigVals(1:i))/sum(eigVals);
	i = i+1;
end
i = i-1; % since i = i+1 comes after variance calculation inside while loop
disp(['PCA resulted that it will cover 95% variance taking ', num2str(i), ' principle components.'])
%%%%%%%%%%%%%%%%%%%%%%%%%%   (ii)  %%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCREE plot is the plot between variance captured Vs selected number of PCs.
for i=1:size(eigVals)
	explained(i) = eigVals(i)/sum(eigVals);
end
figure
pareto(explained)
title('SCREE Plot')
xlabel('Principal Component')
ylabel('Variance Explained (%)')
disp([' It is evident from the SCREE Plot that first three principle '...  
	'components are much dominant than others in capturing variance'])

%%%%%%%%%%%%%%%%%%%%%%%%%%   (iii)  %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we find the RMSE for every number of PCs.
% RMSE is found in this way
% We leave one Flow value out for Z in the OLS. 
% we can leave any of the 6 values because we will be able to write the left out one as linear combination of others
% maximum number of PCs that we can iterate is 5 since if we go to 6 we will not have reading for OLS
rmse = zeros(size(Fmeas,2)-1,1); % -1 because we are leaving one out
for nZ=1:size(Fmeas,2) % we will leave out every Flow reading in loop
	Z = Fmeas(:,nZ);   %measured
	FmeasTemp = [Fmeas(:,1:nZ-1) Fmeas(:,nZ+1:end)];
	[eigVecs, scores, eigVals] = princomp(FmeasTemp);
	for nPCs=1:size(eigVecs)
		selectedPCs = eigVecs(:,1:nPCs);   % select nPCs number of principle components
		scores = FmeasTemp*selectedPCs;   % the scores of data matrix (reduced data matrix of 1000x5)
		% Now we try to predict the left out row by OLS
		theta = inv(scores'*scores)*scores'*Z;
		Zhat = theta'*scores';
		rmse(nPCs) = rmse(nPCs) + rms(Z - Zhat');
	end
end

disp('Now we look at the drop in error with change in number of PCs')
figure
plot(rmse)
title('RMSE change Vs Number of PCs')
xlabel('Principal Component')
ylabel('Totla RMSE captured')
clear('i', 'nPCs', 'nZ', 'scores', 'selectedPCs', 'variance');
% ======================== Problem 1 Part (c) =====================================
% Now we consider first three flow measures as linearly independent, we can estimate a constraint matrix using OLS
[eigVecs, ~, ~] = princomp(Fmeas);    % apply PCA to reduce the noise
scores = Fmeas*eigVecs(:,1:3);   % we know that there are 3 independent
Xback = scores*eigVecs(:,1:3)';    % transform back. we did a denoising just now
X = Xback(:,1:3);   % take X as the independent vectors
estdA = [zeros(3,3) -eye(3)];    % initialize estimated A - constraint matrix
ZhatCumulative = zeros(size(Fmeas,1), 3);   % initialize Zhat, predictions of F4, F5 and F6
for nZ=4:6
	Z = Xback(:,nZ);       % measured value
	theta = inv(X'*X)*X'*Z;    % weights
	Zhat = X*theta;    % predicted values
	estdA(nZ-3,1:3) = theta;
	ZhatCumulative(:,nZ-3) = Zhat;
end
disp('The estimated constraint matrix with first three flow measures as independent vectors')
estdA
% maximum of absolute difference of predicted and measured
maxAbsError = max(Xback(:,4:6) - ZhatCumulative);
disp(' maximum absolute error in prediction of F4, F5 and F6 are respectively')
maxAbsError

% ======================== Problem 1 Part (d) =====================================
% The matrix will have the weights of 6 vectors in a vector space of basis 3. 
% this means that 3 of them can be independent (or close to it). So we can find out the correlation 
% coefficients of the matrix and find the least correlated 3 matrices. This will be close to independent vectors.
% So we should choose 3 of those vectors.

% ======================== Problem 1 Part (e) =====================================
% Apply PCA
[eigVecs, scores, eigVals] = princomp(Fmeas);
% select 3 PCs to noise reduction. 3 is selected based on the SRCEE plot
scores = Fmeas*eigVecs(:,1:3);
% Now if we convert it back to initial coordinates, we will get the denoised data since we removed the
% terms curresponding to low variances
FmeasDenoised = scores*eigVecs(:,1:3)';
disp('denoised data of last sample point is ')
FmeasDenoised(1000,:)

% =================================== end =====================================

% save workspace variables to a file for coming problems to use
save('problem1Out.mat');

