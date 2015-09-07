%%%% normzlize data

function D=normalizeMy(Data)

if size(Data,1)==1
norm=max(abs(Data));
D=Data./norm;
else
    for i=1:size(Data,1)
        norm(i,:)=max(abs(Data(i,:)));
            D(i,:)=Data(i,:)./norm(i,:);
%             check=sum(D(i,1:end));
%             
%             if isnan(check)==1
%               D(i,:)=0;
%             end
    end
    
end