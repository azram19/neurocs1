function [H] = entropy(S,N)

    H=0.5*log((2*pi*exp(1))^N*det(cov(S')));

end