function [n, S_n] = power_spectrum(g_coeff, h_coeff)
    N = length(g_coeff(:, 1))-1;
    S_n = zeros(1, N+1);
    
    i_S_n = 1;
    for n = 0 : N
        sum = 0;
        for m = 0 : n
            sum = sum + g_coeff(n+1, m+1)^2 + h_coeff(n+1, m+1)^2;  
        end
        
        sum = sum / (2*n + 1);
        S_n(i_S_n) = sum;
        i_S_n = i_S_n +1;
    end
    
    n = 0:N;
    
    return;
end