function [g_coeff, h_coeff] = read_shc_from_file(MODEL_FILENAME)

    MODEL_FILE = fopen(MODEL_FILENAME, 'r');
    line = '';
    while ~feof(MODEL_FILE)
        line = fgetl(MODEL_FILE);
        if(line(1) == '#')
            fprintf('%s\n', line);
        else
            break
        end
    end

    if strcmp(MODEL_FILENAME(end-2:end), 'cof')
        %cof format MF6 or MF7

        line = strsplit(line);
        t = str2num(line{1});

        line = strsplit(fgetl(MODEL_FILE));
        k_max = str2num(line{2});

        line = strsplit(fgetl(MODEL_FILE));
        dummy = str2num(line{2});

        line = strsplit(fgetl(MODEL_FILE));
        dummy = str2num(line{2});

        line = strsplit(fgetl(MODEL_FILE));
        EARTH_RAD  = str2num(line{1});

        line = strsplit(fgetl(MODEL_FILE));

        g_coeff = zeros(k_max+1, k_max+1);
        h_coeff = zeros(k_max+1, k_max+1);

        while ~feof(MODEL_FILE)
            line = fgetl(MODEL_FILE);
            vals = str2num(line);
            n = vals(1);
            m = vals(2);
            g_coeff(n+1, m+1) = vals(3);
            h_coeff(n+1, m+1) = vals(4);
        end

    elseif strcmp(MODEL_FILENAME(end-2:end), 'shc')
        %shc format CHAOS and SIFM+

        Parameters = str2num(line);
        k_max = Parameters(2);
        N_times = Parameters(3);

        t = str2num(fgetl(MODEL_FILE));

        if ismatrix(t)
            fprintf('possible epochs: %s\n', mat2str(t));
            length(t)
            %i_time = input('enter the epochs index:');
            i_time = 1
            if ~(isnumeric(i_time) && (i_time <= length(t)))
                i_time = 1;
                fprintf('wrong entry, i_time was set to 1\n');
            end
        end

        g_coeff = zeros(k_max+1, k_max+1);
        h_coeff = zeros(k_max+1, k_max+1);

        while ~feof(MODEL_FILE)
            line = fgetl(MODEL_FILE);
            vals = str2num(line);
            n = vals(1);
            m = vals(2);
            if m >= 0;
                g_coeff(n+1, m+1) = vals(2+i_time);
            else
                m = abs(m);
                h_coeff(n+1, m+1) = vals(2+i_time);
            end
        end
    elseif strcmp(MODEL_FILENAME(end-2:end), 'txt')  
        %igrf txt format

        line = strsplit(fgetl(MODEL_FILE));
        t = line(4:end);
        if length(t) > 1
            fprintf('possible epochs: \n');
            disp(t);
            i_time = input('enter the epochs index:');
            if ~(isnumeric(i_time) && (i_time <= length(t)))
                i_time = 1;
                fprintf('wrong entry, i_time was set to 1\n');
            end
        end

        k_max = 13;
        g_coeff = zeros(k_max+1, k_max+1);
        h_coeff = zeros(k_max+1, k_max+1);

        while ~feof(MODEL_FILE)
            line = fgetl(MODEL_FILE);
            vals_txt = strsplit(line);

            n = str2num(vals_txt{2});
            m = str2num(vals_txt{3});

            if strcmp(vals_txt{1}, 'g')
                g_coeff(n+1, m+1) = str2num(vals_txt{3+i_time});
            else
                h_coeff(n+1, m+1) = str2num(vals_txt{3+i_time});
            end
        end
    end
    
    return
end