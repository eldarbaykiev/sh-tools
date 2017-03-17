function [A_coeff, B_coeff] = gh_to_AB(g_coeff, h_coeff, EARTH_REF_RAD, ALT)
%convert usual g and h coefficients to a coefficients of only vert. mag.
%field component SH coeficients A and B

    A_coeff = g_coeff*0;
    B_coeff = h_coeff*0;
    N = length(g_coeff(:, 1))-1;
    for n = 0 : N
        for m = 0 : n
            A_coeff(n+1, m+1) = g_coeff(n+1, m+1)*(n+1)*((EARTH_REF_RAD / (EARTH_REF_RAD+ALT))^(n+2));
            B_coeff(n+1, m+1) = h_coeff(n+1, m+1)*(n+1)*((EARTH_REF_RAD / (EARTH_REF_RAD+ALT))^(n+2)); 
        end 
    end
    return
end