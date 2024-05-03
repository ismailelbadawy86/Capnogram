function z = complexity(x, dt)

% x: Input data signal 
% dt: Sampling time interval
% z: Output calculated Hjorth complexity for the input data signal x

% Author: Ismail M. El-Badawy
% https://scholar.google.com/citations?user=ksTjuvAAAAAJ&hl=en&oi=ao

    [r c] = size(x);
    
    dx_dt = diff(x)/dt;

    if r == 1
        z = mobility([dx_dt 0], dt)/mobility(x, dt);
    else
        z = mobility([dx_dt; 0], dt)/mobility(x, dt);
    end
    
end