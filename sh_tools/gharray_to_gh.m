function [g_coeff, h_coeff] = gharray_to_gh(gharray)
%convert gharray of format [g_1^0; g_1^1; h_1^1; g_2^0; g_2^1; h_2^1; ... g_N^N; h_N^N] to a matrices g_coeff(N+1, N+1) and h_coeff(N+1, N+1) 
    N_max = 0.5*(-2+sqrt(4+4*length(gharray)));
    
    g_coeff = zeros(N_max+1, N_max+1);
    h_coeff = zeros(N_max+1, N_max+1);
    
    ind = 1;
    for n = 1 : N_max
       for m = 0 : n
           if m == 0
               g_coeff(n+1, m+1) = gharray(ind);
               ind = ind + 1;
           else
               for i_m = 0 : 1
                   if i_m == 0
                       g_coeff(n+1, m+1) = gharray(ind);
                       ind = ind + 1;
                   else
                       h_coeff(n+1, m+1) = gharray(ind);
                       ind = ind + 1;
                   end
               end
           end
       end     
    end
end




