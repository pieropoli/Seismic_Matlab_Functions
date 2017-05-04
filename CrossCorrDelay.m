function [C,L] = CrossCorrDelay(data)

% This function is the same as xcwfm1xr except that it uses matlab's xcorr
% function and cycles through cross correlations individually instead by
% row. It appears to run somewhat slower.
% 

% Author: Michael West, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date: 2012-04-11 08:15:09 -0800 (Wed, 11 Apr 2012) $
% $Revision: 348 $


% CREATE EMPTY CORRELATION AND LAG MATRICES
C = eye(size(data,1),'single');
L = zeros(size(data,1),'single');


% TIME THE PROCESS
tic;
t0 = cputime;
numcorr = ((size(data,1))^2-size(data,1))/2;
count = 0;


% GET XCORR FUNCTION HANDLE
Hxcorr = @xcorr;


% LOOP THROUGH FIRST WAVEFORM
for i = 1:size(data,1)	
    d1 = data(i,:);
    

	% LOOP THROUGH SECOND WAVEFORM
	for j = (i+1):size(data,1)	
		count = count + 1;	
		d2 = data(j,:);
       
        
        % "shift" allows flexibility in when the waveforms actually start
		%shift = 86400*((d.trig(j)-st2)-(d.trig(i)-st1));
		
		% DO CORRELATION		
		%[corr,l]=xcorr(d1,d2,'coeff');
		[corr,l]=feval(Hxcorr,d1,d2,'coeff');

		[maxval,index] = max(abs(corr));
		C(i,j)=corr(index);
		L(i,j)=l(index) ;%+ shift; % lag in seconds
	
		% SHOW PROGRESS
 		if (mod(count,round(numcorr/4))==0)
			disp([num2str(count) ' of ' num2str(numcorr,'%2.0f') ' complete (' num2str(100*count/numcorr,'%2.0f') '%)']);
		end;

	end;

end;


% FILL LOWER TRIANGULAR PART OF MATRICES
C = C + C' - eye(size(C));
L = L - L';

% 
% % DISPLAY RUN TIMES
% tclock = toc;
% tcpu = cputime-t0;
% disp(['Clock time to complete correlations: ' num2str(tclock,'%5.1f') ' s']);
% disp(['CPU time to complete correlations:   ' num2str(tcpu,'%5.1f') ' s']);