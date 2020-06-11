% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%            Modified Karplus-Strong Algorithm
%                 for a plucked string
%                  Ruthu Prem Kumar 
%                    February 2020
% 
%     This Program first creates a short 
%     white noise passed through dynamic filter
%     and then performs the modified Karplus-Strong 
%     Algorithm with an all-pass filter
%     to produce a harmonic structure similar
%     to that of a plucked string
% 
%     The fundamental frequency of the output
%     matches better with the actual fundamental frequency,
%     as compared to the basic algorithm
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


clear all; close all;       % Ensuring all variables are closed and cleared

%s = rng(0);                % To Produce a fixed set of random numbers each time for a consistent tone

Fs = 44100;                 % Sample Rate Fs (samples/s)
f0 = 500;                   % Fundamental frequency (Hz)

Nexact = Fs/f0 - 0.5;       % Ideal Delay line length (samples)
N = floor(Nexact);          % Actual Delay Line Length (samples)   
P = Nexact - N;             % Fractional Delay (samples)

C = (1-P)/(1+P);            % All pass filter coefficient


rho = 0.99;                % Loss Factor
R = 0.5;                    % Dynamics filter coefficient

dur = 1;                  % Length of simulation (s) 

M = round(Fs*dur);                 % Length of simulation in samples

%%%%%%%%%%%----Pre - filter -----%%%%%%%%%%%%%%%%%

v = 2*rand(N+1,1)-1;        % Input noise vector

u = filter((1-R),[1,-R],v); % Dynamics filter output

%%%%%%%%%%------ Main Algorithm------ %%%%%%%%%%%%%

y = [ u ;zeros(M-(N+1),1)]; %Initialising output vector y


% For loop to calculate rest of y using the recursion 
for n = N+1:M-1
    
    y(n+1) = (rho/2)*(y(n+1-N) + y(n-N));
    
end

%%%%%%%%%%%%%----MODIFIED ALGORITHM-------%%%%%%%%%%%%


xp0 = 0; yp0 = 0;

% Last input sample to allpass filter
xp1 = y(1);
% Initial condition for allpass filter
yp1 = 0;
for n=N+1:M-1 
    
    %Grab input sample to allpass filter
    xp0 = y(n-N+1);
    
    %Calculate output sample from allpass filter
    %Using only intermediate variables xp0, xp1, yp0 and yp1
    
    yp0 = C*xp0 + xp1 - C*yp1;
    
    %calculate next sample of Karplus-Strong, based only on yp0 and yp1
    y(n+1) = (rho/2)*(yp0+yp1);
        
    %step forward in time with your intermediate variables
    xp1=xp0; yp1=yp0;
end

% Play Audio File
soundsc(y,Fs);    

%%%%%%%%--------- PLOTS ----------%%%%%%%%%%


% Waveform - Time Plot %%
subplot(2,1,1)

plot([1:M]/Fs,y)
xlabel('Time(s)'); ylabel('Amplitude'); title('Output waveform vs. time');
xlim([0 dur]);

%% Spectrum Plot %%
subplot(2,1,2)

plot(linspace(0,Fs,M),abs(fft(y))/M,'LineWidth',0.75);
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Signal Spectrum');
xline(f0); xlim([0 Fs/2]); 




