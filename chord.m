%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%               
%                  FUNCTION TO PLAY CHORDS
%                     RUTHU PREM KUMAR
%                     FEBRUARY 2020
% 
%          THIS FUNCTION USES PRE- PROGRAMMED FREQUENIES 
%          TO PRODUCE CHORDS USING THE MODIFIED 
%          KARPLUS-STRONG ALGORITHM
%
%        PARAMETERS
%        NUMBER - CHORD NUMBER TO IDENTIFY CHORD
%        GAP - TIME DURATION BETWEEN CONSECUTIVE PLUCKS (S)
% 
%        RETURNS A VECTOR Y 
% 
%        SOURCE FOR NOTE FREQUENCY VALUES
%          - 'https://pages.mtu.edu/~suits/notefreqs.html'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = chord(number,gap,rho,R,dur)


    % Function form guitar(freq,decay coeff, dynamics coeff, length(s))
    Fs = 44100;
    
    % If only one argument is given, auto initialise the following
    if nargin<2
        gap = 0.05;
        rho = 0.985;
        R = 0.99;
        dur = 1.5;
    end
    
    %Chord lists with frequencies of chords in Hz
    Am_chord = [110,164.81,220,261.63,329.63];
    C_chord = [130.81,164.81,196,261.63,329.63];
    G_chord = [98,123.47,146.83,196,293.66,392];
    Em_chord = [82.41,123.47,164.81,196,246.94,329.63];
    F_chord = [87.31,130.81,174.61,220,261.63,349.23];
    Dm_chord = [146.83,220,293.66,349.23];
    D_chord = [146.83,220,293.66,369.99];
    Bm_chord = [123.47,185,246.94,293.66,369.99];
    Bflat_chord = [116.54,174.61,233.08,293.66,349.23];
    Gm_chord = [98,146.83,196,233.08,293.66,392];
    
    
    %Initialising Output Vector with zeros
    
    len = round(dur*Fs);   %LENGTH OF EACH INPUT VECTOR
    y = zeros(ceil(len+(6*gap*Fs)),1);    
    
    
    
    %Switch Case for each chord
    switch number
        case 1
            for n = 1:length(Am_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Am_chord(n),rho,R,dur);
            end
        case 2
            for n = 1:length(C_chord)
               start_pos = round(1+(n-1)*gap*Fs);
               y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(C_chord(n),rho,R,dur);               
            end
        case 3
            for n = 1:length(G_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(G_chord(n),rho,R,dur);               
            end
        case 4
            for n = 1:length(Em_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Em_chord(n),rho,R,dur);
            end
        case 5
            for n = 1:length(Dm_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Dm_chord(n),rho,R,dur);
            end
            
        case 6    
            for n = 1:length(F_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(F_chord(n),rho,R,dur);
            end
        case 7
            for n = 1:length(Bm_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Bm_chord(n),rho,R,dur);
            end
        case 8
            for n = 1:length(D_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(D_chord(n),rho,R,dur);
            end
        case 9
            for n = 1:length(Gm_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Gm_chord(n),rho,R,dur);
            end
        case 10
            for n = 1:length(Bflat_chord)
                start_pos = round(1+(n-1)*gap*Fs);
                y(start_pos:start_pos+len-1) =  y(start_pos:start_pos+len-1)+guitar(Bflat_chord(n),rho,R,dur);
            end
        otherwise
            disp('Choose valid number')
    end
end


        
