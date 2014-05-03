function [W, H, errorArray] = NMF(V, r)
%Calculates NMF
%   solves V = W*H by constraining all elements in all V, W and H to be non negative
% V = n x m (n is dimensions and m is number of samples of data)
% W = n x r (weight matrix)
% H = r x m (source matrix)
% r = Number of sources

% We use euclidean distance between predicted and actual absorbances as cost function
% ||A-B||^2. this is lower bound by zero and is optimal when A=B.

% make all components of V non negative
V(V<0)=0;

% Initiate Random W and H
[n,m]=size(V);
W = rand(n, r);
H = rand(r, m);
maxIterations = 250;

% multiplicative update
for iterator = 1:maxIterations
	% update W with eucledean distance minimization
    W = W .* (V * H')./(W*H*H' + eps); % eps is to avoid division by zero
    W = W ./ repmat(sum(W,1), n, 1);  % Normalize W
    
    %update H with eucledean distance minimization
    H = H .* (W' * V)./(W'*W*H + eps);  % eps is to avoid division by zero
    errorArray(iterator) = norm(V-W*H,'fro');
end
return
end