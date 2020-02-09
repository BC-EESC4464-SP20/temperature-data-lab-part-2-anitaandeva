%% Add a comment at the top with the names of all members of your group
%Anita Gee and Eva Lin

%% 1. Load in a list of all 18 stations and their corresponding latitudes and longitudes
load GlobalStationsLatLon.mat
%% 2. Calculate the linear temperature trends over the historical observation period for all 18 station
% You will do this using a similar approach as in Part 1 of this lab, but
% now implementing the work you did last week within a function that you
% can use to loop over all stations in the dataset

%Set the beginning year for the more recent temperature trend
RecentYear = 1960; %you can see how your results change if you vary this value

%Initialize arrays to hold slope and intercept values calculated for all stations
P_all = NaN(length(sta),2); %example of how to do this for the full observational period
%<-- do the same thing just for values from RecentYear to today
P_recent= NaN(length(sta),2);

%Use a for loop to calculate the linear trend over both the full
%observational period and the time from RecentYear (i.e. 1960) to today
%using the function StationTempObs_LinearTrend,P_recent(x)] = StationTempObs_LinearTrend(x,1960);  

% mat=zeros(length(sta),2)
for i = 1:length(sta)
    [a,b] =StationTempObs_LinearTrend(sta(i),1960);
    P_all(i,:)=a;
    P_recent(i,:)=b;
end

    
%% 3a. Plot a global map of station locations
%Example code, showing how to plot the locations of all 18 stations
figure(1); clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
plotm(lat,lon,'m.','markersize',15)
title('Locations of stations with observational temperature data')

%% 3b. Make a global map of the rate of temperature change at each station
% Follow the model from 3a, now using the function scatterm rather than plotm
%to plot symbols for all 18 stations colored by the rate of temperature
%change from RecentYear to present (i.e. the slope of the linear trendline)
%<--
figure(2);clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
slope_recent=P_recent(:,1)*10;
scatterm(lat,lon,100,slope_recent,'filled')
colorbar
title('Rate of Temperature Change at Different Locations (degrees Celsius per decade')
%% Extension option: again using scatterm, plot the difference between the
%local rate of temperature change (plotted above) and the global mean rate
%of temperature change over the same period (from your analysis of the
%global mean temperature data in Part 1 of this lab).
%Data visualization recommendation - use the colormap "balance" from the
%function cmocean, which is a good diverging colormap option
%<--

%% 4. Now calculate the projected future rate of temperature change at each of these 18 stations
% using annual mean temperature data from GFDL model output following the
% A2 scenario (here you will call the function StationModelProjections,
% which you will need to open and complete)

%Use the function StationModelProjections to loop over all 18 stations to
%extract the linear rate of temperature change over the 21st century at
%each station
[~,~,~,~,year]=StationModelProjections(sta(1));

P = NaN(length(sta),2);
baseline_model= NaN(length(sta),2);
temp_2006= NaN(length(sta),1);
movemean= NaN(length(year),length(sta));

for i = 1:length(sta)
    [c,d,e,f,g] =StationModelProjections(sta(i));
    P(i,:)=d;
    baseline_model(i,:)=c;
    temp_2006(i)=e;
    movemean(:,i)=f;
end


% Initialize arrays to hold all the output from the for loop you will write
% below
%<--

% Write a for loop that will use the function StationModelProjections to
% extract from the model projections for each station:
% 1) the mean and standard deviation of the baseline period
% (2006-2025) temperatures, 2) the annual mean temperature anomaly, and 3)
% the slope and y-intercept of the linear trend over the 21st century
%<--

%% 5. Plot a global map of the rate of temperature change projected at each station over the 21st century
%<--

figure(3);clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,100,10*P(:,1),'filled')
colorbar
title('Rate of projected temperature change from 2006 to 2099 (degrees Celsius per decade)')


%% 6a. Plot a global map of the interannual variability in annual mean temperature at each station
%as determined by the baseline standard deviation of the temperatures from
%2005 to 2025
%<--
vari=baseline_model(:,2);
figure(4);clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,100,vari,'filled')
legend('interannual variability in annual mean temperature at each station')
colorbar
title('interannual variability in annual mean temperature at each station (2005-2025)')

%% 6b-c. Calculate the time of emergence of the long-term change in temperature from local variability
%There are many ways to make this calcuation, but here we will compare the
%linear trend over time (i.e. the rate of projected temperature change
%plotted above) with the interannual variability in the station's
%temperature, as determined by the baseline standard deviation

%Calculate the year of long-term temperature signal emergence in the model
%projections, calculated as the time (beginning from 2006) when the linear
%temperature trend will have reached 2x the standard deviation of the
%temperatures from the baseline period
%<--

Sig_Noise = P(:,1)./vari>2

%twovari=2*vari
%temp_emge=twovari+temp_2006
%year_emge=(temp_emge-P(:,2))./P(:,1)
%year_emergence=ceil(year_emge)


%Plot a global map showing the year of emergence
%<--
figure(5);clf
worldmap('World')
load coastlines
plotm(coastlat,coastlon)
scatterm(lat,lon,100,year_emergence,'filled')
colorbar
title('the year of emergence of the long-term tempertaure signal from the baseline nautral variability')


%Extension:modify the StationTemp_ObsLinear Trend
%function/StationModelProjections function to also give you the smoothed
%temperature anomaly for each station, and use this to create a plot that
%shows the smoothed temperature anomaly at all 18 stations.
%%
figure(6);clf
for s=1:18
   plot(year,movemean(:,s),'color',rand(1,3))
   legendCell{s}=num2str(sta(s));
   legend(legendCell)
   hold on
end
legend('location','northwest')
title('Smoothed temperature anomaly at all 18 stations (5 years movemean)')
xlabel('year')
ylabel('temperature anomaly (degree celsius)')
