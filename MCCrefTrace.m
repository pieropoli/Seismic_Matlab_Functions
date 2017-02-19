function [DataAlign,corrCoeff,delay] = MCCrefTrace(s,ref)
warning off
tmpSTF=s;

for y = 1 : size(tmpSTF,1)


    [ctmp,~] = xcorr(tmpSTF(y,:),ref,'coeff');   
    [mxcora,mxcorab] = max(ctmp);nxcor = length(ctmp);
    
   
    
    delay(y) = mxcorab - ((nxcor -1)/2 +1);
    
    corrCoeff(y) = mxcora;clear tm cstore

    clear c_tmp

end


for id = 1 : size(corrCoeff,1)
    
   DT = -delay(y) ;
    
    % align the data
    if DT > 0
    datatmp = zeros(size(s(id,:)));
    datatmp(DT+1:end)=s(id,1:end-DT);
    
    elseif DT < 0
    dt = abs(DT);    
    datatmp = zeros(size(s(id,:)));
    datatmp(1:end-dt)=s(id,dt+1:end);
    
    elseif DT==0 
    datatmp = s(id,:);
    end
    
   DataAlign(id,:) = datatmp; clear datatmp
    
    
end
