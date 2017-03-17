function [A_coeff, B_coeff] = estimate_AB_shc_from_glob_z_grid(Z_COMP, N)

    
    [a, b] = size(Z_COMP);
    if (b == 1) && (a > 1)
        %Z_COMP - vector with Bz values were positions are defined by tessgrid.exe
        %standart
        grid_spacing = 180/((-3 + sqrt(1+8*length(Z_COMP)))/4);
        
        longitudes = 0 : grid_spacing : 360;
        latitudes = 0 : grid_spacing : 180;
        
        grid = reshape(Z_COMP, length(longitudes), length(latitudes))';
    else
        grid_spacing = 180/(a-1);
        
        longitudes = 0 : grid_spacing : 360;
        latitudes = 0 : grid_spacing : 180;
        grid = Z_COMP;
        
    end

    
    A_coeff = zeros(N+1, N+1);
    B_coeff = zeros(N+1, N+1);

    for n = 0 : N
        theta_line = latitudes * pi / 180.0;
        P = legendre(n, cos(theta_line), 'sch');
        for m = 0 : n;

            K_theta_cos = zeros(length(latitudes), 1);
            K_theta_sin = zeros(length(latitudes), 1);
            for lat_i = 1 : length(latitudes)
                phi_line = longitudes * pi / 180.0;
                f_line = grid(lat_i, :);

                K_theta_cos(lat_i) = trapz(phi_line, f_line .* cos(m * phi_line));
                K_theta_sin(lat_i) = trapz(phi_line, f_line .* sin(m * phi_line));
            end

            
            H1 = (P(m+1, :)' .* K_theta_cos)' .* sin(theta_line);
            H2 = (P(m+1, :)' .* K_theta_sin)' .* sin(theta_line);


            A = trapz(theta_line, H1) * (2*n + 1) / (4*pi);
            B = trapz(theta_line, H2) * (2*n + 1) / (4*pi);

            A_coeff(n+1, m+1) = A;
            B_coeff(n+1, m+1) = B;

        end
    end

end





