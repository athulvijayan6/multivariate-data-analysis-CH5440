function [ label, centroids ] = clusterkmeans( data, k , max_iter, delta_cutoff)
%====================================================================================%
% coded by Athul Vijayan ED11B004 on 2nd May 2014
% for Multivariate data analysis assignment 5
%====================================================================================%

% the function classifies points given as argument to clusters and assign labels to each point
% Label is the cluster number to which a point belongs

% There can be cases when k-means will not converge., in those cases, limiting condition is checked to
% terminate the program.
% The limiting condition of the algorithm are
% maximum iterations -----> can be specified
% delta_cutoff --------> distance between centroids of two consecutive iteration should have 
                       % a euclidean distance above delta_cutoff

% USAGE
% [label, centroids] = clusterkmeans(X, k, max_iter=100, delta_cutoff=0);

% function takes arguments
	% data ------> data matrix. columns are dimensions and rows are points in the dimensional space
	% k -----> number of clusters
	% max_iter (optional)----------> maximum iterations
	% delta_cutoff (optional)--------> distance between centroids in consecutive iterations
% and function returns
	% index  ------> the cluster to which each data point labelled to
	% centroids -----> centroid of final clusters
if nargin ==2
	max_iter = 100;
	delta_cutoff = 0;
elseif nargin == 3
	delta_cutoff =0;
end

[points, dim] = size(data);
if (points<k)
	print ('You need more points than number of clusters ');
	return;
end
% create random centroids
% for initial points we use forgy method
for i=1:k
	centroids(i,:) = data(i,:);   % take 4 random points in the data matrix itself as initial centroids
end

iter_no = 1;
delta = delta_cutoff+10;
lastCentroids = centroids;

while ((iter_no<max_iter) && (delta > delta_cutoff))   % limiting criteria
	for i=1:points    % iterate through points in data for calculating labels
		for j=1:k
			dist(j) = norm(data(i,:) - centroids(j,:));    % find euclidean distance to all centroids
		end
		[C, label(i)] = min(dist);   % label will have the centroid to which every point is included.
	end
	for j=1:k
		centroids(j, :) = mean(data(find(label==j),:));   %find new centroids
	end
	if (iter_no > 1) % from second iteration onwards compute the distance between last two centroids
		delta = norm(lastCentroids - centroids)^2;
	end	
	lastCentroids = centroids;
	iter_no = iter_no + 1; % keep count of iterations
end
% at the end of while loop, the variable centroids will have cluster centroids
% and labels will have points under each cluster



