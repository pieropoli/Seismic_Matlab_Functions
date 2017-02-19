function [DataAlign,corrCoeff,delay,id] = MccAlignment2(s)
warning off
tmpSTF=s;
corrCoeff=zeros(size(tmpSTF,1),size(tmpSTF,1));delay=corrCoeff;
id=zeros(size(tmpSTF,1),size(tmpSTF,1),2);
for y = 1 : size(tmpSTF,1)
    for x = 1 : size(tmpSTF,1)
    id(y,x,:) = [y x];
    c_tmp = xcorr(tmpSTF(y,:),tmpSTF(x,:),'coeff');   
    
    if isnan(sum(c_tmp)) == 0
    
    tm1 = c_tmp((c_tmp==max(c_tmp)));
    %tm2 = c_tmp((c_tmp==min(c_tmp)));   
    
    
    
    TM = tm1(1);% tm2(1)];
    
    
    cstore=find(abs(TM)==max(abs(TM)));
    dtl=find(TM==c_tmp);
    delay(y,x) = dtl(1);
    
    corrCoeff(y,x) = TM;clear tm cstore

    clear c_tmp
    
    else
    delay(y,x) = 0;
    
    corrCoeff(y,x) = 0;clear tm cstore   
        
    end
    
    end
end


for id = 1 : size(corrCoeff,1)
    
   DT = delay(1,1) - mean(delay(id,:)) ;
    
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


delay=delay-delay(1,1);