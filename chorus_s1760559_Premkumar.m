
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
%           RUTHU PREM KUMAR
%           FEBRUARY 2020
% 
%           FUNCTION TO CREATE A CHORUS FOR AN INPUT SIGNAL X
%           USING EXISTING CHORUS IMPLEMENTATION FROM MAFTDSP
%
%
%           INPUT PARAMETERS
%           x - INPUT AUDIO
%           N_rand - Number of random LFOs
% 
%           RETURNS A VECTOR Y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function y = chorus_s1760559_Premkumar(x,N_rand)
   

    Fs = 44100;   % Sample Rate = 44100 Hz
    %LFO Parameters for both the LFOs

    %--------------LEFT CHANNEL------------------------
    %LFO 1
    MO1 = 0.010;              %MO1 = 10 ms
    D1 = 0.003;               %D1 = 2 ms
    f1 = 0.5;                 %f1 = 0.5 Hz
    g1 = 0.1;                 %g1 = 0.1

    %LFO 2
    MO2 = 0.015;              %MO2 = 15 ms
    D2 = 0.005;               %D2 = 5 ms
    f2 = 1;                   %f2 = 1 Hz
    g2 = 0.25;                %g2 = 0.25

    %----------------------------------------------------
    %---------------RIGHT CHANNEL------------------------

    %LFO 3
    MO3 = 0.020;              %MO3 = 20 ms
    D3 = 0.007;               %D3 = 7 ms
    f3 = 1.5;                 %f3 = 1.5 Hz
    g3 = -0.25;               %g3 = -0.25

    %LFO 4
    MO4 = 0.035;              %MO4 = 35 ms
    D4 = 0.010;               %D4 = 10 ms
    f4 = 2;                   %f4 = 2 Hz
    g4 = -0.5;                %g4 = -0.5

    %---------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Converting MO and D values in terms of samples
    MO1 = round(MO1*Fs); MO2 = round(MO2*Fs);  MO3 = round(MO3*Fs); 
    MO4 = round(MO4*Fs);
    D1 = round(D1*Fs); D2 = round(D2*Fs); D3 = round(D3*Fs); D4 = round(D4*Fs);

    %Checking which LFO has highest delay and zero padding accordingly
    start_pos = max([MO1, MO2, MO3, MO4]);
    %Zero padding the input signal to avoid negative indices
    x = vertcat(zeros(start_pos,1),x);

    %Calculating new length of input signal
    L_new = length(x);

    %Creating output signals
    yR = zeros(L_new,1);   %Right
    yL = yR;               %Left      
    y = zeros(L_new,2);    %Total


    %---------------Creating LFOs-----------------------------------------

    %Sinusoids with the frequencies f1,f2,f3,f4
    n = [0:L_new];
    s(1,:) = sin(2*pi*f1*n/Fs);
    s(2,:) = sin(2*pi*f2*n/Fs);
    s(3,:) = sin(2*pi*f3*n/Fs);
    s(4,:) = sin(2*pi*f4*n/Fs);


    %Modifying the sinusoids by adding N_rand sinusoids of random frequencies
    for t =1:4
        s(t+4,:) = zeros(1,L_new+1);
        for k =1:N_rand
            %Vector with random values of frequency in range (0.2 Hz,2 HZ)
            f_rand(k) = 0.2 + rand(1)*1.8;       
            %Adding random sinusoids to s
            s(t+4,:) = s(t+4,:)+sin(2*pi*f_rand(k)*n/Fs); 
        end
        %Normalizing the sinusoids obtained
        s(t+4,:) = (s(t+4,:)/max(abs(s(t+4,:))))*max(abs(s(t,:)));

    end

    %Using the sinusoid combinations to create the LFOs

    %Creating LFO M1
    M1(n+1) = MO1 + D1*(s(5,:)-1);
    M1=M1.';

    %Creating LFO M2

    M2(n+1) = MO2 + D2*(s(6,:)-1);
    M2=M2.';

    %Creating LFO M3
    M3(n+1) = MO3 + D3*(s(7,:)-1);
    M3=M3.';

    %Creating LFO M4
    M4(n+1) = MO4 + D4*(s(8,:)-1);
    M4=M4.';
    for n=start_pos:L_new
        
        %Left channel M1 and M2
        yR(n) = x(n) + g1*x(n - round(M1(n))) + g2*x(n - round(M2(n)));
        %Right channel M3 and M4
        yL(n) = x(n) + g3*x(n - round(M3(n))) + g4*x(n - round(M4(n)));

    end
        %Assigning channels to output array y
        y(:,1) = yL; y(:,2) = yR;
      
end