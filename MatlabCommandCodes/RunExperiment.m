%%
clear all
clc
%% setting up daq
nidaq = nidaqSetup();

%% get filename
name = input('Input Filename:','s');
date = datestr(now,'yyyy-mm-dd_HH-MM');
filename = strcat(name,'_',date,'.mat');

% select directory
selpath = uigetdir('../PiliferRecordings/','Select the directory to save file');

%% Generating WhiteNoise
Fc = 300;
amp = 4;
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
% % generate your stimulus pattern
% [daqoutput, StimulusVariables] = generateSequenceOfSines(Fhigh, amp, cycles, stepsHz, nidaq, Flow);
%% ensure motor output is less than 5V

if max(daqoutput(:,1)) >= 5
    disp 'motor amplitude is set to equal or higher than 5. The code will exit without running motor!'
else
    % sending data to motor
    % read and write into the daq
    inScanData = readwrite(nidaq,daqoutput,"OutputFormat","Matrix");
    
    % saving your data
    save(strcat(selpath,'/', filename), 'StimulusVariables', 'inScanData')
end
