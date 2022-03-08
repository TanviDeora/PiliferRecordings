 function [daqoutput, StimulusVariables] = generateLinearChirp(Flow, Fhigh, amp, T, nidaq)

%% time specifications
preT = 1.1; % 1.1 seconds before and after stimulus, intan trigger mode should be set to record 1sec
postT = 1.1;

Fs = nidaq.Rate;
prePts = fix(preT*Fs);
postPts = fix(postT*Fs);
stimPts = T*Fs;

t = 0:1/Fs:(stimPts-1)/Fs; % time

%%
motor_chirp = chirp(t,Flow,T, Fhigh);
motor_chirp = amp*motor_chirp/max(motor_chirp);

preMotor = zeros(prePts, 1)';
postMotor = zeros(postPts, 1)';

motor = [preMotor, motor_chirp, postMotor]';

%%
% add trigger output
trigger_up = ones(length(motor_chirp),1)'*3.3;
trigger = [preMotor, trigger_up, postMotor]';

daqoutput = [motor, trigger];
%%
StimulusVariables.Flow = Flow;
StimulusVariables.Fhigh = Fhigh;
StimulusVariables.amplitude = amp;
StimulusVariables.Time = T;