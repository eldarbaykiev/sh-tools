function grid_result = forward_calc_glob_z_grid_from_AB_shc(A_coeff, B_coeff, longitudes, latitudes, N_max, varargin)
    grid_result = zeros(length(latitudes), length(longitudes));
  
    phi_all = longitudes * pi / 180.0;
    theta_all = latitudes * pi / 180.0;
    
    M = 0 : N_max;
    cos_m_phi = cos(M'*phi_all);
    sin_m_phi = sin(M'*phi_all);
    cos_theta = cos(theta_all);
    
    n_arg = length(varargin);
    if n_arg > 0
        if iscell(varargin{1})
            P = varargin{1};
        else
            warning('Check the input!');
        end         
    else
        P = cell(N_max + 1, 1);
        for n = 0 : N_max
            P{n+1} = legendre(n, cos_theta, 'sch');
        end
    end
    
    %P_all{n+1}(m+1, theta_i)
    
    for phi_i = 1 : length(phi_all)
        for theta_i = 1 : length(theta_all)
            sum = 0;
            %sum_old = 0;
            for n = 0 : N_max
                %P = legendre(n, cos_theta(theta_i), 'sch');
                for m = 0 : n
                    %sum_old = sum_old + P(m+1)*(A_coeff(n+1, m+1)*cos_m_phi(m+1, phi_i) + B_coeff(n+1, m+1)*sin_m_phi(m+1, phi_i));
                    sum = sum + P{n+1}(m+1, theta_i)*(A_coeff(n+1, m+1)*cos_m_phi(m+1, phi_i) + B_coeff(n+1, m+1)*sin_m_phi(m+1, phi_i));
                end
            end
            grid_result(theta_i, phi_i) = sum;
        end
    end

    return
end