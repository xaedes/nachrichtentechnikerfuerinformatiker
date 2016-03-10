function runAs5()
[signala,fsa]=audioread('0421.wav');
num=4;%number of coefficients, ->need last n+1 samples
numSamples=5000;%first n samples to process
size(signala)
maxErr=0.001;
signal=signala(:,1);%fix dimensions
signal=[zeros(1,num+1) signal'];%transpose audio signal, add leading zeros
encodedData=encode(signal,num,numSamples, 1);
decodedData=decode(encodedData,num,numSamples, 3);
signal(num+2:num+numSamples+1)
encodedData
decodedData
for i=num+2:numSamples+num+1
    if abs(signal(i) - decodedData(i-num-1))<maxErr
        sameSignalAfterDecoding(i-num-1)=true;
    end
end
if sameSignalAfterDecoding == ones(size(sameSignalAfterDecoding))
    sameSignalAfterDecoding=true
end
end
function ret=encode(signal,num, numSamples, plotArea)
res(1:numSamples+num+2)=0;
err(1:numSamples+num+2)=0;
for i=num+2:num+1+numSamples
    w=updateCoeffs(signal,i-1,num);%update from last n+1 signal elements to predict current
%    w
    res(i)=calcNext(signal,i,w);
    err(i)=signal(i)-res(i);
end
%signal(1:numSamples+num+1)
%err
subplot(2,2,plotArea);
plot([num+2:numSamples+num+1],signal(num+2:numSamples+num+1),[num+2:numSamples+num+1],res(num+2:numSamples+num+1));
subplot(2,2,plotArea+1);
plot([num+2:numSamples+num+1],err(num+2:numSamples+num+1));
ret=err(num+2:end);
end
function ret=decode(encodedData,num, numSamples, plotArea)
res(1:numSamples)=0;
err=[zeros(1,num+1) encodedData];
signal(1:numSamples+num+1)=0;
for i=num+2:numSamples+num+1
    w=updateCoeffs(signal,i-1,num);
%    w
    res(i)=calcNext(signal,i,w);
    signal(i)=res(i)+err(i);
end
%signal
%err
subplot(2,2,plotArea);
plot([num+2:numSamples+num+1],signal(num+2:numSamples+num+1),[num+2:numSamples+num+1],res(num+2:numSamples+num+1));
subplot(2,2,plotArea+1);
plot([num+2:numSamples+num+1],err(num+2:numSamples+num+1));
ret=signal(num+2:end);
end
function ret=calcError(calc, real)
    ret=calc-real;
end
function ret=updateCoeffs(signal,t,num)
acf=@(tau) ac(signal(t-num:t),tau);
R=zeros(num,num);
for j=0:num-1 %matrix bis num-1, -2 wegen indices
    for i=j:num-1
        R(i+1,j+1)=acf(i-j);%R(0)...R(p-1)
    end
    for i=0:j-1
        R(i+1,j+1)=acf(j-i);
    end
    r(j+1)=acf(j+1);%r=(R(1)...R(p))
end
ret=inv(R)*transpose(r);
%ret=fliplr(w);
if signal(t-num:t) == zeros(size(signal(t-num:t)))
    ret=zeros(1,num);
end
end
function ret=calcNext(signal,t,w)
ret=0;
for i=1:size(w,2)
    ret=ret+w(i)*signal(t-i);
end
end
function ret=ac(a,tau)
%ret=xcorr(a,'unbiased');
%ret=ret(tau+1);
tau=tau+1;%matlab indices
tmp=a(tau:end);
ret=sum(a(1:end-tau+1).*tmp);
end