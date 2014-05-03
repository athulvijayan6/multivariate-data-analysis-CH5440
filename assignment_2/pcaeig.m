% Coded by Athul Vijayan
% Roll Number : ED11B004

% Assignment 2, Question 2

function [ W, D ] = pcaeig( X )
    %W = the weight matrix
	%D = the amount of variation represented by each component
	%X = data matrix where
	%rows are repetitions and cols are variables
	[v,d]=eig(cov(X));
	D = diag(d)';
	D = D ./ sum(D); % percent variance accounted for
	W = v;
	% we need to sort the weights by D to put them in descending order
	[y,i]=sort(D); i=fliplr(i);
	W=W(:,i);
	D=D(i);
end

