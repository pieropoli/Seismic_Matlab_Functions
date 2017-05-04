%--------------------------------------------------------------------
% QIINV The quadratic Inverse spectrum
%--------------------------------------------------------------------

function [qispec,ds,dds] = qiinv(nfft,nf,tbp,kspec,lambda,vn,yk,wt,spec)

%
% Function to calculate the Quadratic Spectrum using the method 
% developed by Prieto et al. (2007). 
% The first 2 derivatives of the spectrum are estimated and the 
% bias associated with curvature (2nd derivative) is reduced. 
%

if (min(lambda) < 0.9) 
      disp(['Careful, Poor leakage of eigenvalue ', ...
		 num2str(min(lambda))]);
      disp('Value of kspec is too large, revise? *****') 
end

% New frequency sampling in inner bandwidth (-W,W)

%  New inner bandwidth frequency

nxi = 79;

bp = tbp/nfft;		% W bandwidth

dxi = (2.0*bp)/(nxi-1);	% QI freq. sampling

xi = [-bp:dxi:bp];

nfft = nfft + 10*nfft;

if (mod(nfft,2)==0)
   fsamp = [-nfft/2:nfft/2-1]'/(nfft);
else
   fsamp = [-(nfft-1)/2:(nfft-1)/2]'/(nfft-1);
end

for k = 1:kspec
   xk(:,k) = wt(1:nf,k).*yk(1:nf,k);
   Vk(:,k) = fftshift(fft(vn(:,k),nfft));
end

for i = 1:kspec

   Vj1 = interp1(fsamp,real(Vk(:,i)),xi,'pchip');  
   Vj2 = interp1(fsamp,imag(Vk(:,i)),xi,'pchip');  

   Vj(:,i) = 1.0/sqrt(lambda(i)) * complex(Vj1,Vj2);

end

% 
% Create the vectorized Cjk matrix and Pjk matrix { Vj Vk* }
%

L = kspec*kspec;

m = 0;
for j = 1:kspec
   for k = 1:kspec

      m = m + 1;
      C(m,:) = ( conj(xk(:,j)) .* (xk(:,k)) );

      Pk(m,1:nxi) = conj(Vj(:,j)) .* (Vj(:,k));

   end
end

Pk(1:m,1)         = 0.5 * Pk(1:m,1);
Pk(1:m,nxi)       = 0.5 * Pk(1:m,nxi);

%  I use the Chebyshev Polynomial as the expansion basis.

hcte(1:nxi)  = 1.0; 
hk(:,1) = Pk*hcte' * dxi;

hslope(1:nxi) = xi/bp; 
hk(:,2) = Pk*hslope' * dxi; 

hquad(1:nxi) = (2.*((xi/bp).^2) - 1.0);
hk(:,3) = Pk*hquad' * dxi;

hm1 = reshape(hk(:,1),kspec,kspec); 
hm2 = reshape(hk(:,2),kspec,kspec); 
hm3 = reshape(hk(:,3),kspec,kspec); 

if (m ~= L) then 
      error('Error in matrix sizes, stopped ')
end 
n = nxi;
nh = 3;

%
% Begin Least squares solution (QR factorization)
%

[Q,R] = qr(hk);

% Covariance estimate                                                  
ri = R\eye(L);                                                  
covb = real(ri*ri');                                                
   
for i = 1:nf

   btilde = Q' * C(:,i);

   hmodel = R \ btilde;

   cte(i)   = real(hmodel(1));
   slope(i) = -real(hmodel(2));
   quad(i)  = real(hmodel(3));

   sigma2(i) = sum(abs( C(:,i) - hk*real(hmodel) ).^2)/(L-nh) ;

   cte_var(i)   = sigma2(i)*covb(1,1);
   slope_var(i) = sigma2(i)*covb(2,2);
   quad_var(i)  = sigma2(i)*covb(3,3);

end

slope = slope / (bp);
quad  = quad  / (bp.^2);

slope_var = slope_var / (bp.^2);
quad_var = quad_var / (bp.^4);

%  Compute the Quadratic Multitaper
%  Eq. 33 and 34 of Prieto et. al. (2007)

for i = 1:nf

   qicorr = (quad(i).^2)/((quad(i).^2) + quad_var(i) ); 
   qicorr = qicorr * (1/6)*(bp.^2)*quad(i);

   qispec(i) = spec(i) - qicorr;

end

ds  = slope';
dds = quad';

%figure(2)
%ip = [1 4 6];
%subplot(2,1,1)
%plot(xi,real(Vj(:,ip)),'k')
%xlim([-bp bp])
%subplot(2,1,2)
%plot(xi,imag(Vj(:,ip)),'k')
%xlim([-bp bp])

%figure(3)
%plot(xi,hcte)
%hold on
%plot(xi,hslope)
%plot(xi,hquad)
%hold off

%figure(4)
%colormap gray
%subplot(2,3,1)
%pcolor(-abs(real(hm1)))
%caxis([-1 0])
%subplot(2,3,2)
%pcolor(-abs(real(hm2)))
%caxis([-1 0])
%subplot(2,3,3)
%pcolor(-abs(real(hm3)))
%caxis([-1 0])
%subplot(2,3,4)
%pcolor(-abs(imag(hm1)))
%caxis([-1 0])
%subplot(2,3,5)
%pcolor(-abs(imag(hm2)))
%caxis([-1 0])
%subplot(2,3,6)
%pcolor(-abs(imag(hm3)))
%caxis([-1 0])

%figure(5)
%subplot(3,1,1)
%plot(real(cte))
%subplot(3,1,2)
%plot(real(slope))
%subplot(3,1,3)
%plot(real(quad))

return

