function [baseline_model,P,temp_2006,movemean,year] = StationModelProjections(station_number)

% StationModelProjections Analyze modeled future temperature projections at individual stations
%===================================================================
%
% USAGE:  [baseline_model, P] = StationModelProjections(station_number)
%
% DESCRIPTION:
%   Use this function to calculate 1)the mean and the standard deviation of
%   annual mean temperature over the baseline period from 2006 to 2025 2)
%   the annual mean temperature anomly for each year as compared to the
%   baseline period and 3) slope and y-intercept of linear trend line for
%   the model annual mean temperature over the full period from 2006 to
%   2099.
%
% INPUT:
%    staton_number: Number of the station from which to analyze historical temperature data
%    
%
% OUTPUT:
%    baseline_model: [mean annual temperature over baseline period
%       (2006-2025); standard deviation of temperature over baseline period]
%    P: slope and intercept for a linear fit to annual mean temperature
%       values over the full 21st century modeled period
%  
%
% AUTHOR:   Anita Gee and Eva Lin
%
% REFERENCE:
%    Written for EESC 4464: Environmental Data Exploration and Analysis, Boston College
%    Data are from the a global climate model developed by the NOAA
%       Geophysical Fluid Dynamics Laboratory (GFDL) in Princeton, NJ - output
%       from the A2 scenario extracted by Sarah Purkey for the University of
%       Washington's Program on Climate Change
%==================================================================

%% Read and extract the data from your station from the csv file
filename = ['model' num2str(station_number) '.csv'];
%Extract the year and annual mean temperature data

stationdata=readtable(filename);
year=table2array(stationdata(:,1))
amtemp=table2array(stationdata(:,2))
temp_2006=table2array(stationdata(1,2))

%% Calculate the mean and standard deviation of the annual mean temperatures
%  over the baseline period over the first 20 years of the modeled 21st
%  century (2006-2025) - if you follow the template for output values I
%  provided above, you will want to combine these together into an array
%  with both values called baseline_model
 %<-- (this will take multiple lines of code - see the procedure you
 %followed in Part 1 for a reminder of how you can do this)
tempMean = nanmean(amtemp(1:20));
tempStd = nanstd(amtemp(1:20));
baseline_model=zeros(1,2)
baseline_model(1,1)=tempMean
baseline_model(1,2)=tempStd


%% Calculate the 5-year moving mean smoothed annual mean temperature anomaly over the modeled period
% Note that you could choose to provide these as an output if you want to
% have these values available to plot.
 %<-- anomaly
anomly=amtemp-tempMean
 %<-- smoothed anomaly
movemean=movmean(anomly,5)
 
%% Calculate the linear trend in temperature this station over the modeled 21st century period
P= polyfit(year,amtemp,1)
 
end