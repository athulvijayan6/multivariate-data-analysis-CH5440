clear all
clc
% Question 2 part B
% Load data
load 'absorbances_missing.mat'
load 'data1.mat'
i=1
conc = [PureNi; PureCr; PureCo]';
conc = conc ./ repmat(sum(conc,2), 1, 3);

for i=1:100
	[icasig, A, W] = fastica(absorbances,'approach','symm', 'numOfIC', 3, 'verbose', 'off');
    icasig = icasig';
    r = corrcoef([icasig conc]);  % find correlation matrix
    % % find highest correlation between predicted and given spectra. 
    for j=1:3
        ri = r(:,j+3);
        ri(3:end)=0; % we do not want to get the correlation betwwe two given pure species spectra.
        [val(j), index(j)] = max(ri);    % get the maximum correlation corresponding to row
    end
    % if this correlation is high, it means our algorithm did a good job
    % larger errorScore, better the value.
    % We can also find the actual errors by root mean square
    icasig = [icasig(:,index(1)) icasig(:,index(2)) icasig(:,index(3))];   %  rearrange predicted conc matrix with the correlation analysis
    err(i) = rms(rms(conc-icasig));
    % ideally correlation should be 1 since the data represent same data. but it is not practically.
    % error in correlation (deviation from zero) is representation of error in prediction
    title('error in correlation in predicting with 100 initial vectors')
    subplot(3,2,1);
    plot(err);
    title('actual error in predicting with 100 initial vectors')
    hold on
    subplot(3,2,2);
    plot(icasig(:,1));
    title('first pure spectra and its 100 iterations');
    hold on

    subplot(3,2,3);
    plot(icasig(:,2));
    title('second pure spectra and its 100 iterations');
    hold on

    subplot(3,2,4);
    plot(icasig(:,3));
    title('third pure spectra 100 iterations');
    hold on
end

clear('i','j')
subplot(3,2,5);
plot (absorbances-A*icasig');
ylabel('error in ||V - W*H||');
xlabel('iterations')
title('error in predicted absorbance in each nmf updates. they are ~ equal to zero')
disp('best result happened on iteration number')
[val, index] = max(err)

% TWEAKING FASTICA
figure
[icasig2] = fastica(absorbances,'approach','symm', 'numOfIC', 3, 'verbose', 'off','displayMode', 'on', 'g', 'tanh');
title('FASTICA using g(u)=tanh(a1*u)');

figure
[icasig2] = fastica(absorbances,'approach','symm', 'numOfIC', 3, 'verbose', 'off','displayMode', 'on', 'g', 'gauss');
title('FASTICA using g(u)=u*exp(-a2*u^2/2)');

figure
[icasig2] = fastica(absorbances,'approach','symm', 'numOfIC', 3, 'verbose', 'off','displayMode', 'on', 'g', 'skew');
title('FASTICA using g(u)=u^2');