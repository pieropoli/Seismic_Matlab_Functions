clear
clc


% eq 5a 5b of http://onlinelibrary.wiley.com/doi/10.1029/2011JB008263/epdf

X = randn(2,10000).*10;
X(:,1)=[mean(X(1,:)) min(X(2,:))];
%X(:,1) = [mean(X(1,:)) mean(X(2,:))];
X0 = X(:,1);
theta = 90;
s = [cosd(theta);sind(theta)];
S0 = 1/0.5;

D = sqrt((X0(1)-X(1,:)).^2 + (X0(2)-X(2,:)).^2);

for ik = 1 : size(X,2)
    d(ik) = abs(dot(s,(X(:,ik)-X0)));

    T(ik) = S0*d(ik);
end
% 
subplot(221)
hold all
plot(d,T,'.')
plot(D,T,'o')
%plot(D,D.*S0(1),'-r')
%plot(D,-D.*S0(1),'-r')

xlabel('distance [km]')
ylabel('time [hours]')

subplot(222)
scatter(X(1,:),X(2,:),50,T,'filled')
hold on
plot(X(1,1),X(2,1),'or')