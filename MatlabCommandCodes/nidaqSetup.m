function [s] = nidaqSetup()

%% detect and inialize the daq
devices = daqlist("ni");
if isempty(devices)
    disp('No DAQ')
else
    for ind1=1:height(devices)
        compare = strcmp("USB-6229 (BNC)", devices{ind1, 'Model'});
        if compare(1) == 1
            adDevice=devices{ind1,'DeviceID'};
        end
    end    
end


%% Set the current data acquisition session for

s = daq("ni");

% commented the following lines which are setup for the AM systems
% %add 2 input channels to read in ai0: neural trace & ai1: motor position
% addinput(s, adDevice, "ai0", "Voltage");
% addinput(s, adDevice, "ai1", "Voltage");

% set up for the Intan:
%add 1 input channels to read the motor command
addinput(s, adDevice, "ai0", "Voltage");
%add 1 output channel to control motor
addoutput(s,adDevice,"ao0","Voltage");
%add one more output to trigger recordings
addoutput(s, adDevice, "ao1", "Voltage");

Fs = 3.0e4;
s.Rate = Fs;  % Set the sample rate

%%
% move the motor to zero position
% output = 0;
% putdata(ao,output)
% write(s,output)
