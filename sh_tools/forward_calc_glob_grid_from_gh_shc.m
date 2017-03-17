function [grid_x, grid_y, grid_z] = forward_calc_glob_grid_from_gh_shc(g_coeff, h_coeff, longitudes, latitudes, altitude, N_min, N_max, varargin)

    fprintf('forward_calc_glob_grid_from_gh_shc: calculating...\n')
    tic
    EARTH_RAD = 6371.2;
    %longitudes = 0 : STEP : 360;
    %latitudes = 0 : STEP : 180;

    grid_x = zeros(length(latitudes), length(longitudes));
    grid_y = zeros(length(latitudes), length(longitudes));
    grid_z = zeros(length(latitudes), length(longitudes));
    
    r = altitude/1000.0;
    for lon_i = 1 : length(longitudes)
        for lat_i = 1 : length(latitudes)

            phi = longitudes(lon_i) * pi / 180.0;
            theta = latitudes(lat_i) * pi / 180.0;
            
            Br = 0;
            Btheta = 0;
            Bphi = 0;
            for n = N_min : N_max %!!!
                sum_r = 0;
                sum_theta = 0;
                sum_phi = 0;

                P = legendre(n, cos(theta), 'sch');
                dP = zeros(n+1, 1);
                dP(n+1) =  (sqrt(n/2)*P(n));      % m=n
                dP(1) = -sqrt(n*(n+1)/2.)*P(2);   % m=0
                
                if n > 1 % m=1
                    dP(2)=(sqrt(2*(n+1)*n)*P(1)-sqrt((n+2)*(n-1))*P(3))/2; 
                end; 
                for m = 2:n-1  % m=2...n-1
                    dP(m+1)=(sqrt((n+m)*(n-m+1))*P(m)-sqrt((n+m+1)*(n-m))*P(m+2))/2;
                end;
                if n == 1 
                    dP(2) = sqrt(2)*dP(2); 
                end
                
                for m = 0 : n
                    sum_r = sum_r + P(m+1)*(g_coeff(n+1, m+1)*cos(m*phi) + h_coeff(n+1, m+1)*sin(m*phi));
                    sum_theta = sum_theta + dP(m+1)*(g_coeff(n+1, m+1)*cos(m*phi) + h_coeff(n+1, m+1)*sin(m*phi));
                    sum_phi = sum_phi + P(m+1)*m*(-g_coeff(n+1, m+1)*sin(m*phi) + h_coeff(n+1, m+1)*cos(m*phi));
                end
                Br = Br + sum_r * (n + 1) * ((EARTH_RAD / (EARTH_RAD+r))^(n+2));
                Btheta = Btheta + sum_theta* ((EARTH_RAD / (EARTH_RAD+r))^(n+2));
                Bphi = Bphi + sum_phi  * ((EARTH_RAD / (EARTH_RAD+r))^(n+2));
            end
            grid_x(lat_i, lon_i) = -Btheta;
            grid_y(lat_i, lon_i) = -Bphi*(1/sin(theta));
            grid_z(lat_i, lon_i) = -Br; %Z- DOWN
        end
    end
    
    toc

    
    grid_x = flipud(grid_x);
    grid_y = flipud(grid_y);
    grid_z = flipud(grid_z);
end