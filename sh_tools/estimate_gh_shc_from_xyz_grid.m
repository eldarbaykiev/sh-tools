function [g_coeff, h_coeff] = estimate_gh_shc_from_xyz_grid(X_COMP, Y_COMP, Z_COMP, LON, LAT, TESS_ALT_KM, N)

    COLAT = 90 - LAT;
    EARTH_RADIUS_IGRF_KM = 6371.2;
    EARTH_RADIUS_TESS_KM = 6378.137;
    rad = pi/180;
    a = 6371.2;
    N_coeff = N*(N +2);
    GtG = zeros(N_coeff, N_coeff); Gty = zeros(N_coeff, 1);

    [A_r, A_theta, A_phi] = design_SHA((TESS_ALT_KM+EARTH_RADIUS_TESS_KM)/EARTH_RADIUS_IGRF_KM, COLAT*rad, LON*rad, N, 'int');
    G_tmp = [A_r; A_theta];
    Gty = G_tmp'*[Z_COMP; X_COMP];
    GtG = G_tmp'*G_tmp;
    % Make the inversion   
    m_i = GtG\Gty;

    [g_coeff, h_coeff] = gharray_to_gh(m_i);

    return
end