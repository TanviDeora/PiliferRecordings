function [daqoutput, StimulusVariables] = generateSumSines(amp, T, rep, nidaq)
%% time specifications
preT = 1.1; % 1.1 seconds before and after stimulus, intan trigger mode should be set to record 1sec
postT = 1.1;

Fs = nidaq.Rate;
prePts = fix(preT*Fs);
postPts = fix(postT*Fs);
stimPts = T*Fs;

t = 0:1/Fs:(stimPts-1)/Fs; % time

%%
% I used PrimeNumGen function (Freq=PrimeNumGen(150,5)) to generate 5 random frequencies 
    
freq =[11 71 109 113 127]; % number of cycles per second for 5 different sines   
   
Sin1 = amp*sin(2*pi*freq(1)*t); % total number of cycles is duration_sine*f_sine
Sin2 = amp*sin(2*pi*freq(2)*t);
Sin3 = amp*sin(2*pi*freq(3)*t);
Sin4 = amp*sin(2*pi*freq(4)*t);
Sin5 = amp*sin(2*pi*freq(5)*t);
sine = Sin1 + Sin2 + Sin3 + Sin4 + Sin5;     

preMotor = zeros(prePts, 1)';
postMotor = zeros(postPts, 1)';

motor=[preMotor, sine, postMotor]';
new_motor= repmat(motor,rep,1);
%%
% add trigger output
trigger_up = ones(length(sine),1)'*3.3;
trigger = [preMotor, trigger_up, postMotor]';
new_trigger = repmat(trigger, rep,1);
    
daqoutput = [new_motor, new_trigger];
%%
StimulusVariables.repeats = rep;
StimulusVariables.amplitude = amp;
StimulusVariables.Time = T;