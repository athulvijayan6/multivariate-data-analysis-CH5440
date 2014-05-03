%====================================================================================%
% coded by Athul Vijayan ED11B004 on 2nd May 2014
% for Multivariate data analysis assignment 5
%====================================================================================%

% Load image data
% Files are given relative paths. So do not disturb folder structure.
clc;
clear;

% use a denoise filter while loading image
neem1 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem1.tiff'))));   % load image
neem2 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem2.tiff'))));   % load image
neem3 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem3.tiff'))));   % load image
neem4 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem4.tiff'))));   % load image
neem5 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem5.tiff'))));   % load image
neem6 = im2double(medfilt2(rgb2gray(imread('Pictures/Neem/neem6.tiff'))));   % load image

mango1 = im2double(medfilt2(rgb2gray(imread('Pictures/Mango/mango1.tiff'))));  % load image
mango2 = im2double(medfilt2(rgb2gray(imread('Pictures/Mango/mango2.tiff'))));  % load image
mango3 = im2double(medfilt2(rgb2gray(imread('Pictures/Mango/mango3.tiff'))));  % load image
mango4 = im2double(medfilt2(rgb2gray(imread('Pictures/Mango/mango4.tiff'))));  % load image
mango5 = im2double(medfilt2(rgb2gray(imread('Pictures/Mango/mango5.tiff'))));  % load image

banyan1 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan1.tiff'))));
banyan2 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan2.tiff'))));
banyan3 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan3.tiff'))));
banyan4 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan4.tiff'))));
banyan5 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan5.tiff'))));
banyan6 = im2double(medfilt2(rgb2gray(imread('Pictures/banyan/banyan6.tiff'))));

ashoka1 = im2double(medfilt2(rgb2gray(imread('Pictures/ashoka/ashoka1.tiff'))));
ashoka2 = im2double(medfilt2(rgb2gray(imread('Pictures/ashoka/ashoka2.tiff'))));
ashoka3 = im2double(medfilt2(rgb2gray(imread('Pictures/ashoka/ashoka3.tiff'))));
ashoka4 = im2double(medfilt2(rgb2gray(imread('Pictures/ashoka/ashoka4.tiff'))));
ashoka5 = im2double(medfilt2(rgb2gray(imread('Pictures/ashoka/ashoka5.tiff'))));

% Now this is a matrix of size 1755x1276. Each pixel in the image is a feature vector we have.
% another representation of this data can be as a vector.
% In that way we can represent each image as a point in a big dimensional space
% exactly speaking, if we have a vector space having 2239380 (1755x1276)dimensions,
% each image will be a point in that space.
% Now if we apply cluster methods, the points in this space which are similar will be having less euclidean distance
% between them.

% But the issue here is, the dimensions of the space is very big. and its not desirable because of memory concerns
% So we reduce the dimensions/ compress the image using PCA and do clustering after that.
% convert into a vector space
neem1 = neem1(:);	neem3 = neem3(:);	neem5 = neem5(:);
neem2 = neem2(:);	neem4 = neem4(:);	neem6 = neem6(:);

% convert into a vector space
mango1 = mango1(:);	mango3 = mango3(:);	mango5 = mango5(:);
mango2 = mango2(:);	mango4 = mango4(:);

% convert into a vector space
banyan1 = banyan1(:);	banyan3 = banyan3(:);	banyan5 = banyan5(:);
banyan2 = banyan2(:);	banyan4 = banyan4(:);	banyan6 = banyan6(:);

% convert into a vector space
ashoka1 = ashoka1(:);	ashoka3 = ashoka3(:);	ashoka5 = ashoka5(:);
ashoka2 = ashoka2(:);	ashoka4 = ashoka4(:);

% Now we put the training set into a matrix, so that each of this dimension (pixel) is a feature
% and each image is an experiment

% we remove one from each photos for validating our model. the rest is training set
imageMat = [neem1' ; neem2' ; neem3' ; neem4' ; neem5' ; neem6' ; mango1' ; mango2' ; mango3' ; mango4' ; mango5';
			   banyan1' ; banyan2' ; banyan3' ; banyan4' ; banyan5' ; banyan6' ;
			   ashoka1' ; ashoka2' ; ashoka3' ; ashoka4' ; ashoka5'];
% labelMat = []

% Now we apply PCA to this matrix
% Now we clear memory since each variable is very big in size
% clear ('neem1', 'neem2', 'neem3', 'neem4', 'neem5', 'mango1', 'mango2', 'mango3', 'mango4', 'banyan1', banyan2, banyan3, banyan4, 'banyan5')
imageMat = zscore(imageMat);
clearvars -except imageMat;    % save computer memmory by clearing unwanted variables
[PCs, scores, eigVals] = princomp(imageMat,'econ');   %'econ' is used for for a faster algorithm.
clear('eigVals');
% Now scores matrix has the all the images in the reduced dimesion space

% % For validation, we take one image for predicting and others for training the clustering
correctPredictionsCount=0;
for i=1:size(scores,1);
	trainingSet = removerows(scores,i);
	testImage = scores(i,:);
	% now scores has points in reduced dimension. we need to apply cluster analysis to this.
	% scores is input for k-means clustering. here k is 4 since four kinds of images are there
	[label, centroids] = clusterkmeans(trainingSet, 4, 50, 0);
	% Now we predict each left out sample finding least distance to cluster centroids
	for j = 1:4
		distance(i,j) = norm(testImage-centroids(j,:));
	end
	[c,predictedLabel(i)] = min(distance(i,:));

	% to check the cluster number of the testImage by checking cluster number of similar images
	if (i<=6)   % neem
		actualLabel(i) = mode(label(1:5));
	elseif ((i>6) && (i<=11))  % mango
		actualLabel(i) = mode(label(7:10));
	elseif ((i>11) && (i<=17)) %banyan
		actualLabel(i) = mode(label(12:16));
	else  %ashoka
		actualLabel(i) = mode(label(18:end));
	end
	disp([num2str(i),' th image used as test image for validation.'])
	disp(['Actual label of cluster (by checking cluster number of same family of leaf) is ',num2str(actualLabel(i))])
	disp(['And predicted cluster number is ', num2str(predictedLabel(i)), char(10)])
	if actualLabel(i) == predictedLabel(i)
		correctPredictionsCount =correctPredictionsCount + 1;   %keep count of correct number of predications
	end
	clear('c');
end
clear('i', 'j');
disp(['out of 22, correct predictions happened ', num2str(correctPredictionsCount), ' times.'])

