function runAs3()
   [y,fsaudio]=audioread('demo2.wav'); % piano2 test demo2
   fs=fsaudio/2;
   H=((0:1:fs).*0).';%to column vector (audio), 1 entry per Hz
   fupper=2000;
   flower=0001;
   bandpass=true;
   genericFilter=true;
   y=y(:,1);%mono only
   subplot(2,2,1);
   plot(y);
   title('inputfile time domain');
   %sound(y,fs);
   Y=fft(y);
   size(Y)
    %%fftplot sound
    P2 = abs(Y/(size(y,1)-1)); %normalize, fft passt fläche nicht an
    P1 = P2(1:(size(y,1)-1)/2+1); %first half of spectrum
    P1(2:end-1) = 2*P1(2:end-1); %spiegelung fällt weg, werte anpassen. nicht für index1, da dieser bei 0 und nicht gespiegelt
    f = (fs)*(0:((size(y,1)-1)/2))/(size(y,1)-1);
    subplot(2,2,2)
    plot(f,P1);
    title('input frequency domain');
    %%plot
  fstep=f(end)/size(f,2);
  if ~genericFilter
      if bandpass
        Y(round(fupper/fstep,0):end)=0;
        Y(1:round(flower/fstep,0))=0;
      else
        Y(round(flower/fstep,0):round(fupper/fstep,0))=0;
      end
  else
      for i=1:fs-1
        Y(i)=H(1+round(i*fstep,0))*Y(i);
      end
  end
  y2=real(ifft(Y));
  subplot(2,2,3);
  plot(y2);
  title('output time domain');
  
    %%fftplot filtered sound
    P2 = abs(Y/(size(y,1)-1)); %normalize, fft passt fläche nicht an
    P1 = P2(1:(size(y,1)-1)/2+1); %first half of spectrum
    P1(2:end-1) = 2*P1(2:end-1); %spiegelung fällt weg, werte anpassen. nicht für index1, da dieser bei 0 und nicht gespiegelt
    f = (fs)*(0:((size(y,1)-1)/2))/(size(y,1)-1);
    subplot(2,2,4)
    plot(f,P1);
    title('output frequency domain');
    %%plot
  sound(y2,fsaudio);
end

function runNyquist()
    t=0:0.001:1;
    resolution=1000;
    Fs=10;
    Fa=20;
    sampleDuration=1;
    sig=sin(pi*2*Fs*t);
    sampling(1:size(t,2))=0;
    for i=1:round((size(t,2))*Fa/resolution,0)
        sampling(resolution/Fa*i)=1;
        sampling(resolution/Fa*i+1)=1;
    end
    subplot(3,2,1)
    plot(t,sig);
    
    subplot(3,2,2)
    plot(t,sampling);
    
    A=fft(sampling);
    S=fft(sig);
    
    %%fftplot signal
    P2 = abs(S/(size(t,2)-1)); %normalize, fft passt fläche nicht an
    P1 = P2(1:(size(t,2)-1)/2+1); %first half of spectrum
    P1(2:end-1) = 2*P1(2:end-1); %spiegelung fällt weg, werte anpassen. nicht für index1, da dieser bei 0 und nicht gespiegelt
    f = (resolution)*(0:((size(t,2)-1)/2))/(size(t,2)-1);
    subplot(3,2,3)
    plot(f,P1);
    %%plot
    %%fftplot sampling
    P2 = abs(A/(size(t,2)-1)); %normalize, fft passt fläche nicht an
    P1 = P2(1:(size(t,2)-1)/2+1); %first half of spectrum
    P1(2:end-1) = 2*P1(2:end-1); %spiegelung fällt weg, werte anpassen. nicht für index1, da dieser bei 0 und nicht gespiegelt
    f = (resolution)*(0:((size(t,2)-1)/2))/(size(t,2)-1);
    subplot(3,2,4)
    plot(f,P1);
    %%plot
    
    falt=conv(sig,sampling);
    subplot(3,2,5);
    plot(falt);
    %%fftplot sampling*signal
    P2 = abs(fft(conv(sampling,sig))/(size(t,2)-1)); %normalize, fft passt fläche nicht an
    P1 = P2(1:(size(t,2)-1)/2+1); %first half of spectrum
    P1(2:end-1) = 2*P1(2:end-1); %spiegelung fällt weg, werte anpassen. nicht für index1, da dieser bei 0 und nicht gespiegelt
    f = (resolution)*(0:((size(t,2)-1)/2))/(size(t,2)-1);
    subplot(3,2,6)
    plot(f,P1);
    %%plot
end