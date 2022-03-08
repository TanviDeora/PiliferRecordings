function [freq, psdx] = GeneratePowerSpectralDensity(Fs, waveform, makeFigure)

N = length(waveform);
xdft = fft(waveform);

%one sided spectrum
psdx = abs(xdft(1:N/2+1));
%normalize the amplitude
psdx = 2/N*psdx;
freq = 0:Fs/N:Fs/2;

if makeFigure
    figure
    plot(freq,10*log10(psdx))
    grid on
    title('Periodogram Using FFT')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
end