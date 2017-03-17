function grid_write_to_xyz(out_filename, lon_v, lat_v, grid_mx)
filout = fopen(out_filename, 'w');

for i = 1 : length(lon_v)
    for j = 1 : length(lat_v)
        fprintf(filout, '%f %f %f\n', lon_v(i), lat_v(j), grid_mx(j, i));
    end
end
fclose(filout);





end