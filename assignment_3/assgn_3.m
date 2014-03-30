load data1.mat;%loading the file containing absorbance value
load conc.mat ;%loading the file containing concentration values
% making absorbance value>=0
for i = 1:26
    for j = 1:151
        if absorbances(i,j)<0
            absorbances(i,j)=0;
        end   
    end
end 
% From Beer lamberts law
%Building calibration model by performing PCA on absorbance data.
%inbuilt matlab function which performs PCA on absorbances & returns PCC(principal component coefficients)
[PCC,SCORE,eigenvalues] = princomp(absorbances);
var=sum(eigenvalues(1:3,1))/sum(eigenvalues);%variance corresponding to first 3 eigen vectors
%var = 93.05%.Hence we can use first 3 eigen vectors.
purecompspectra = PCC(:,1:3);%takes first 3 principal components
%Model that we have is of the form linear mixing model - X=Sa
% X - Score'-151X26 ; S-purecompspectra-151X3 ; A-concentration
% A is to be obtained through OLS.
 A=inv(purecompspectra'*purecompspectra)*(purecompspectra'*SCORE');
 A=A';
 %coefficient resulting from the above computation doesnot satisfy non-negativity condition
 %Ideally all values should be positive, hence to nullify the error to some
 %extend we set the negative values to zero. 
 for i = 1:26
    for j = 1:3
        if A(i,j)<0
            A(i,j)=0;
        end   
   end
end 
% Using leave-one-sample-out validation to find quality of linear calibration model
% leave one sample out validation and finding purecompspectra by taking remaing 25 as training set.
rmse1=0;
for i = 1:26
[PCCtest,SCOREtest,eigenvaluestest] = princomp(removerows(absorbances,i));
purecompspectratest = PCCtest(:,1:3);
leftOutScore = absorbances(i,:)*PCCtest;    % transform leftout absorbance data to PCs coordinates
Atest = (purecompspectratest'*purecompspectratest)\(purecompspectratest'*leftOutScore');
% Setting the negative values to zero.
for i = 1:26
        if A(i,1)<0
            A(i,1)=0;
        end   
end 
rmse1 = rmse1 + rms(Atest-conc(i,:)');
end
% a part
% choose the number of PC's
% From 14th PC , eigen value becomes zero. 
% Hence we just need to iterate till 13 PC.
rmse=0;
for j=1:26
    for i=1:26
      [PCCtest,SCOREtest,eigenvaluestest] = princomp(removerows(absorbances,i));
      purecompspectratest = PCCtest(:,1:j);
      leftOutScore = absorbances(i,:)*PCCtest;    %transform leftout absorbance data to PCs coordinates
      Atest = inv(purecompspectratest'*purecompspectratest)*purecompspectratest'*leftOutScore';
          for l = 1:j
            if Atest(l,1)<0
               Atest(l,1)=0;
            end   
          end 
      if j<3
          k=j;
      else
          k=3;
      end
      rmse = rmse + rms(Atest(1:k,1)-conc(i,1:k)');
      %if j>3
       %   rmse=rmse+rms(Atest(4:j,1));
      %end      
    end
   RMSE(j)=rmse;
   rmse=0;
end
    
plot(RMSE,'*');% plot of rmse values for different species concentrations for different choices of number of PC's.
% The total RMSE Error is rmse
% a> RMSE matrix gives the error values for different species concentrations for different PC's
% b>
