%##############################################################################################
%
%Submitted by Athul Vijayan, ED11B004. Assignment 3. Question 2.
%
%##############################################################################################
warning('off');
load('hexdata.mat')

% Lets seperate the data
coldOutTemp = hexdata(:,6)'; %this is what we need to predict
X = hexdata(:,1:5);  % this is our input matrix
% The coluns of above matrix X = [x1, x2, x3, x4, x5] are
 % x1 -------> flow rate of hot
 % x2 -------> flow rate of cold
 % x3 -------> inlet temperature hot
 % x4 -------> inlet temperature cold
 % x5 -------> outlet temperature of hot
% from the model, we know output is not a linear combination of input vectors
% so we convert the input variables X into a kernel space with phi(x).

for d =1:5   %iterator for d
	for countPC = 1:70
		for i = 1:70
			for j=1:70
				K(i,j) = (X(i,:) * X(j,:)'+1).^d;  % calculate Kernel for training set (first 70)
			end
		end
		clear('i','j');
		[U,S,V] = svd(K);   %applyning PCA to K
		Sinverse = inv(S);Sinverse = Sinverse(:,1:countPC);  % PCs are selected
		Vselected = V(:,1:countPC);

		% T matrix in the OLS equation Y = BT. found using the training set
		T = inv(S)*V'*K;    
		% B matrix in the OLS equation Y = BT. found using the training set
		B = coldOutTemp(:,1:70)*T'*inv(T*T');

		PRESS = 0;  % accumulator for adding PRESS error
		for testPoint=71:100
			for i = 1:70
					newK(i,1) = (X(i,:) * X(testPoint,:)'+1).^d;  %kernel corresponding to currently chosen test point
			end
			newT = Sinverse*Vselected'*newK;  % T matrix for current test set
			yhat = B*newT;               % predicted out temperature of cold body.
			PRESS = PRESS + (coldOutTemp(:,testPoint)-yhat)^2;   %calculate PRESS statistic error by E = sum((y-yhat)^2)
		end
		% PRESStable holds the data we iterated. 
		PRESStable((d-1)*70+countPC,1) = d;  % The first column contains degree of polynomial kernel for the calculated PRESS 
		PRESStable((d-1)*70+countPC,2) = countPC; %The second column contains number of PCs for the a particular degree
		PRESStable((d-1)*70+countPC,3) = PRESS;  % calculated PRESS for the above two combination
		clear('i');
	end
end

% plot average PRESS for each degree
plot([sum(PRESStable(1:70,3))/70 ; sum(PRESStable(71:140,3))/70; sum(PRESStable(141:210,3))/70; sum(PRESStable(211:280,3))/70; sum(PRESStable(281:350,3))/70])
title('PRESS Vs degree');
hold on;

% at d = 4, the PRESS error seemed to be minimal. so plot PCs Vs PRESS at degree= 4
plot(PRESStable(211:280,:))   %plot of PRESS Vs number of PCs
title('PRESS Vs number of PCs')