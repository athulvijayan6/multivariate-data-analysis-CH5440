% @Author: Athul Vijayan
% @Date:   2014-05-10 03:23:11
% @Last Modified by:   Athul Vijayan
% @Last Modified time: 2014-05-10 11:52:21
warning('off');
clear('all');
clc
load('tempData.mat')
temp = specCapacity(:,1);
spec = specCapacity(:,2);
clear('specCapacity');

stdev = std(spec);
temp = temp./std(temp);
spec = spec./std(spec);

d = 10;

rmse = zeros(41,1);  % accumulator for adding PRESS error
for countPC = 1:41
	for k = 1:42
		X = removerows(temp, k);
		Ktest = temp(k, :);
		y = transpose(removerows(spec,k));
		for i = 1:size(X)
			for j=1:size(X)
				K(i,j) = (X(i) * X(j)'+1).^d;  % calculate polynomial Kernel for training set (first 70)
			end
		end
		% Apply PCA
		[U,S,V] = svd(K);   %applyning PCA to K
		Sinverse = inv(S);Sinverse = Sinverse(:,1:countPC);  % PCs are selected
		Vselected = V(:,1:countPC);

		% T matrix in the OLS equation Y = BT. found using the training set
		T = inv(S)*V'*K;    
		% B matrix in the OLS equation Y = BT. found using the training set
		B = y*T'*inv(T*T');
		for m = 1:size(X)
			newK(m) = (X(m) * Ktest'+1).^d;  %kernel corresponding to currently chosen test point
		end
		newT = Sinverse*Vselected'*newK';  % T matrix for current test set
		yhat(k) = B*newT;               % predicted out heat capacity of cold body.
	end
	yhat = yhat./std(yhat);
	rmse(countPC) = rms(spec(k)'-yhat);
end
clear('i', 'j', 'k', 'm')

disp('PCs curresponding to least RMSE is')
[~, nOfPCs] = min(rmse);
nOfPCs

% ======================================== PART B ==================================================

X = temp;
Ktest = [250 ; 500; 1000; 2000; 6000];
Ktest = Ktest./std(Ktest);
y = spec';
for i = 1:size(X)
	for j=1:size(X)
		K(i,j) = (X(i) * X(j)'+1).^d;  % calculate polynomial Kernel for training set (first 70)
	end
end
% Apply PCA
[U,S,V] = svd(K);   %applyning PCA to K
Sinverse = inv(S);Sinverse = Sinverse(:,1:nOfPCs);  % PCs are selected
Vselected = V(:,1:nOfPCs);

% T matrix in the OLS equation Y = BT. found using the training set
T = inv(S)*V'*K;    
% B matrix in the OLS equation Y = BT. found using the training set
B = y*T'*inv(T*T');
for k=1:size(Ktest)
	for m = 1:size(X)
		newK(m) = (X(m) * Ktest(k)'+1).^d;  %kernel corresponding to currently chosen test point
	end
	newT = Sinverse*Vselected'*newK';  % T matrix for current test set
	yhat(k) = B*newT;               % predicted out heat capacity of cold body.
end
yhat = yhat./std(yhat); % scale the data like y since they are normalized

disp('yhat contains predictions for 250 ; 500; 1000; 2000; 6000 correspondingly')
yhat