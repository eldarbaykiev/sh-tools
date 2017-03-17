SHC_FILENAME = 'SIFM.shc';
SHC_FILEPATH = 'models\'
[g_coeff, h_coeff] = read_shc_from_file(strcat(SHC_FILEPATH , SHC_FILENAME));


%integr
EARTH_RADIUS_IGRF_KM = 6371.2;
EARTH_RADIUS_TESS_KM = 6378.137;

IGRF_DATE = '01-Jan-2015';
IGRF_DATENUM = datenum(IGRF_DATE);

STEP = 2;

longitudes = 0 : 1 : 360;
latitudes = 0 : 1 : 180;

longitudes_r = [0:180 -180:-1] 
latitudes_r = 90 : -1 : -90;

N_MIN = 13;
N_MAX = 70;
ALTTESS = 400000;
ALTITUDE = 0%EARTH_RADIUS_TESS_KM*1000 - EARTH_RADIUS_IGRF_KM*1000 + ALTTESS;
[magX, magY, magZ] = forward_calc_glob_grid_from_gh_shc(g_coeff, h_coeff, longitudes, latitudes, ALTITUDE, N_MIN, N_MAX);

save sifmgrid magX magY magZ



longitudes_r = [0:180 -180:-1] 
latitudes_r = -90 : 1 : 90;

grid_write_to_xyz(strcat('area_', SHC_FILENAME, '_7N', num2str(N_MAX), '_ALTTESS', num2str(ALTTESS), 'm.magtess_Bx.txt'), longitudes_r, latitudes_r, -magX);
grid_write_to_xyz(strcat('area_', SHC_FILENAME, '_7N', num2str(N_MAX), '_ALTTESS', num2str(ALTTESS), 'm.magtess_By.txt'), longitudes_r, latitudes_r, magY);
grid_write_to_xyz(strcat('area_', SHC_FILENAME, '_7N', num2str(N_MAX), '_ALTTESS', num2str(ALTTESS), 'm.magtess_Bz.txt'), longitudes_r, latitudes_r, magZ);

