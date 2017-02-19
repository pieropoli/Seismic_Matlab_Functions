function [d]=forward_radon_freq(m,dt,h,p,N,flow,fhigh)
%FORWARD_RADON_FREQ: Forward linear and parabolic Radon transform.
%                    Freq. domain algorithm
%
%  [d] = forward_radon_freq(m,dt,h,p,N,flow,fhigh);
%
%  IN   m:     the Radon panel, a matrix m(nt,np)
%       dt:    sampling in sec
%       h(nh): offset or position of traces in mts
%       p(np): ray parameter  to retrieve if N=1
%              curvature of the parabola if N=2
%       N:     N=1 linear tau-p
%              N=2 parabolic tau-p
%       flow:  min freq. in Hz
%       fhigh: max freq. in Hz
%
%  OUT  d:     data
%



[nt,nq] = size(m);
nh = length(h);

 if N==2;  
   h=(h/max(abs(h))).^2; 
 end;   

 nfft = 2*(2^nextpow2(nt));

 M = fft(m,nfft,1);
 D = zeros(nfft,nh);
 i = sqrt(-1);

 ilow  = floor(flow*dt*nfft)+1; 
 if ilow < 1; ilow=1; end;
 ihigh = floor(fhigh*dt*nfft)+1;
 if ihigh > floor(nfft/2)+1; ihigh = floor(nfft/2)+1; end
 
 for ifreq=ilow:ihigh
  f = 2.*pi*(ifreq-1)/nfft/dt;
  L = exp(i*f*(h'*p  ));
  x = M(ifreq,:)';
  y = L * x; 
  D(ifreq,:) = y';
  D(nfft+2-ifreq,:) = conj(y)';
 end

 D(nfft/2+1,:) = zeros(1,nh);
 d = real(ifft(D,[],1));
 d = d(1:nt,:);

return;



