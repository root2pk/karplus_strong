% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 
%    
% 
%      RUTHU PREM KUMAR 
%      FEBRUARY 2020
%
%      FUNCTION TO PRODUCE GUITAR TONE BASED ON 
%      INPUT PARAMETERS
%      f0 - FUNDAMENTAL FREQUENCY (Hz)
%      rho - LOSS FACTOR ( Around 0.98 - 1)
%      R - DYNAMIC FILTER COEFFICIENT (Between 0 and 1)
%      dur - Duration of note (seconds)
% 
%      RETURNS SIGNAL VECTOR Y
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


function y = guitar(f0,rho,R,dur)

    %s = rng(0);                 % To Produce a fixed set of random numbers each time for a consistent tone

    Fs = 44100;                 % Sample Rate Fs (samples/s)

    Nexact = Fs/f0 - 0.5;       % Ideal Delay line length (samples)
    N = floor(Nexact);          % Actual Delay Line Length (samples)   
    P = Nexact - N;             % Fractional Delay (samples)

    C = (1-P)/(1+P);            % All pass filter coefficient

    M = round(Fs*dur);          % Length of simulation in samples

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
    xp1 = y(n-N);
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
end
