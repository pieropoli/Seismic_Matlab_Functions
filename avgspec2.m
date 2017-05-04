function [spec1,spec2,wt] = avgspec2(nfft,nf,kspec,lambda,y1k,y2k);

%--------------------------------------------------------------------
% Average Multitaper spectrum, with eigenvalue weights
%	For two equal length signals
%--------------------------------------------------------------------
%
% Function to calculate the adaptive multitaper spectrum, using 
% only the eigenvalues of the DPSS  
%

for k = 1:kspec
   wt(k)  = lambda(k);
   wt(k)  = min(wt(k),1.0);
   skw1(:,k) = wt(k).^2 .* abs(y1k(:,k)).^2;   
   skw2(:,k) = wt(k).^2 .* abs(y2k(:,k)).^2;  
end

spec1 = sum(skw1,2) ./ sum(wt.^2);
spec2 = sum(skw2,2) ./ sum(wt.^2);
	    
% No degrees of freedom calculated here. 
 
return


