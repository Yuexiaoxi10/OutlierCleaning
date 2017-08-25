function P = formP(omega)

n = length(omega);
P = eye(n);
P(omega==0, :) = [];

end