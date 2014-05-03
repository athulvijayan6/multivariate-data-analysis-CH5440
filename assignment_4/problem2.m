clear all
clc
% Question 2 part A
% Load data
load 'absorbances_missing.mat'
load 'data1.mat'
i=1
conc = [PureNi; PureCr; PureCo]';
conc = conc ./ repmat(sum(conc,2), 1, 3);
for i=1:100
	[W, H, errorArray] = NMF(absorbances,3);   % each time function is called, different random numbers will be used
	% Now we have spectral data of sources. bith peasured and predicted.
	% In the predicted concentration matrix, we do not know which row corresponding to which
	% element, to solve this we use correlation between vectors. highly correlated pairs should be 
    % actual and predicted spectra from same species.
    H = H';
    r = corrcoef([H conc]);  % find correlation matrix
    % find highest correlation between predicted and given spectra. 
    for j=1:3
    	ri = r(:,j+3);  % row corresponding to jth pure species
    	ri(3:end)=0; % we do not want to get the correlation between two given pure species spectra.
    	[val(j), index(j)] = max(ri);    % get the maximum correlation corresponding to row
    end

    % if this correlation is high, it means our algorithm did a good job
    errorScore(i) = sum(val);    % we define errorScore as sum of max correlation we have for every iteration.
    % larger errorScore, better the value.
    % plot error decrease in each iteration
    % We can also find the actual errors by root mean square
    H = [H(:,index(1)) H(:,index(2)) H(:,index(3))];   %  rearrange predicted conc matrix with the correlation analysis
    err(i) = rms(rms(conc-H));
    subplot(2,2,1)
    plot(errorArray);
    % ideally correlation should be 1 since the data represent same data. but it is not practically.
    % error in correlation (deviation from zero) is representation of error in prediction
    title('error in correlation in predicting with 100 initial vectors with each of the doing 250 multiplication updates.')
    subplot(2,2,2);
    plot(err);
    title('actual error in predicting with 100 initial vectors with each of the doing 250 multiplication updates.')
    hold on
end
clear('i','j')

subplot(2,2,3);
plot (absorbances-W*H');
ylabel('error in ||V - W*H||');
xlabel('iterations')
title('error in predicted absorbance in each nmf updates. they are ~ equal to zero')
subplot(2,2,4);
plot(errorScore);
ylabel('sum of correlation')
xlabel('choice of initial random matrices')
title('sum of correlation Vs choice of initial matrices')
disp('best result happened on iteration number')
[val, index] = min(err)