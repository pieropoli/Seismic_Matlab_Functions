%--------------------------------------------------------------------
% Average Multitaper spectrum, with eigenvalue weights
%--------------------------------------------------------------------

function [spec,se,wt] = avgspec(nfft,nf,kspec,lambda,yk,sk);

%
% Function to calculate the adaptive multitaper spectrum, using 
% only the eigenvalues of the DPSS  
%

% Initialize some variables

df = 1./(nfft-1);	% Assume unit sampling


if (nfft == nf) 	% Complex multitaper
   varsk = sum(sk,1)*df;
else
   varsk = (sk(1,:) + sk(nf,:) + 2.*sum(sk(2:nf-1,:),1) ) * df;
end

dvar   = sum(varsk)/(kspec);

evalu  = lambda;
evalu1 = 1.-lambda;
bk     = dvar  * evalu1;
sqev   = sqrt(evalu);

% Iterative procedure

for k = 1:kspec
   wt(k)  = lambda(k);
   wt(k)  = min(wt(k),1.0);
   skw(:,k) = wt(k).^2 .* sk(:,k);   
end

sbar = sum(skw,2) ./ sum(wt.^2);
	    
spec = sbar;
	 
for i = 1:nf
   wt_dofs(i,:) = wt(:)./sqrt(sum(wt(:).^2)/kspec);
end

wt_dofs = min(wt_dofs,1.0);

se = 2.0 * sum(wt_dofs.^2, 2); 

return


