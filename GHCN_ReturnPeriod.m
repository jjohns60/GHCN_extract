%% To get return period information for 24-hour precipitation, using GHCN data
clc
clear

%csv file <- includes the record of daily precipitation
dataPath = '/Users/jjohns/Desktop/CMIP6 Project/PR_obs/Raw_Daily_Summaries/';
savePath = '/Users/jjohns/Desktop/CMIP6 Project/PR_obs/ReturnPeriod_Data/';

%loop through all .csv files in the GHCN data folder
files = dir([dataPath '*.csv']);
for i = 1:length(files)
    %identify file
    file = files(i).name;
    
    %read in file information
    T = readtable([dataPath file]);

    %determine how many stations are within the record (usually 1)
    stations = unique(T.STATION);

    %loop through each station and get output data
    for ii = 1:length(stations)

        %indentify station
        station = stations{ii};

        %create index of the data from the particular station
        idx = cellfun(@(x) contains(x,station), T.STATION);

        %get name, date, daily precipitation, station elevation, and lat/lon
        T_i = T(idx,:);
        PR_OUT = table(T_i.NAME,T_i.LATITUDE,T_i.LONGITUDE,T_i.ELEVATION_m,T_i.DATE,T_i.PRCP,...
            'VariableNames',{'STATION','LATITUDE','LONGITUDE','ELEVATION_m','DATE','Pr_mm'});

        %determine the maximum observed precipitation from each year in the record
        Y = year(PR_OUT.DATE);
        PR = PR_OUT.Pr_mm;
        [U,~,ic] = unique(Y);
        M_pr = zeros(size(U)) + NaN;
        for iii = 1:length(U)
            %get index for a given year
            idx = (ic == iii);
            PR_i = PR(idx);
            PR_i(PR_i == 9999) = NaN; %convert fill values to NaN

            if length(PR_i) > 300 %ensures data from at least 300 days exist
                M_pr(iii) = nanmax(PR_i);
            else
                M_pr(iii) = NaN;
            end
        end

        [M_pr,idx] = sort(M_pr(~isnan(M_pr)));
        yy = U(idx);
        %calculate return period (in years)
        RP = flipud((((length(M_pr)+1)./([1:length(M_pr)])))');
        M_pr = table(M_pr,RP,yy,'VariableNames',{'Annual_Daily_Maximum_mm','Return Period','Year'});

        %save the data using the station ID and recurrance interval suffix (RI)
        writetable(M_pr,[savePath station '_RP.csv']);
    end
end