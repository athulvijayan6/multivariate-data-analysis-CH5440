% @Author: Athul Vijayan
% @Date:   2014-05-10 08:27:15
% @Last Modified by:   Athul Vijayan
% @Last Modified time: 2014-05-10 10:05:01
clear('all');
clc

load('Fisher.mat')

iris = sortrows(iris,1);    % data is arranged by cluster groups. so that last 50 should belong to one particular cluster
features = [iris(1:33,2:4) ;iris(51:83,2:4) ;iris(101:133,2:4)];  %To include all cluster points in training set
testSet = [iris(34:50,2:4); iris(84:100,2:4); iris(134:150,2:4)];
actualLabels = iris(:,1);

% now scores has points in reduced dimension. we need to apply cluster analysis to this.
% scores is input for k-means clustering. here k is 4 since four kinds of images are there
% function clusterkmeans is there in same folder.
	% arguments are
	% arg1 ---> no. of clusters
	% arg2 ---> maximum iterations
	% arg3 ---> cutoff distance, if distance between last two consecutive centroids is less than this function
	          % assumes divergence

%================================== PART A =========================================================
[label, centroids] = clusterkmeans(features, 3, 50, 0);
% Now we predict each left out sample finding least distance to cluster centroids
for j = 1:51
	for i=1:3
		distance(j,i) = norm(testSet(j,:)-centroids(i,:));
	end
	[~,predictedLabel(j)] = min(distance(j,:));
end
wrongPredictions =0;
disp('Now for testing accuracy we predict cluster of the next 17 test sets ')
disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(1:17)))])
% it is 3 in this case
disp('Number of wrong predictions out of 17')
wrongPredictions = wrongPredictions + nnz(predictedLabel(1:17) - mode(predictedLabel(1:17))*ones(1,17));

disp('Now for testing accuracy we predict cluster of the next 17 test sets ')
disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(18:34)))])
% it is 3 in this case
disp('Number of wrong predictions out of 17')
wrongPredictions = wrongPredictions + nnz(predictedLabel(18:34) - mode(predictedLabel(18:34))*ones(1,17));

disp('Now for testing accuracy we predict cluster of the next 50 test sets ')
disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(35:51)))])
% it is 3 in this case
disp('Number of wrong predictions out of 17')
wrongPredictions = wrongPredictions + nnz(predictedLabel(35:51) - mode(predictedLabel(35:51))*ones(1,17));

disp(' Total number of error predictions')
wrongPredictions
%================================== PART B =========================================================
[eigVecs, ~, ~] = princomp(features);
for nPCs = 1:3
	wrongPredictions = 0;
	scores = features*eigVecs(:,1:nPCs);
	testSetScores = testSet*eigVecs(:,1:nPCs);
	[label, centroids] = clusterkmeans(scores, 3, 50, 0);
	% Now we predict each left out sample finding least distance to cluster centroids
	for j = 1:50
		for i=1:3
			distance(j,i) = norm(testSetScores(j,:)-centroids(i,:));
		end
		[~,predictedLabel(j)] = min(distance(j,:));
	end
	disp ([' ================For number of PCs ', num2str(nPCs),'============================='])
	disp('Now for testing accuracy we predict cluster of the next 17 test sets ')
	disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(1:17)))])
	% it is 3 in this case
	disp('Number of wrong predictions out of 17')
	wrongPredictions = wrongPredictions + nnz(predictedLabel(1:17) - mode(predictedLabel(1:17))*ones(1,17));

	disp('Now for testing accuracy we predict cluster of the next 17 test sets ')
	disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(18:34)))])
	% it is 3 in this case
	disp('Number of wrong predictions out of 17')
	wrongPredictions = wrongPredictions + nnz(predictedLabel(18:34) - mode(predictedLabel(18:34))*ones(1,17));

	disp('Now for testing accuracy we predict cluster of the next 50 test sets ')
	disp(['most frequent cluster number predicted in sample 34-50 samples is ', num2str(mode(predictedLabel(35:51)))])
	% it is 3 in this case
	disp('Number of wrong predictions out of 17')
	wrongPredictions = wrongPredictions + nnz(predictedLabel(35:51) - mode(predictedLabel(35:51))*ones(1,17));

	disp('Total number of bad predictions')
	wrongPredictions
	wrongVsPCs(nPCs) = wrongPredictions;
end
[~, optimumPCs] = min(wrongVsPCs);

disp(['Optimum Number of PCs is ', num2str(optimumPCs), ' or more']);


