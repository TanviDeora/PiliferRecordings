%%
clear all
clc

%% setting up daq
nidaq = nidaqSetup();

%% Generating WhiteNoise
Fc = 300;
amp = 2;
T = 10;
repeatNoise = 1;
numRepeat = 30;
% generate your stimulus pattern
[daqoutput, StimulusVariables] = generateWhiteNoise(Fc,amp,T,repeatNoise,numRepeat,nidaq);

%% Generating Sine sequence
% Fhigh = 100;
% amp = 2;
% cycles = 10; 
% stepsHz = 10;
% Flow = 1;
% 
% [daqoutput, StimulusVariables] = generateSequenceOfSines(Fhigh, amp, cycles, stepsHz, nidaq, Flow);

%% sending data to motor
% write into the daq
inScanData = readwrite(nidaq,daqoutput,"OutputFormat","Matrix");

%% saving your data
% filename =  'm17_sineSeq_1.mat';
% save(filename, 'StimulusVariables', 'inScanData')
