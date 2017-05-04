function [freq,nf,df] = create_fvector(x,nfft,dt)

if (isreal(x))
   if (mod(nfft,2)==0)
      nf = nfft/2 + 1;
   else
      nf = (nfft+1)/2;
   end
   fnyq	= 0.5/dt;
   df 	= fnyq/(nf-1);

   freq = [0:df:fnyq]';

else   % for complex variables
   nf     = nfft;
   fnyq	  = 1./dt;
   fnyq2  = fnyq/2;
   df 	  = fnyq/(nf);

   if (mod(nfft,2)==0)
      freq = [0:df:fnyq2 -(fnyq2-df):df:-df]';
   else
      freq = [0:df:fnyq2 -fnyq2:df:-df]';
   end
 
end

return

