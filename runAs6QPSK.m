function runAs6()
    fc=600000;%carrier frequency
    bc=9000;%carrier bandwidth
    fs=3000;%signal frequency
    fgr=4000;%rx low pass frequency
    fa=6000000;%sampling rate
    noise=true;%add noise
    snr=-15;%db
    useMLFilter=false;%use matlab generated filters (freq. dependend)
    data=generateData(122)%random bits to generate
    %data=[1 1 0 1 0 0 1 0]
    mappedData=(mapData(data));
    filteredDataStream1=gtFilter(mappedData(1,:),fc,fs);
    filteredDataStream2=gtFilter(mappedData(2,:),fc,fs);
    %simplification for calling
    cosFunc=@(dat) cosModulation(dat,fc,fs,fa);
    sinFunc=@(dat) sinModulation(dat,fc,fs,fa);
    %index counter for loop
    num=0;
    for i=1:fa/fs+1:size(filteredDataStream1,2)*fa/fs;
        num=num+1;
        modulatedDataCos(round(i,0):round(i+fa/fs,0))=cosFunc(filteredDataStream1(num));
        modulatedDataSin(round(i,0):round(i+fa/fs,0))=sinFunc(filteredDataStream2(num));
    end
    %add cos+sin streams
    modulatedStream=modulatedDataSin+modulatedDataCos;
    subplot(3,2,1);%plot sin&cos&combined signal before transmission
    plot([1:size(modulatedDataCos,2)],modulatedDataCos,[1:size(modulatedDataCos,2)], modulatedDataSin,[1:size(modulatedDataCos,2)], modulatedStream,[size(modulatedDataCos,2)/size(mappedData,2)/2:size(modulatedDataCos,2)/size(mappedData,2):size(modulatedDataCos,2)],mappedData(2,:),[size(modulatedDataCos,2)/size(mappedData,2)/2:size(modulatedDataCos,2)/size(mappedData,2):size(modulatedDataCos,2)],mappedData(1,:))
    title('sin,cos, combined and binary data');
    %run transmission channel filter
    afterTransmission=kanalFkt(modulatedStream,fc,fs,fa,bc,useMLFilter);
    if noise
        afterTransmission=awgn(afterTransmission,snr,'measured','db');
    end
    subplot(2,2,2);%after transmission
    plot(afterTransmission);
    title('signal after transmission (noise and band pass)');
    %2*cos multiplication
    %simplification for calling
    cos2Func=@(dat) cos2Modulation(dat,fc,fs,fa);
    sin2Func=@(dat) sin2Modulation(dat,fc,fs,fa);
    %index counter for loop
    for i=1:size(afterTransmission,2);
        demodSin(i)=sin2Func(afterTransmission(i));
        demodCos(i)=cos2Func(afterTransmission(i));
    end
    %filter received data
    stream1=grFilter(demodCos,fa,fs, fgr,useMLFilter);
    stream2=grFilter(demodSin,fa,fs,fgr,useMLFilter);
    %calculate output
    %res=decodeSignal(stream1,stream2,fa,fc,fs);
    for i=1:2:size(data,2)
        if stream1(round((i/2)*fa/fs,0))<0
            result1(i)=0;
        else
            result1(i)=1;
        end
        %stream2(round(+fs/2+i*fs,0))
        if stream2(round((i/2)*fa/fs,0))<0
            result2(i+1)=0;
        else
            result2(i+1)=1;
        end
    end
    %reassemble vectors
    temp = [result1(1:2:end), result2(2:2:end)];
    for i=2:2:size(temp,2)
        result(i-1)=temp(i/2);
        result(i)=temp(size(temp,2)/2+i/2);
    end
    result
    %plot demod data, filtered Data
    subplot(3,2,3);
    title('sin');
    plot([1:size(demodCos,2)],demodCos,[1:size(demodCos,2)], stream1);
    title('demodulated cos stream and filter'); 
    %plot([1:size(modulatedDataCos,2)],modulatedDataCos-cos(2*pi*fc*[0:size(modulatedDataCos,2)-1]/fa),[1:size(modulatedDataCos,2)],cos(2*pi*fc*[0:size(modulatedDataCos,2)-1]/fa))
    subplot(2,2,4);
    title('cos');
    %plot()
    plot([1:size(demodCos,2)],demodSin,[1:size(demodCos,2)], stream2);
    title('demodulated sin stream and filter');
    %plot output data
    subplot(3,2,5);
    title('data');
    plot([1:size(result,2)/2],result1(1:2:end),[1:size(result2,2)/2], result2(2:2:end));
    title('restored binary data');
    dataMatch=result==data;
    dM=true;
    numNoMatch=0;
    for i=1:size(dataMatch,2)
        if dataMatch(i)==false
            dM=false;
            numNoMatch=numNoMatch+1;
        end
    end
    dataMatch=dM
    numNoMatch
end
function ret=generateData(num)
    ret=randi([0 1],1,num);
end
function ret=mapData(data)
    for i=1:size(data,2)
        if data(i)==0
            ret(i)=-1;
        else
            ret(i)=1;
        end
    end
    tmp=ret;
    ret=reshape(tmp,2,length(tmp)/2);
end
function ret=getBit(signal,fa,fs,fc)
    if mean(signal)>0
        ret=1;
    else
        ret=0;
    end
end
function ret=decodeSignal(signal1,signal2,fa,fs,fc)
%calculate output
    for i=0:2:(size(signal1,2))/fa*fs-4
        ((i/2)+1)*fa/fs
        ((i/2)+2)*fa/fs
        signal1(round(((i/2)+1)*fa/fs,0):round(((i/2)+2)*fa/fs,0))
        result1(i+1)=getBit(signal1(round(((i/2)+1)*fa/fs,0):round(((i/2)+2)*fa/fs,0)));
        result2(i/2+1)=getBit(signal2(round(((i/2)+1)*fa/fs,0):round(((i/2)+2)*fa/fs,0)));
    end
    %reassemble vectors
    temp = [result1(2:2:end), result2(1:2:end)];
    for i=2:2:size(temp,2)
        result(i-1)=temp(i/2);
        result(i)=temp(size(temp,2)/2+i/2);
    end
    ret=result
end
function ret=gtFilter(signal,fc,fs)
    ret=signal;
end
function ret=grFilter(signal,fa,fs,fgr,mlfilter)
    if ~mlfilter
        ret=lowpassAs6(signal,fa,fgr);
    else
        ret=lowpassAs6butter(signal,fa,fgr);
    end
end
function ret=cos2Modulation(signal, fc, fs, fabtast)
    persistent t;
    if size(t)==size([])
        t=0;
    end
    ret=signal*cos(2*pi*fc*t/fabtast)*2;%fix index float errors
    t=(t+1);
end
function ret=cosModulation(signal, fc, fs, fabtast)
    persistent t1;
    if size(t1)==size([])
        t1=0;
    end
    num=0;
    for i=0:1/fabtast:1/fs
        num=num+1;
        ret(num)=signal*cos(2*pi*fc*t1/fabtast);
        t1=(t1+1);
    end
end
function ret=sinModulation(signal, fc, fs, fabtast)
    persistent t2;
    if size(t2)==size([])
        t2=0;
    end
    num=0;
    for i=0:1/fabtast:1/fs
        num=num+1;
        ret(num)=-signal*sin(2*pi*fc*t2/fabtast);%fix index float errors
        t2=(t2+1);
    end
end
function ret=sin2Modulation(signal, fc, fs, fabtast)
    persistent t3;
    if size(t3)==size([])
        t3=0;
    end
    ret=-signal*sin(2*pi*fc*t3/fabtast)*2;
    t3=(t3+1);
end
function ret=kanalFkt(signal,fc,fbandwidth,fa,bc,mlfilter)
        ret=fftFilterBP(signal,fa,fc+bc,fc-bc,mlfilter);
end
function ret=fftFilterBP(data,fa,fupper, flower,mlfilter)%bandpass filter
  %ret=data;
  if mlfilter
    ret=bandpassAs6(data, fa, flower, fupper);%matlabfilter
  else
     ret=bandpassAs6Ideal(data,fa,flower,fupper);%ideal fft cut
  end
end