function [spec,freq,sk,yk,se] = mtspec(x,dt,tbp,kspec,method,pad)

%
%  Calculate the multitaper spectral estimate of time series x
%
%
%  Input
%
%	x(npts) -	real, data vector
%	dt	- 	real, sampling rate of the time series x 
%                       [1.0 sps - default]
%	tbp	-	real, the time-bandwidth product (NW) 
%                       [4.0 - default]
%	kspec	- 	integer, number of tapers to use in the estimation 
%                       [2*tbp-1 - default]
%       method  -       0 - Constant; 1 - Adaptive, 2 - Quadratic 
%                       [0 - default]
%       pad     - 	Choose if zero-padding is desired. 0 - no pad
% 			[0 - default]
%  Output
%
%	spec		real vector with the adaptive estimated spectrum
%	freq		real vector with frequency bins
%	sk		eigenspectra (yk**2)
%   	yk 		eigencoefficients
%	se 		number of degrees of freedom for each frequency bin


%
%  TO DO 
% 	Confidence intervals
%	Lines, and line removal
%	Other stuff
%
%  Optional Input
%
%       rshape		Perform F-test for lines, and reshape spectrum.
%			If rshape=1, then don't put the lines back 
%			(but keep units correct) 
% 	fcrit   	The threshold probability for the F test
%
%  Optional Output
%
%	err	jackknife 95% confidence interval
%	wt	array containing the ne weights for kspec eigenspectra 
%		normalized so that the sum of squares over
%           	the kspec eigenspectra is one
%	fstat	F statistics for single line


%------------------------------------
% Check input/Outputs

if (nargin > 6)
   error('MTSPEC - Too many input arguments')
end
if (nargin < 2)
   dt = 1.0;
end
if (nargin < 3)
   tbp = 4.0;
end
if (nargin < 4)
   kspec = floor(2*tbp)-1;
end
if (nargin < 5)
   method = 0;
end
if (nargin < 6)
   pad = 0;
end

if (nargout > 5)
   error('Too many output arguments')
end

%------------------------------------
% Length time series and frequency

x = x(:);
npts = length(x);
nfft = npts;
if (pad~=0)
   nfft = 2*npts+1;
end
[freq,nf,df] = create_fvector(x,nfft,dt);

%---------------------------------------
% Remove mean of signal

xmean = mean(x);
xvar  = var(x);
x2    = detrend(x,'constant');

%----------------------------------------
% Get DPSS

[vn,lambda] = dpss(npts,tbp,kspec);

%----------------------------------------
% Get eigenspectra 

[yk,sk] = eigenspec(x2,vn,kspec,nf,npts,nfft);


%----------------------------------------
% Adaptive weighted spectrum

if (method==0)
   [spec,se,wt] = avgspec(nfft,nf,kspec,lambda,yk,sk);
else
   [spec,se,wt] = adaptspec(nfft,nf,kspec,lambda,sk);
end


%----------------------------------------
% Jackknife spectrum
%
% !!!!!!!!! TO DO !!!!!!!!!
%
%
%----------------------------------------
% The Quadratic Inverse problem

if (method==2)
   [spec,ds,dds] = qiinv(npts,nf,tbp,kspec,lambda,vn,yk,wt,spec);
end


%----------------------------------------
%  Keep power relative to variance
%       double power in positive frequencies

if (isreal(x))
   spec(2:nf-1) = 2.d0 * spec(2:nf-1);
end

sscal = sum(spec);
sscal = xvar/(sscal*df);

spec = sscal * spec;

%-----------------------------------------
% Change to vertical vector

if (size(spec,1)<size(spec,2))
   spec = spec';
end

return



