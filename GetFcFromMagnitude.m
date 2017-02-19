function Fc = GetFcFromMagnitude(mag,stressdrop,k)

MoEstimate =(10.^((3/2).*mag+16.1).*1e-7);


Fc=(((stressdrop./(MoEstimate.*8.5))).^(1/3)).*(3000) ;