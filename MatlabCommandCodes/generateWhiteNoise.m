function [daqoutput, StimulusVariables] = generateWhiteNoise(Fc,amp,T,repeatNoise, numRepeat, nidaqsession)

% Tanvi modifying Ali's code to generate white noise
% 
% Inputs:
%   Fc:    cutoff frequency for noise, Hz
%   amp:   amplitude, 0-10V (Generally don't use amplitudes close to 10)
%   T:     duration, sec
%   repeatNoise: specifies whether to use new noise seed for every epoch
%          (1: repeats same noise sequence; 0: uses random noise sequence each trial)
%
% Outputs:
%   Stim: motor command stimulus
%   time: time vector, sec
 
% nidaq.outputSingleScan([0 1.65 0 0 0]) % move to particular location

%% %% time specifications
preT = 1.1; % 1.1 seconds before and after stimulus, intan trigger mode should be set to record 1sec
postT = 1.1;

%Rate = 2.5e3;
Fs = nidaqsession.Rate;
prePts = fix(preT*Fs);
postPts = fix(postT*Fs);
stimPts = fix(T*Fs);

preMotor = zeros(prePts, 1);
postMotor = zeros(postPts, 1);
t = 0:1/Fs:(stimPts-1)/Fs; % time
%%
[b,a] = butter(4,Fc/(Fs/2));

%%
if repeatNoise
    seed = 0;
else
    rng('shuffle')
    seed = round(rand*1e8);
end
rng(seed) % set random number generator to begin with this seed
%%
motor_whitenoise = randn(size(t))';
motor_whitenoise = filter(b,a,motor_whitenoise);
%%
motor_whitenoise = amp*motor_whitenoise/max(motor_whitenoise);
motor = [preMotor; motor_whitenoise; postMotor]';
%%
% motorScaled = motor-min(motor);
% motorScaled = 1.5*motor/10 + 1.5;

%%

%if ~isempty(fID)
%    fprintf(fID, '%s %s %f %f %f %d \n',datetime('now'),'noise', [Fc, amp, T, seed]);
%end
%%

% add trigger output
trigger_up = ones(stimPts,1)*3.3;
trigger = [preMotor; trigger_up; postMotor]';

%%
daqoutput1=repmat(motor', numRepeat, 1);
daqoutput2=repmat(trigger', numRepeat, 1);
daqoutput = [daqoutput1, daqoutput2];

StimulusVariables.CutoffFreq = Fc;
StimulusVariables.amplitude = amp;
StimulusVariables.duration = T;
StimulusVariables.seed = seed;
StimulusVariables.numRepeat = numRepeat;

%nidaq.IsContinuous = false;
%nidaq.queueOutputData([motor motorScaled timingPulse*2 timingPulseLaser timingPulse]);
%[data, time] = nidaq.startForeground();

%nidaq.outputSingleScan([0 1.65 0 0 0]) % move back to zeros at end of trial