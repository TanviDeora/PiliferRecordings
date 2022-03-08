function [daqoutput, StimulusVariables] = generateSequenceOfSines(Fhigh, amp, cycles, stepsHz, nidaq, Flow)

%% set the lowest Frequency to 1
if nargin < 6
    Flow = 1;
end

%% time specifications
preT = 1.1; % % 1.1 seconds before and after stimulus, intan trigger mode should be set to record 1sec
postT = 1.1;
inbetT = 1.1;

Fs = nidaq.Rate;
prePts = fix(preT*Fs);
postPts = fix(postT*Fs);
inbetPts = fix(inbetT*Fs);

%stimPts = T*Fs;

%t = 0:1/Fs:(stimPts-1)/Fs; % time

%%

gap = zeros(inbetPts, 1)';
Freq = 0:stepsHz:Fhigh;
if Flow < stepsHz
    Freq(1) = Flow;
else
    Freq = Freq(2:end);
end

motor_sine = [];
trigger_up = [];
for ff=Freq
    t = 0:1/Fs:((cycles/ff)*Fs-1)/Fs;
    sine = amp*sin(2*pi*ff*t);
    t = ones(size(t))*3.3;
    motor_sine = [motor_sine, sine, gap];
    trigger_up = [trigger_up, t, gap];
end

preMotor = zeros(prePts,1)';
postMotor = zeros(postPts, 1)';
motor = [preMotor, motor_sine, postMotor]';
trigger = [preMotor, trigger_up, postMotor]';
%%
% add trigger output
% trigger_up = ones(length(motor_sine),1)'*3.3;
% trigger = [preMotor, trigger_up, postMotor]';

daqoutput = [motor, trigger];
%%
StimulusVariables.Flow = Flow;
StimulusVariables.Fhigh = Fhigh;
StimulusVariables.amplitude = amp;
StimulusVariables.NumCycles = cycles;
StimulusVariables.StepSize = stepsHz;
