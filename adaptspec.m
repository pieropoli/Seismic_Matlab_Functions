%--------------------------------------------------------------------
% Adaptspec
%--------------------------------------------------------------------

function [spec,se,wt] = adaptspec(nfft,nf,kspec,lambda,sk)

%
% Function to calculate the adaptive multitaper spectrum. 
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

rerr = 9.5e-7;

sbar = (sk(:,1)+sk(:,2))/2;

for j = 1:1000

   slast = sbar;

   for k = 1:kspec
      wt(:,k) = sqev(k)*sbar ./( evalu(k)*sbar + bk(k));
      wt(:,k) = min(wt(:,k),1.0);
      skw(:,k) = wt(:,k).^2 .* sk(:,k);   
   end

   sbar = sum(skw,2) ./ sum(wt.^2, 2);
	    
   if (j==1000) then
      spec = sbar;
      disp(['adaptspec did not converge, rerr = ',  ...
	      num2str(max(abs((sbar-slast)/(sbar+slast)))),num2str(rerr)])
      continue
   end
   if (max(abs((sbar-slast)/(sbar+slast))) > rerr)
      continue
   end
            
   spec = sbar;
   break
	 
end 

for i = 1:nf
   wt_dofs(i,:) = wt(i,:)./sqrt(sum(wt(i,:).^2)/kspec);
end

wt_dofs = min(wt_dofs,1.0);

se = 2.0 * sum(wt_dofs.^2, 2); 

return

