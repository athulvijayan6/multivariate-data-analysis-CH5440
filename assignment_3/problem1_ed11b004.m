%##############################################################################################
%
%Submitted by Athul Vijayan, ED11B004. Assignment3. Question 1.
%
%##############################################################################################

echo off
load('data1.mat');
load('conc.mat');

% make absorbance values >=0
for i=1:151
	for j=1:26
		if(absorbances(j,i)<0)
			absorbances(j,i) = 0;
		end
	end
end
clear ('i','j');
%According to Beer-Lambert’s law the absorbance spectra of a dilute
%mixture is a linear (weighted) combination of the pure component spectra
%with the weights corresponding to the concentrations of the species in the
%mixture.

% ------------PART A -------------
conc = zscore(conc);%-repmat(mean(conc),26,1);
for pcsNumber=1:25   %eigenValues of PCs above 25 are zero.
	% For doing leave-one-sample-out validation,
	% We will leave one out and find pureSpectra using 25 other training set.
	rmseTotal = 0;
	for i = 1:26
		absorbancesTranspose = zscore(removerows(absorbances,i).');
		% applying PCA to absorbance matrix will give us orthogonal components which are decorrelated.
		[U,S,V] = svd(absorbancesTranspose);
		D = diag(S)'; D = D.^2 ./ sum(D.^2);
		pureSpectraTest = zscore(absorbancesTranspose)*V(:,1:pcsNumber);

		% Now the problem is spectral mixing matrix identification.
		%   X'    =    S      A
		% 151x26     151x3   3x26

		% Here X is the Scores matrix, A is concentration matrix we need to find and S is pureSpectra
		leftOutScore = zscore(absorbances(i,:)');%transform leftout absorbance data to PCs coordinates
		% Now by using OLS, we minimize error of predicting spectra of each mixtures.
		% It is done by optimizing problem min||X' - SA||
		Atest = inv(pureSpectraTest'*pureSpectraTest)*pureSpectraTest'*leftOutScore;
		
		% So A is the Mixing matrix. since we did not enforce any condition for non-negativity,
		% It is totally possible to have negative values in the concentration matrix we got due to errors.
		for l=1:pcsNumber
			if(Atest(l,1)<0)
				Atest(l,1) = 0;
			end
		end
		
		if (pcsNumber>3)
			rmse = sqrt(mean((Atest- [conc(i,:),zeros(1,pcsNumber-3)].').^2));
		else
			rmse = sqrt(mean(([Atest;zeros(3-pcsNumber,1)]-conc(i,:).').^2));
		end
		rmseTotal = rmseTotal + rmse;
		rmseMat(i,1) = pcsNumber;   %matrix has #PCs Vs RMSE
		rmseMat(i,2) = rmse;
	end
	pcVsRmse(pcsNumber,1) = rmseTotal/26;
end
plot(pcVsRmse);
title('RMSE error Vs Number of PCs');
clear('i', 'j','pcsNumber');

% PART B--------------
% Theoretically,  3 PCs should be correct, since there are only 3 pure species of components
% But the data was showing otherwise due to measurement errors etc..
% In my case the error was minimized at PCs ~ 6. 
% and after that it looked as if error was constant (and value nearly equal to zero).

