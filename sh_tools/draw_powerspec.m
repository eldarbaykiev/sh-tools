function fig = draw_powerspec(g_coeff, h_coeff, EARTH_REF_RAD, ALT, varargin)
    n_arg = length(varargin);
    
    if n_arg > 0
        linestyle = varargin{1};
    else
        linestyle = '-x';
    end
        
    [x, y] = power_spectrum_MauersbergerLowes(g_coeff, h_coeff, EARTH_REF_RAD, ALT);
    fig = semilogy(x, y, linestyle);
    return
end