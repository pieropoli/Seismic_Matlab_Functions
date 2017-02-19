function [m] = inverse_radon_freq(d,dt,h,q,N,flow,fhigh,mu,sol)
%INVERSE_RADON_FREQ: Inverse linear or parabolic Radon transform. 
%                    Frequency domain alg.
%
%  [m] = inverse_radon_freq(d,dt,h,q,N,flow,fhigh,mu,sol)
% 
%  IN   d:     seismic traces   
%       dt:    sampling in sec
%       h(nh): offset or position of traces in meters
%       q(nq): ray parameters  if N=1
%              residual moveout at far offset if N=2
%       N:     N=1 Linear tau-p  
%              N=2 Parabolic tau-p
%       flow:  freq.  where the inversion starts in HZ (> 0Hz)
%       fhigh: freq.  where the inversion ends in HZ (< Nyquist) 
%       mu:    regularization parameter 
%       sol:   sol='ls' least-squares solution
%              sol='adj' adjoint
%
%  OUT  m:     the linear or parabolic tau-p panel
%

 [nt,nh] = size(d);
 nq = max(size(q));

 if N==2; h=h/max(abs(h));end;  
 nfft = 2*(2^nextpow2(nt));
 
 D = fft(d,nfft,1);
 M = zeros(nfft,nq);
 i = sqrt(-1);

 ilow  = floor(flow*dt*nfft)+1; 
 if ilow < 2; ilow=2; end;
 ihigh = floor(fhigh*dt*nfft)+1;
 if ihigh > floor(nfft/2)+1; ihigh=floor(nfft/2)+1; end

 Q = eye(nq)*nh;

 ilow = max(ilow,2);

 for ifreq=ilow:ihigh

  f = 2.*pi*(ifreq-1)/nfft/dt;
  L = exp(i*f*(h.^N)'*q); 
  y = D(ifreq,:)';
  xa = L'*y;
  A = L'*L + mu*Q;

 if isequal(sol,'ls');  
  x  =  A\xa; 
 end; 

 if isequal(sol,'adj');  
  x  =  xa; 
 end

 M(ifreq,:) = x';
 M(nfft+2-ifreq,:) = conj(x)';

end

 M(nfft/2+1,:) = zeros(1,nq);
 m = real(ifft(M,[],1));
 m = m(1:nt,:);
return

