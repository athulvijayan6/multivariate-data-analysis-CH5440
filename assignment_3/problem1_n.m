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

% applying PCA to absorbance matrix will give us orthogonal components which are decorrelated.
[PCs,Score,eigenValues] = princomp(absorbances);
% to verify, if we take variance captured by first three PCs, we can see it is above 91%
sum(eigenValues(1:3,:))/sum(eigenValues)*100
% so, the first three PCs correspond to spectra of pure species.

% Scores matrix is the absorbance data transformed into principle component space.

pureSpectra = PCs(:,1:3);   % is a 151x3 matrix. 
% this pureSpectra is the signals from independent sources in 'Blind Soure seperation'
% spectra of each mixture is linear combination of pureSpectra with weights given in variable conc
%to verify this is a full column rank matrix, (pureSpectra'*pureSpectra) is invertible
inv(pureSpectra'*pureSpectra)
% Now the problem is spectral mixing matrix identification.
%   X'    =    S      A
% 151x26     151x3   3x26

% Here X is the Scores matrix, A is concentration matrix we need to find and S is pureSpectra

% Now by using OLS, we minimize error of predicting spectra of each mixtures.
% It is done by optimizing problem min||X' - SA||  
A = inv(pureSpectra'*pureSpectra)*pureSpectra'*Score';

% So A is the Mixing matrix. since we did not enforce any condition for non-negativity,
% It is totally possible to have negative values in the concentration matrix we got due to errors.
for i=1:26
	for j=1:3
		if(A(j,i)<0)
			A(j,i) = 0;
		end
	end
end
clear ('i','j');

% ------------PART A -------------
% conc = conc-repmat(mean(conc),26,1);
for pcsNumber=1:5   %eigenValues of PCs above 25 are zero.
	% For doing leave-one-sample-out validation,
	% We will leave one out and find pureSpectra using 25 other training set.
	rmseTotal = 0;
	for i = 1:26
		absorbancesTranspose = (removerows(absorbances,i)).';
		[PCsTest,ScoreTest,eigenValuesTest] = princomp(absorbancesTranspose);
		pureSpectraTest = absorbancesTranspose*PCsTest(:,1:pcsNumber);
		leftOutScore = zscore(absorbances(i,:)');%*PCsTest(:,1:pcsNumber);    %transform leftout absorbance data to PCs coordinates
		Atest = inv(pureSpectraTest'*pureSpectraTest)*pureSpectraTest'*leftOutScore;
		for l=1:pcsNumber
			if(Atest(l,1)<0)
				Atest(l,1) = 0;
			end
		end
		%Atest = Atest-repmat(mean(Atest),pcsNumber,1);
		
		if (pcsNumber>3)
			rmse = sqrt(mean((Atest- [conc(i,:),zeros(1,pcsNumber-3)].').^2));
		else
			rmse = sqrt(mean(([Atest;zeros(3-pcsNumber,1)]-conc(i,:).').^2));
		end
		rmseTotal = rmseTotal + rmse;
		rmesMat(pcsNumber,1) = pcsNumber;   %matrix has #PCs Vs RMSE
		rmesMat(pcsNumber,2) = rmse;
	end
	pcVsRmse(pcsNumber,1) = pcsNumber;
	pcVsRmse(pcsNumber,2) = rmseTotal;
end
plot(pcVsRmse(:,2));
clear('i', 'j','pcsNumber');

