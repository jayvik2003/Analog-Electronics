% Define time steps and initialize signal arrays
t = 0:0.001:1;  % Create a time vector with 0.001s steps from 0 to 1 second
y = zeros(size(t));  % Initialize two empty arrays for storing signals
y1 = zeros(size(t));

% Define constants
k = 2 * pi;  % Constant used for calculating sine wave frequencies

% Loop through harmonics (odd multiples of 5)
for i = 1:2:100
    % Define amplitude based on harmonic frequency
    if 5 * i >= 5 && 5 * i < 10
        A = 1;  % Amplitude for harmonics between 5 and 10 Hz
    elseif 5 * i >= 10 && 5 * i < 50
        A = 5;  % Amplitude for harmonics between 10 and 50 Hz
    elseif 5 * i >= 50 && 5 * i < 200
        A = 2;  % Amplitude for harmonics between 50 and 200 Hz
    elseif 5 * i >= 200 && 5 * i < 1000
        A = 1;  % Amplitude for harmonics between 200 and 1000 Hz
    elseif 5 * i >= 1000 && 5 * i < 2000
        A = 0.3;  % Amplitude for harmonics between 1000 and 2000 Hz
    elseif 5 * i >= 2000
        A = 0;  % No contribution for harmonics at or above 2000 Hz
    end

    % Add sine wave component for harmonics within 5 - 100 Hz range
    if 5 * i >= 5 && 5 * i <= 100
        y = y + (4 / (pi * i)) * sin(k * 5 * i * t);  % Add weighted sine wave to original signal
    end

    % Add scaled sine wave component for all harmonics to amplified signal
    y1 = y1 + A * (4 / (pi * i)) * sin(k * 5 * i * t);  % Add weighted and scaled sine wave to amplified signal
end

% --- Implementing Low-Pass Filter ---

% Get the Fast Fourier Transform of the amplified signal
Y1 = fft(y1);

% Define frequency domain and create filter mask
f = k * (1:length(Y1)) / (2 * pi);  % Calculate frequencies from the FFT data
filter_mask = ones(size(f));  % Create a mask with all frequencies initially passed

% Set stopband mask to attenuate frequencies above 8 Hz
filter_mask(f > 8) = 0;  % Set all frequencies above 8 Hz to zero in the mask

% Apply filter and inverse transform to get filtered signal
Y2 = filter_mask .* Y1;  % Apply the filter mask to the frequency spectrum
y2 = ifft(Y2);  % Convert the filtered frequency spectrum back to time domain

% --- Plotting the Signals ---

% Figure 1: Original Signal
figure;
plot(t, y, 'b');
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');
grid on;

% Figure 2: Amplified Signal
figure;
plot(t, y1, 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('Amplified Signal');
grid on;

% Figure 3: Filtered Signal
figure;
plot(t, y2, 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Signal (Figure 3)');
grid on;

