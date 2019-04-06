
% Example code to compute Spillover Asymmetry Measure (SAM) introduced in
%
% BARUN?K, J., KO?ENDA, E. and V?CHA, L., 2016. Asymmetric connectedness on the U.S. stock market: 
% Bad and good volatility spillovers. 
% Journal of Financial Markets, 27, pp. 55-78. 
%
% The codes replicates the results for financial industry
% by J.Barunik (c) 2015

%% REALIZED MEASURES
%
% First step is to obtain Realized Semivariance
% Save 5-minute high-frequency returs of one day to variable "data" and then

% RSp=sum((data.^2).*(data>0));    % Semivariance (positive)
% RSn=sum((data.^2).*(data<0));    % Semivariance (negative)

% In this code, however, I use prepared data, as I can not distribute 5-min data by licence


%% Compute original DY 2012 directional indices

% chose horizons and lag length
H=10;
lags=2;

% Load realized variance for Financial sector

load spilloverdatastocksRV.txt
data = spilloverdatastocksRV;
[ T vars ] = size(data);

for t=1:T-199
    
    [ S_VAR_table_G] = VAR_Spillover_table_directional(data(t:t+199,:), H, lags);
    
    %S_VAR_table
    spilloverG(t) = 100*(sum(sum(S_VAR_table_G))-sum(diag(S_VAR_table_G)))/sum(sum(S_VAR_table_G));
    
    % sum rows
    spilloverGfrom(t,:) = (100*(sum(S_VAR_table_G')'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    % sum columns
    spilloverGto(t,:) = (100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    
    c=0;
    for i=1:vars
        for j=1:vars
            if i ~= j
                c=c+1;
                spilloverGnetpair(t,c) = 100*(S_VAR_table_G(j,i)/sum(sum(S_VAR_table_G)) - S_VAR_table_G(i,j)/sum(sum(S_VAR_table_G)));
            end
        end
    end
end

spilloversGnet = spilloverGfrom  - spilloverGto;

%% Compute Spillovers from Negative Semivariance

% load Negative Semivariance
load spilloverdatastocksRVn.txt
datan = spilloverdatastocksRVn;

for t=1:T-199
    
    [ S_VAR_table_G] = VAR_Spillover_table_directional(datan(t:t+199,:), H, lags);
    
    %S_VAR_table
    
    spilloverGn(t) = 100*(sum(sum(S_VAR_table_G))-sum(diag(S_VAR_table_G)))/sum(sum(S_VAR_table_G));
    
    % sum rows
    spilloverGfromn(t,:) = (100*(sum(S_VAR_table_G')'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    % sum columns
    spilloverGton(t,:) = (100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    
    c=0;
    for i=1:vars
        for j=1:vars
            if i ~= j
                c=c+1;
                spilloverGnetpairn(t,c) = 100*(S_VAR_table_G(j,i)/sum(sum(S_VAR_table_G)) - S_VAR_table_G(i,j)/sum(sum(S_VAR_table_G)));
            end
        end
    end
end

spilloversGnetn = spilloverGfromn  - spilloverGton;

%% Compute Spillovers from Positive Semivariance

% load Negative Semivariance
load spilloverdatastocksRVp.txt
datap = spilloverdatastocksRVp;

for t=1:T-199
    
    [ S_VAR_table_G] = VAR_Spillover_table_directional(datap(t:t+199,:), H, lags);
    
    %S_VAR_table
    
    spilloverGp(t) = 100*(sum(sum(S_VAR_table_G))-sum(diag(S_VAR_table_G)))/sum(sum(S_VAR_table_G));
    
    % sum rows
    spilloverGfromp(t,:) = (100*(sum(S_VAR_table_G')'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    % sum columns
    spilloverGtop(t,:) = (100*(sum(S_VAR_table_G)'-diag(S_VAR_table_G'))./sum(sum(S_VAR_table_G)))';
    
    
    c=0;
    for i=1:vars
        for j=1:vars
            if i ~= j
                c=c+1;
                spilloverGnetpairp(t,c) = 100*(S_VAR_table_G(j,i)/sum(sum(S_VAR_table_G)) - S_VAR_table_G(i,j)/sum(sum(S_VAR_table_G)));
            end
        end
    end
end

spilloversGnetp = spilloverGfromp  - spilloverGtop;


%% Plot indices 

% Diebold-Yilmaz (2012) spillover index
% Figure 4a in Barunik et al. (2016) for financials (row 1 left)

plot(spilloverG)

% SAM index
% Figure 4a in Barunik et al. (2016) for financials (row 1 right)

plot(spilloverGp-spilloverGn)

% Directional SAM
% elements of the Figure5 can be obtained as 

plot(spilloverGtop-spilloverGton)

plot(spilloverGfromp-spilloverGfromn)

