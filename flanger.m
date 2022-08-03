% Code for Flanging Generation
% With the help of LFO, input audio signal is delayed by either 0-3, 0-10, 0-15 ms

clc;
clear all;
close all;

% Defining the input and output files for reading and writing the audio
input_file = 'drums.wav';
output_file = 'flanger_output.wav';

% Reading the input audio file
[x, FS] = audioread(input_file);
sound(x, FS);
pause(6)

% Defining the maximum delay in time and samples for the flanger
max_time = 0.001;                                                          % 1 ms
max_samp = round(max_time * FS);                                           % For example, 1ms * 11KHz = 11 samples 

rate = 1;                                                                  % Frequency of the LFO, here taken as 1 Hz

t = 1:length(x);                                                           % Discrete time for the sinusoidal signal
sig = (sin(2*pi*(rate/FS)*t))';                                            % Defining the LFO signal

subplot(212)
plot(t, sig)
axis([0 2.73e5 -1 1])
xlabel('Discrete Time')
ylabel('Amplitude')
title('LFO Sinusoidal Signal')

% Defining the output signal
y = zeros(size(x));

y(1:max_samp,:)=x(1:max_samp,:);
mod_amp = 0.7;                                                             % Modified Amplitude of the signal

for i = max_samp + 1 : length(x)
    delay = ceil(abs(sig(i)) * max_samp); 
    y(i,:) = x(i,:) + mod_amp * (x(i - delay,:));                          % Delayed Output
end

% Normalising the Output Signal
y =  y./max(abs(y));

% Plotting the Input and Output Signals in Time Domain
subplot(211)
plot(t, x(1:length(x)))
hold on;
plot(t, y(1:length(y)))
hold off;
axis([0 2.73e5 -1 1])
xlabel('Discrete Time')
ylabel('Amplitude')
title('Original & the Output Signal')
legend('Original', 'Output')

% Plotting the Spectograms of the Input and Output Signals
figure(2);
subplot(211)
spectrogram(x(1:length(x)), 1024, 512, 1024, FS, 'yaxis')
title('Spectogram of the Original Signal')
subplot(212)
spectrogram(y(1:length(y)), 1024, 512, 1024, FS, 'yaxis')
title('Spectogram of the Output Signal')

sound(y, FS);
pause(6);
audiowrite(output_file, y, FS);
