function datafilt = EOMfilters(data,cutoff,order)

if nargin == 2
    order = 4;
end

datafilt = lopass_butterworth(data,cutoff,500,order);