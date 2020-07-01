%% ------------------------------------------------------------------------
%
% Source code for article entitled "Automatic Classification of Regular 
% and Irregular Capnogram Segments Using Time- and Frequency-domain 
% Features: A Machine Learning-based Approach"
% 
% Authors: Ismail M. El-Badawy, Om Prakash Singh and Zaid Omar
% DOI: 10.3233/THC-202198
% Corresponding author: Ismail M. El-Badawy
% E-mail: ismailelbadawy@gmail.com
%
%% ------------------------------------------------------------------------

clear all; close all; clc

fs = 20;          % Sampling rate of capnogram signal (20 Samples/sec)
   
% Sample regular and irregular Capnogram segments %
% ----------------------------------------------- %
regular_t = textread('regular_capnogram_sample.txt');
irregular_t = textread('irregular_capnogram_sample.txt');

%% Time-domain Features

N1 = length(regular_t);        % Length of regular capnogram segment 
N2 = length(irregular_t);      % Length of irregular capnogram segment

tax1 = [0:N1-1]/fs;            % Time-axis for regular segment
tax2 = [0:N2-1]/fs;            % Time-axis for irregular segment


% 1 - Energy %
% ---------- %
Ec1 = (1/fs)*sum((regular_t/max(regular_t)).^2);
Ec2 = (1/fs)*sum((irregular_t/max(irregular_t)).^2);

% 2 - Variance %
% ------------ %
sigma1 = var(regular_t/max(regular_t));
sigma2 = var(irregular_t/max(irregular_t));

% 3 - Skewness (Absolute value) %
% ----------------------------- %
skew1 = abs(skewness(regular_t/max(regular_t)));
skew2 = abs(skewness(irregular_t/max(irregular_t)));

% 4 - Kurtosis %
% ------------ %
kurt1 = kurtosis(regular_t/max(regular_t));
kurt2 = kurtosis(irregular_t/max(irregular_t));    


%% Frequency-domain Features

x1 = regular_t - mean(regular_t);  % Remove the DC (zero-frequency) component 
x2 = irregular_t - mean(irregular_t);

regular_f = abs(fft(x1));        % Magnitude Spectrum of the capnogram segment
irregular_f = abs(fft(x2)); 
    
regular_f_norm = regular_f/max(regular_f); % Normalized Spectrum
irregular_f_norm = irregular_f/max(irregular_f);
    
% 1 - Number of relatively high spectral peaks (P2) %
% ------------------------------------------------- %
Y1 = (regular_f_norm(1:floor(N1/2))) >= 0.5;                                     
P1 = length(find(Y1)); 

Y2 = (irregular_f_norm(1:floor(N1/2))) >= 0.5;                                     
P2 = length(find(Y2));   

% 2 - Area under normalized magnitude spectrum from 0 to 2Hz (A2) %
% --------------------------------------------------------------- %

% fs/N is the frequency resolution
% 2N/fs = (2*300)/20 = 30 (i.e. 1 < k < 31 is equivalent to 0 < f < 2 Hz) 

f_bins1 = [0:N1-1];              % Frequency bins 
f_bins2 = [0:N2-1]; 

fax1 = f_bins1*(fs/N1);          % Frequency-axis in Hz for regular segment
A1 = trapz(fax1(1:31), regular_f_norm(1:31));     
fax2 = f_bins2*(fs/N2);          % Frequency-axis in Hz for irregular segment
A2 = trapz(fax2(1:31), irregular_f_norm(1:31)); 



%% Plotting

figure(1)
subplot(211); plot(tax1, regular_t/max(regular_t), 'linewidth', 1.2); 
xlabel 'Time (sec)'; ylabel('Normalized CO_{2} (mmHg)') 
axis([0 15 0 1.2])
subplot(212)
stem(fax1, regular_f_norm, 'r.', 'linewidth', 1.2);
hold on; plot([0, 2], [0.5, 0.5],  'k--', 'linewidth', 1.2)
xlabel 'Frequency (Hz)'; ylabel 'Normalized Magnitude'
axis([0 2 0 1.2]);


figure(2)
subplot(211); plot(tax2, irregular_t/max(irregular_t), 'linewidth', 1.2); 
xlabel 'Time (sec)'; ylabel('Normalized CO_{2} (mmHg)') 
axis([0 15 0 1.2])
subplot(212)
stem(fax2, irregular_f_norm, 'r.', 'linewidth', 1.2);
hold on; plot([0, 2], [0.5, 0.5],  'k--', 'linewidth', 1.2)
xlabel 'Frequency (Hz)'; ylabel 'Normalized Magnitude'
axis([0 2 0 1.2]); 
