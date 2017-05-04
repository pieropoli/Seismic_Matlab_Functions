function [out,misfit,ind] = InvertSpectra(spec,freq,Fc1,Fc2,ratio)

Modelfit = @(par,x)log10(10^par(1) .* ((1./(1+(x./par(2)).^4).^(1/2))./(1./(1+(x./par(3)).^4).^(1/2))));

freq = 10.^freq;

misfit = ones(length(Fc1),length(Fc2),length(ratio)).*10000;

for if1 = 1 : length(Fc1)
   for if2 = 1 : length(Fc2) 
    for ifr = 1 : length(ratio)
    
       model = Modelfit([ratio(ifr)  Fc1(if1) Fc2(if2)],freq);
        
       misfit(if1,if2,ifr) = sum(abs(spec-model).^2)/(length(spec)*abs(ratio(ifr))); 
       
        
    
    
    end
   end
end


[~,idx] = min(misfit(:));
[i1,i2,i3] = ind2sub(size(misfit),idx);
ind = [i1,i2,i3];
out = [ratio(i3) Fc1(i1) Fc2(i2) ];