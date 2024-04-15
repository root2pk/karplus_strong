% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 
%     RUTHU PREM KUMAR
%     FEBRUARY 2020
%         
%     FUNCTION TO CREATE AN DEKAY EFFECT FOR AN INPUT SIGNAL X
%     AND PLAY IT
%     
%     INPUT PARAMETERS
%     x - INPUT SIGNAL
%     fb - FEEDBACK COEFFICIENT
%     time - TIME BETWEEN INDIVIDUAL ECHOS
%     rep - NUMBER OF ECHOS
%     
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
function [] = delay(x,fb,time,rep)
    
    x = x/max(abs(x));  % Normalizing the input signal
    
    Fs = 44100;         % Sample Rate = 44100 Hz
    sound(x,Fs);        % Play Normalized Audio
    pause(time);        % Pause execution for selected time
    
    for n = 1:rep
        strength = fb*(rep-n)/rep;  % Strength of signal to be played based on fb
        sound(strength*x,Fs);       % Play delay signal
        pause(time);                % Pause execution for selected time
    end

    
end
