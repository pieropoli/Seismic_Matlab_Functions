function [Fc,r] = GetFcFromMagnitude(mag,stressdrop)

MoEstimate =(10.^((3/2).*mag+16.1).*1e-7);


Fc=(((stressdrop./(MoEstimate.*8.5))).^(1/3)).*(2500) ;

r = nthroot(MoEstimate./stressdrop*6/17,3);