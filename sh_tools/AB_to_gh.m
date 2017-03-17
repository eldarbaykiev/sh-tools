function [g_coeff, h_coeff] = AB_to_gh(A_coeff, B_coeff, EARTH_REF_RAD, ALT)
    g_coeff = A_coeff*0;
    h_coeff = B_coeff*0;
    N = length(g_coeff(:, 1))-1;
    for n = 0 : N
        for m = 0 : n
            g_coeff(n+1, m+1) = A_coeff(n+1, m+1)/( (n+1)*((EARTH_REF_RAD / (EARTH_REF_RAD+ALT))^(n+2)) );
            h_coeff(n+1, m+1) = B_coeff(n+1, m+1)/( (n+1)*((EARTH_REF_RAD / (EARTH_REF_RAD+ALT))^(n+2)) ); 
        end 
    end
    return
end