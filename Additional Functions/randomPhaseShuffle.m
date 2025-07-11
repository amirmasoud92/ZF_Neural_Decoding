function shuffled_signal = randomPhaseShuffle(signal)
    % Perform Fourier Transform
    signal_fft = fft(signal);
    % Get amplitude and phase
    amplitude = abs(signal_fft);
    phase = angle(signal_fft);
    % Shuffle phase randomly
    shuffled_phase = phase(randperm(length(phase)));
    % Reconstruct signal with shuffled phase
    shuffled_fft = amplitude .* exp(1i * shuffled_phase);
    shuffled_signal = real(ifft(shuffled_fft));
end
