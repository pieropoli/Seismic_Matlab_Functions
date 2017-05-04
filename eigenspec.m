function [yk,sk] = eigenspec(x,vn,kspec,nf,npts,nfft)

%
% Calculate the eigenspectra 
% yk, and sk
%


xtaper(1:nfft) = 0;
for i = 1:kspec
   xtaper(1:npts)  = x.*vn(:,i);
   yk(:,i) = fft(xtaper);
   sk(:,i) = abs(yk(1:nf,i)).^2;
   xtaper(:) = 0;
end

