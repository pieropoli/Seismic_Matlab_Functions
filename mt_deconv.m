function [tfun,sratio,s1,s2,freq] = mt_deconv(xi,xj,ni,nj,dt,tbp,kspec)

%
%  Generate a deconvolution between two time series from 
%  the yk's and the weights of the usual multitaper spectrum
%  estimation. 
%  The code more or less follows the paper
%  Receiver Functions from multiple-taper spectral corre-
%  lation estimates
%  J. Park and V. Levin., BSSA 90#6 1507-1520
%
%  It also uses the code based on dual frequency I created in
%  GA Prieto, Vernon, FL , Masters, G, and Thomson, DJ (2005), 
%  Multitaper Wigner-Ville Spectrum for Detecting Dispersive 
%  Signals from Earthquake Records, Proceedings of the 
%  Thirty-Ninth Asilomar Conference on Signals, Systems, and 
%  Computers, Pacific Grove, CA., pp 938-941. 
%
%  INPUT
%	xi, xj  real, data series with npts points
%	ni, nj  real, noise data series with npts points
%	dt	real, sampling rate of time series
%	tbp	the time-bandwidth product
%	kspec	integer, number of tapers to use
%	iad 	Adaptive (1 - adaptive, 0 - Constant weight)
%	
%  OPTIONAL INPUT
%
%	demean	        if present, force complex TF to be demeaned.
%	fmax		maximum frequency for lowpass cosine filter
%
%  OPTIONAL OUTPUT
%	tfun(nfft)	real, time domain deconvolve series
%	sratio(nf,2)	real, spectral ratio of two spectra: 1rst column is
%	X/Y ; 2nd column is XY*/YY* 
%	s1(nf,2)	real vector with power spectrum of first series (signal ,
%	1rst column) and noise (2nd column)
%	s2(nf,2)	real vector with power spectrum of second series and noise
%	freq(nf)	real vector with frequency bins
%
%  Modified from F90 code mt_deconv.f90 
%
%	German Prieto
%	June 18 2014
%
%	*******************************************************************
%
%
%  calls
%	mtspec, ifft4, sym_fft
% 

%********************************************************************

if (nargin>8)
   error('MT_DECONV - Number of inputs is too large')
end
if (nargin<5)
   dt = 1.0;
end
if (nargin<6)
   tbp = 3.5;
end
if (nargin<7)
   kspec = 2*tbp-2;
end
if (nargin<8)
   iad = 0;
end

ndat1 = length(xi);
ndat2 = length(xj);
ndat3 = length(ni);
ndat4 = length(nj);
 
npts = ndat1;
if (ndat2~=npts | ndat3~=npts | ndat4~=npts) 
   error('MT_DECONV - Size of vectors need to be the same')
end

%---------------------------------------------
% Length time series and frequency
% 	Always padding for deconvolution

nfft = 2*npts+1;
[freq,nf,df] = create_fvector(xi,nfft,dt);

%---------------------------------------
% Remove mean of signal

xvar  = var(xi);
x1    = detrend(xi,'constant');
n1    = detrend(ni,'constant');
x2    = detrend(xj,'constant');
n2    = detrend(nj,'constant');
x1 = x1(:);
x2 = x2(:);
n1 = n1(:);
n2 = n2(:);

%----------------------------------------
% Get DPSS

[vn,lambda] = dpss(npts,tbp,kspec); % vn is the taper, lambda is the eigenvalue

%----------------------------------------
% Get eigenspectra ('single-taper spectrum estimate' for the different tapers k : y1k(:,k) )

y1k = eigenspec(x1,vn,kspec,nf,npts,nfft);
y2k = eigenspec(x2,vn,kspec,nf,npts,nfft);
n1k = eigenspec(n1,vn,kspec,nf,npts,nfft);
n2k = eigenspec(n2,vn,kspec,nf,npts,nfft);

%----------------------------------------
% Adaptive weighted spectrum
%	Only eigenvalue weights (i.e. weighted by the eigenvalue)

[spec1,spec2,wt] = avgspec2(nfft,nf,kspec,lambda,y1k,y2k);
wt = wt/sqrt(sum(wt.^2));

for i = 1:kspec
   dy1k(:,i) = wt(i)*y1k(:,i);
   dy2k(:,i) = wt(i)*y2k(:,i);
   dn1k(:,i) = wt(i)*n1k(:,i);
   dn2k(:,i) = wt(i)*n2k(:,i);
end

%------------------------------------------------------------
% Performing the deconvolution

eps = 0.00001 * sum(spec2)/real(nf);
for i=1:nfft
   spec1(i)  = sum(abs(dy1k(i,:)).^2);
   spec2(i)  = sum(abs(dy2k(i,:)).^2); % ce spec1 (resp spec2) est similaire à celui renvoyé par avspec2 (<=> Eq 3 Prieto 2009)
   nspec1(i) = sum(abs(dn1k(i,:)).^2);
   nspec2(i) = sum(abs(dn2k(i,:)).^2);
   xspec(i)  = sum ( dy1k(i,:) .* conj(dy2k(i,:)) ); % (X.Y*)/(Y.Y*)     
   xspec(i)  = xspec(i) / (spec2(i)+eps);
end

%-------------------------------------------------------------
% Save spectral domain
sratio(:,1) = sqrt(spec1(1:nf)./(spec2(1:nf)+eps)); 
s1(:,1)     = spec1(1:nf);
s2(:,1)     = spec2(1:nf);
s1(:,2)     = nspec1(1:nf);
s2(:,2)     = nspec2(1:nf);

%-------------------------------------------------------------
%  Get the time domain deconvolution, correct units

tfun        = ifftshift(ifft(xspec));
tfun        = tfun(:);
sratio(:,2) = abs(xspec(1:nf));

% Need to have units correct. 
return

