%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Basic Karplus-Strong Algorithm
%                 for a plucked string
%                  Ruthu Prem Kumar 
%                    February 2020
%
%         This Program first creates a short 
%         white noise passed through dynamic filter
%         and then performs the Karplus-Strong 
%         Algorithm to produce a harmonic structure similar
%         to that of a plucked string
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

%Simulation Parameters
 
%s = rng(0);                % To Produce a fixed set of random numbers each time for a consistent tone

Fs = 44100;                 % Sample Rate Fs (samples/s)
f0 = 500;                   % Fundamental frequency (Hz)

N = round(Fs/f0 - 0.5);     % Delay line length (samples)

rho = 0.999;                % Loss Factor
R = 0.5;                    % Dynamics filter coefficient

dur = 2;                    % Length of simulation (s) 

M = round(Fs*dur);          % Length of simulation in samples

 
%%%%%%%%%%% ---- Pre-filter -----%%%%%%%%%%%%%%%%%

v = 2*rand(N+1,1)-1;        % Input noise vector

u = filter((1-R),[1,-R],v); % Dynamics filter output

%%%%%%%%%%------ Main Algorithm------ %%%%%%%%%%%%%

y = [ u ;zeros(M-(N+1),1)]; %Initialising output vector y


%% For loop to calculate rest of y using the recursion 
for n = N+1:M-1
    
    y(n+1) = (rho/2)*(y(n+1-N) + y(n-N));
    
end

% Plaing the output signal
soundsc(y,Fs);    

%%%%%%%%--------- PLOTS ----------%%%%%%%%%%


%% Waveform - Time Plot %%
subplot(2,1,1)

plot([1:M]/Fs,y)
xlabel('Time(s)'); ylabel('Amplitude'); title('Output waveform vs. time');

%% Spectrum Plot %%
subplot(2,1,2)

plot(linspace(0,Fs,M),abs(fft(y))/M,'LineWidth',0.75);
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Signal Spectrum');
xline(f0); xlim([0 Fs/2]);




