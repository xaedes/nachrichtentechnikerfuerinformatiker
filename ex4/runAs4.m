function runAs4()
ableitung=false;
randomNumbers=false;
datain=csvread('eurofxref.csv');
for i=0:size(datain,1)-1
    data(size(datain,1)-i)=datain(i+1);
end
for i=1:size(data,2)
    if data(i)>10
        data(i)=data(i)/1000;
    end
end
size(data)

subplot(2,1,1);
plot(data);
if ~randomNumbers
    if ~ableitung
        %autocorrelation
        t=[0:4300];
        acf=@(tau) ac(data,tau);
        acres=arrayfun(acf,t);
        %normieren (optional)
        %acres=acres/max(acres);
        subplot(2,1,2);
        plot(acres);
    else 
        %autocorrelation
        t=[0:4300];
        acf=@(tau) ac(diff(data),tau);
        acres=arrayfun(acf,t);
        %normieren (optional)
        %acres=acres/max(acres);
        subplot(2,1,2);
        plot(acres);
    end
else
    data=rand(500);
    subplot(2,1,1);
    plot(data);
    if ~ableitung
        %autocorrelation
        t=[0:400];
        acf=@(tau) ac(data,tau);
        acres=arrayfun(acf,t);
        %normieren (optional)
        %acres=acres/max(acres);
        subplot(2,1,2);
        plot(acres);
    else 
        %autocorrelation
        t=[0:400];
        acf=@(tau) ac(diff(data),tau);
        acres=arrayfun(acf,t);
        %normieren (optional)
        %acres=acres/max(acres);
        subplot(2,1,2);
        plot(acres);
    end 
end
end
function ret=ac(a,tau)
tau=tau+1;
tmp=a(tau:end);
ret=sum(a(1:end-tau+1).*tmp);
ret=ret;
end