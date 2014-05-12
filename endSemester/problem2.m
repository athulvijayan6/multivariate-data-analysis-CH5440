% @Author: Athul Vijayan
% @Date:   2014-05-09 20:40:27
% @Last Modified by:   Athul Vijayan
% @Last Modified time: 2014-05-10 11:37:43
clear('all');
clc
load ('WDNdata.mat')

% =====================================Problem 2 ======================================

Fmeas = [Fmeas(:,1) Fmeas(:,3:5)];
% Apply PCA
[eigVecs, scores, eigVals] = princomp(Fmeas);
% Now if we plot SCREE plot
for i=1:size(eigVals)
	explained(i) = eigVals(i)/sum(eigVals);
end
figure
pareto(explained)
title('SCREE Plot')
xlabel('Principal Component')
ylabel('Variance Explained (%)')
disp([' It is evident from the SCREE Plot that first two principle '...  
	'components are much dominant than others in capturing variance'])


scores = Fmeas*eigVecs(:,1:2);
Fmeas = scores*eigVecs(:,1:2)';
% Now if we convert it back to initial coordinates, we will get the denoised data since we removed the
% terms curresponding to low variances
% Now we find the constraint matrix. For that we assume that the two components having largest variances
% are independent measurements and we use OLS to predict the other two as weighted sum of these
% with this we can get the constraint matrix
% Now we consider first three flow measures as linearly independent, we can estimate a constraint matrix using OLS
X = Fmeas(:,1:3);
Z = Fmeas(:,4);       % measured value
theta = inv(X'*X)*X'*Z;    % weights
Zhat = X*theta;    % predicted values
estdA = [theta ; -1];
disp('The estimated constraint matrix with first two flow measures as independent vectors')
estdA
% Now we have to find true constraint matrix from last problem loaded in the beginning
% Since we do not have F2 and F5, the constraint matrix of measured variables is
A = [1 -1 -1 -1];    %from the eqn F1-F2-F3-F4=0
% rowpaceA = colspace(A')
% rowspaceEstdA = colspace(estdA)
angle = subspace(A, estdA)
