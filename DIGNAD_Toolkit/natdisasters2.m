%% NATURAL DISASTERS
% IMF RES-DM, 2016, 2022 
% Email dignad@imf.org for inquiries, support or to provide feedback

%% Disable warnings 
warning('off','all');

%% Useful variables for natural disasters
[natdis2_var,natdis2_options, natdis2_all] = xlsread('input_DIG-ND.xlsx','Disasters','C3:D27');
% Timeline for sigmoid function
time_line2 = linspace(1,999,999)';
time_line3 = [1; 1.15; 1.3; 1.45; 1.6; 1.75];
time_line4 = [2; 3.5; 5; 6.5; 8; 9.5; 11; 12.5; 14; 15.5; 17; 18.5; 20; 21.5; 23; 24.5; 26; 27.5; 29; 30.5; 32; 33.5; 35; 36.5; 38];
[tlm4, tln4] = size(time_line4);
tlm4 = 4;
tlm_mon = tlm4*12;
time_line5 = [1; 1.5; 2; 2.5; 3; 3.5; 4; 4.1; 4.2; 4.3; 4.4; 4.5; 4.6; 4.7; 4.8; 4.9; 5; 5.5; 6; 6.5; 7; 7.5; 8; 8.5; 9; 9.5; 10];

if strcmp(natdis2_options(1,2),'yes')
%% Control for damages
ans_n = pvarpi_z*psi_n + pvarpi_k*alpha_n;
ans_x = pvarpi_z*psi_x + pvarpi_k*alpha_x;

if ans_n > 1 | ans_x > 1
   error('Distribution of ND''s impact on public and private capital can''t be greater than 1 (decrease pvarpi_z or pvarpi_k). Decrease pvarpi_z or pvarpi_k in Calibration and restart.');
end
    
 %% Start of disaster  
nn_natdis = natdis2_var(1,1); % t when disaster hits
year_natdis = natdis2_var(1,2); % periods disaster lasts

% Traded sector TFP
nn_ax = natdis2_var(14,1) - year_natdis;         % When does the recovery start
tt_ax = natdis2_var(15,1) - (year_natdis+nn_ax); % How long does it take to recover (in years)
% Non-Traded sector TFP
nn_an = natdis2_var(14,2) - year_natdis-1;
tt_an = natdis2_var(15,2) - (year_natdis+nn_an);
% Reconstruction Efficiency
nn_s = natdis2_var(17,1) - year_natdis-2;
tt_s = natdis2_var(18,1) - (year_natdis+nn_s);
% Public capital 
nn_zi = natdis2_var(20,1) - year_natdis-1;
tt_zi = natdis2_var(21,1) - (year_natdis+nn_zi);
% Risk Premium
nn_rex = natdis2_var(23,1) - year_natdis-1;
tt_rex = natdis2_var(24,1) - (year_natdis+nn_rex);

%% Damages to output

% Take total output losses from input file
yx_nd = natdis2_var(4,2);
yn_nd = natdis2_var(5,2); 

% Accounting for adaptation in the shock
shock_yx_nd = yx_nd./((1+ppi_nd_x*(P_zo*zaeo/yo))^pnu_nd);
shock_yn_nd = yn_nd./((1+ppi_nd_n*(P_zo*zaeo/yo))^pnu_nd);
yn_ndo = shock_yn_nd;
yx_ndo = shock_yx_nd;

% Accounting for exogenous adaptation investment shock
if sum(iza_temp)>0
zaeo2(1) = zaeo;
    for j=2:nn_natdis
        zaeo2(j) = (iza_temp(j) + (1-delta_za)*zaeo2(j-1))/(1+g);
    end
zaeo2 = zaeo2(nn_natdis);

yn_ndo = yn_nd./((1+ppi_nd_n*(P_zo*zaeo2/yo))^pnu_nd);
yx_ndo = yx_nd./((1+ppi_nd_x*(P_zo*zaeo2/yo))^pnu_nd);    
end

%% Calibrate damages to capital stocks (Assuming no effect of adaptation)
damages = xlsread('input_DIG-ND.xlsx','Disasters','D11:D13');
output_losses = xlsread('input_DIG-ND.xlsx','Disasters','D7:D8');
pvarpi_z = log(1-(damages(1)*yo)/(zio*P_zo))/log(1-mean(output_losses));
pvarpi_kx = log(1-(damages(2)*damages(3)*yo)/(k_xo*P_zo))/log(1-output_losses(1));
pvarpi_kn = log(1-(damages(2)*(1-damages(3))*yo)/(k_no*P_zo))/log(1-output_losses(2));
save('dsa_params.mat','pvarpi_kx', 'pvarpi_kn', 'pvarpi_z' ,'-append');


%% Losses of productivity
% Calculates loss of TFP
ax_nd = a_xo*(1-yx_ndo)^(1 - pvarpi_z*psi_x - pvarpi_k*alpha_x);
an_nd = a_no*(1-yn_ndo)^(1 - pvarpi_z*psi_n - pvarpi_k*alpha_n);

% Calculates the recovery path of TFP
ax_nd_t = exp(-pgamma_ax*time_line2(1:tt_ax))*ax_nd + (1-exp(-pgamma_ax*time_line2(1:tt_ax)))*a_xo;
an_nd_t = exp(-pgamma_ax*time_line2(1:tt_an))*an_nd + (1-exp(-pgamma_ax*time_line2(1:tt_an)))*a_no;

% Corrects initial and end points
ax_nd_t = [ax_nd; ax_nd_t];
an_nd_t = [an_nd; an_nd_t];
ax_nd_t(end)= a_xo;
an_nd_t(end)= a_no;

% Calculates growth rate of TFP with respect to SS
ax_nd_growth =  (ax_nd_t-a_xo)/a_xo;
an_nd_growth =  (an_nd_t-a_no)/a_no;

% Incorporates delays to recovery
if nn_ax > 0
   ax_nd_growth = [ax_nd_growth(1).*diag(ones(nn_ax));ax_nd_growth]; 
end
if nn_an > 0
   an_nd_growth = [an_nd_growth(1).*diag(ones(nn_an));an_nd_growth]; 
end

% Sets the timing right
ax_nd_dev = [zeros(nn_natdis-1,1); ax_nd_growth ; zeros(50-nn_natdis-tt_ax+1,1)];
an_nd_dev = [zeros(nn_natdis-1,1); an_nd_growth ; zeros(50-nn_natdis-tt_an+1,1)];
ax_nd_dev = reshape(ax_nd_dev(1:50),[],1);  
an_nd_dev = reshape(an_nd_dev(1:50),[],1);  

%% Damages to Risk premium
% Calculates the decrease in risk premium on impact
rextg_nd = natdis2_var(7,2);

% Calculate the recovery path
rex_temp = exp(-pgamma_rdc*time_line2(1:tt_rex))*rextg_nd;

% Corrects initial and end points
rex_temp = [rextg_nd; rex_temp];
rex_temp(end) = 0;

% Incorporates delays to recovery
if nn_rex > 0
   rex_temp = [rex_temp(1).*diag(ones(nn_rex));rex_temp];
end

% Sets the timing right
rextg_nd_shock = [zeros(nn_natdis-1,1); rex_temp; zeros(50-nn_natdis-tt_rex,1)];
rextg_nd_shock = reshape(rextg_nd_shock(1:50),[],1);

%% pie
sup_s = zeros(50,1);

%% Damages to public investment efficiency
% Calculates the decrease in PIE on impact
s_nd = natdis2_var(6,2);
s_afternd = (1-s_nd)*s_o;

% Calculate recovery path
s_nd_reconst = exp(-pgamma_s*time_line2(1:tt_s))*s_afternd + (1-exp(-pgamma_s*time_line2(1:tt_s)))*s_o;

% Corrects initial and end points
s_nd_reconst = [s_afternd; s_nd_reconst];
s_nd_reconst(end)= s_o;

% Calculate the growth rate with respect to SS
s_growth_rate = (s_nd_reconst-s_o)/s_o;

% Incorporates delays to recovery
if nn_s > 0
   s_growth_rate = [s_growth_rate(1).*diag(ones(nn_s));s_growth_rate];
end

% Sets the timing right
s_nd_reconstdev = [zeros(nn_natdis,1); s_growth_rate ; zeros(50-nn_natdis-tt_s+1,1)];
s_nd_reconstdev = reshape(s_nd_reconstdev(1:50),[],1);

if nn_s > 0
    s_nd_reconst_temp = [s_nd_reconst(1).*diag(ones(nn_s));s_nd_reconst];
    s_nd_reconst_temp_dev = [s_o*ones(nn_natdis,1); s_nd_reconst_temp ; s_o*ones(50-nn_natdis-tt_s+1,1)];
    s_nd_reconst_temp_dev = reshape(s_nd_reconst_temp_dev(1:50),[],1);
    s_nd_tot = sup_s + s_nd_reconst_temp_dev;
else
    s_nd_reconst_temp = s_nd_reconst;
    s_nd_reconst_temp_dev = [s_o*ones(nn_natdis,1); s_nd_reconst_temp ; s_o*ones(50-nn_natdis-tt_s+1,1)];
    s_nd_reconst_temp_dev = reshape(s_nd_reconst_temp_dev(1:50),[],1);  
    s_nd_tot = sup_s + s_nd_reconst_temp_dev;
end

%% Public capital destruction
% Calculates public capital damages
zio_izi(1) = zio;
for j=2:nn_natdis+1
    zio_izi(j) = ((s_nd_tot(j-1)/s_o)*izi_temp(j-1) + (s_nd_tot(j-1)/s_o)*i_zi_ini + (1-delta_zi)*zio_izi(j-1))/(1+g);  %update to account for inefficiency
end

zio_izi = zio_izi(nn_natdis+1);

if sum(izi_temp)==0 & sum(sup_s)==0
    zio_izi = zio;
end
zio_nd = zio_izi*(1 - (yn_ndo+yx_ndo)/2 )^(pvarpi_z);

%% Public capital reconstruction
% Calculates the recovery path of public capital
zie_temp = ( exp(-pgamma_zi*time_line2(1:tt_zi))*zio_nd + (1-exp(-pgamma_zi*time_line2(1:tt_zi)))*zio_izi );

% Corrects initial and end points
zie_temp(end)= zio_izi;
zie_reconst = [zio_nd; zie_temp];

% Incorporates delays to recovery
if nn_zi > 0
   zie_reconst = [zie_reconst(1).*diag(ones(nn_zi));zie_reconst]; 
end

zio_temp2(1) = zio_nd;
for j=2:size(zie_reconst,1)
    zio_temp2(j) = ((s_nd_tot(nn_natdis+j-1)/s_o)*izi_temp(nn_natdis+j-1) + (s_nd_tot(nn_natdis+j-1)/s_o)*i_zi_ini + (1-delta_zi)*zio_temp2(j-1))/(1+g);
end

zio_temp2 = zio_temp2';

%% Public infrastructure reconstruction investment
zio_temp3 = max(zie_reconst,zio_temp2);

for j= 2:tt_zi+nn_zi+1
    izi_reconst(j-1) = ((1+g)*zio_temp3(j) - (1-delta_zi)*zio_temp3(j-1) - (s_nd_tot(nn_natdis+j-1)/s_o)*i_zi_ini - (s_nd_tot(nn_natdis+j-1)/s_o)*izi_temp(nn_natdis+j-1))/(s_nd_tot(nn_natdis+j-1)/s_o);
end

izi_reconst = reshape(izi_reconst(1:tt_zi+nn_zi),[],1);
izi_reconst = [zeros(nn_natdis,1);izi_reconst; zeros(50-nn_natdis,1)];  
izi_reconst = reshape(izi_reconst(1:50),[],1);
 
yx_nd = [zeros(nn_natdis-1,1); yx_nd; zeros(50-nn_natdis,1)];
yn_nd = [zeros(nn_natdis-1,1); yn_nd; zeros(50-nn_natdis,1)];

%% Other shocks
qxa_nd = 0;
qna_nd = 0;

z_nd = 0;   
kx_nd = 0;  
kn_nd = 0; 

gr_izi_nd = 0;
gr_iza_nd = 0;

else
z_nd = 0;
kx_nd = 0;
kn_nd = 0;
qxa_nd = 0;
qna_nd = 0;
gr_izi_nd = 0;
gr_iza_nd = 0;
rextg_nd = 0;
rextg_nd_shock = 0;
sav_temp = 0;
sav_nd = 0;
izi_reconst = 0;
yn_nd = 0;
yx_nd = 0;
s_nd_reconstdev = 0;
pvarpi_kx = pvarpi_k;    % Severity of damages to private capital
pvarpi_kn = pvarpi_k; 
ax_nd_dev = 0 ;
an_nd_dev =0 ;
sup_s = 0;
end
