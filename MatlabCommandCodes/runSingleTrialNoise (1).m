function [data, time] = runSingleTrialNoise(nidaq,fID,Fc,amp,T,laser,repeatNoise)
% [data, time] = runSingleTrialNoise(nidaq,fID,Fc,amp,T,laser,repeatNoise)
%
% Inputs:
%   nidaq: data acquisition session; run [nidaq, fID] = nidaqSetup();
%   fID:   file identifier for day's experiment logs, created by nidaqSetup();
%   Fc:    cutoff frequency for noise, Hz
%   amp:   amplitude, 0-10V (Generally don't use amplitudes close to 10)
%   T:     duration, sec
%   laser: 0 or 1, whether or not to have laser on during trial
%   repeatNoise: specifies whether to use new noise seed for every epoch
%          (1: repeats same noise sequence; 0: uses random noise sequence each trial)
%
% Outputs:
%    data: acquired data, with columns:
%      ai0: motor command (to motor)
%      ai21: motor readout
%   time: time vector, sec
 
%%%%%%%%
% add pre and post points
%%%%%%%%%%%%%


preT = 0.5;
postT = 0.5;

Fs = nidaq.Rate;
prePts = preT*Fs;
postPts = postT*Fs;
stimPts = T*Fs;

t = 0:1/Fs:(prePts+stimPts+postPts-1)/Fs; % time

[b,a] = butter(4,Fc/(Fs/2));

if repeatNoise
    seed = 0;
else
    rng('shuffle')
    seed = round(rand*1e8);
end
rng(seed) % set random number generator to begin with this seed
motor = randn(size(t))';
motor = filter(b,a,motor);
motor = amp*motor/max(motor);
motor(1:prePts) = 0;
motor(end-postPts+1:end) = 0;

% motorScaled = motor-min(motor);
motorScaled = 1.5*motor/10 + 1.5;

timingPulse = zeros(size(t))'; 
timingPulse(prePts+1:prePts+stimPts) = 1;

if laser
    timingPulseLaser = timingPulse*3;
else
    timingPulseLaser = zeros(size(timingPulse));
end

if ~isempty(fID)
    fprintf(fID, '%s %s %f %f %f %d %d \n',datetime('now'),'noise', [Fc, amp, T, laser, seed]);
end

nidaq.IsContinuous = false;
nidaq.queueOutputData([motor motorScaled timingPulse*2 timingPulseLaser timingPulse]);
[data, time] = nidaq.startForeground();

nidaq.outputSingleScan([0 1.65 0 0 0]) % move back to zeros at end of trial