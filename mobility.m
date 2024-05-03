function y = mobility(x, dt)

% x: Input data signal 
% dt: Sampling time interval
% y: Output calculated Hjorth mobility for the input data signal x

% Author: Ismail M. El-Badawy
% https://scholar.google.com/citations?user=ksTjuvAAAAAJ&hl=en&oi=ao

    [r c] = size(x);

    dx_dt = diff(x)/dt;

    if r == 1
        y = std([dx_dt 0])/std(x);
    else
        y = std([dx_dt; 0])/std(x);
    end
    
end

