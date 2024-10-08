%% INITIAL PARAMETERS AND STEADY STATE VALUES
% IMF RES-DM, 2016, 2022 
% Email DIGNAD@imf.org for inquiries, support or to provide feedback

%% IMPORT PARAMETERS
% NOTE: Do not change format of 'input_DIG-ND.xlsx' excel file.
[ndata, text, alldata] = xlsread('input_DIG-ND.xlsx','Calibration','E2:H75');
[mmm,nnn] = size(ndata);
param_names  = char(text(1:mmm));
param_values = ndata(1:mmm, calib);
for i = 1:mmm                                  
  paramname = deblank(param_names(i,:));                   
  eval([ paramname ' = param_values(' int2str(i) ');']);
end
load('scen.mat')

%% Parameters hardcoded
% NOTE: Do not change format of 'input_DIG-ND.xlsx' excel file.
sigmah = 1/tau ;         % Inverse of Intertemporal elasticity of substitution
s_s = s_o;               % Steady state efficiency of public infrastructure investment
ppi_nd_x = ppi_nd_n;     % Scaling parameter in ability of adaptation capital to withstand natural disaster T&NT-sector
pgamma_an = pgamma_ax;   % Speed of recovery of nontradable sector TFP
hbar = ho +0.02;         % Consumption tax rate (VAT) ceiling
hlbar = hlo;             % Labor income tax rate ceiling
epsilon = 0.5 ;          % Intratemporal elasticity of substitution across goods
yo = 100 ;               % GDP
prho_z = 0.9;            % Weight of standard infrastructure in total infrastructure
pxi_z = 50 ;             % Intratemporal elasticity of substitution between public capital inputs (standard vs. adaptation)
xi_x  = xi_n ;           % Capital learning externalities in T-sector
pvarpi_z = 0.7;          % Severity of damages to public capital
pvarpi_k = 0.3;          % Severity of damages to private capital
pnu_nd = 1;              % Concavity parameter in ability of adaptation capital to withstand natural disaster
dummy_tax = 0;           % Dummy tax  
Savo = Savo*yo;          % Contingency fund (Natural disaster fund)

%% Import exogenous shocks
exogenous_shocks = xlsread('input_DIG-ND.xlsx','Exogenous_series','B4:AQ54');
time_periods = exogenous_shocks(1:50,1);
time_years = exogenous_shocks(1:50,2);
time_line = time_years(1)-2+linspace(1,999,999)';
hbar_sh = hbar-ho;
hlbar_sh =hlbar-hlo;
if strcmp(temporary,'no')
izi_temp = zeros(50,1);
iza_temp = zeros(50,1);
gr_temp = zeros(50,1); 
dconc_temp = zeros(50,1);
oilr_temp = zeros(50,1);
sav_temp = zeros(50,1);
px_temp = zeros(50,1);
pm_temp = zeros(50,1);
pmm_temp = zeros(50,1);
else   
izi_temp = [exogenous_shocks(1:nn_temp,-5+exopath*8); zeros(50-nn_temp,1)];  % standard investment
iza_temp = [exogenous_shocks(1:nn_temp,-4+exopath*8); zeros(50-nn_temp,1)]; % adaptation investment 
oilr_temp = 0;
sav_temp = [exogenous_shocks(1:nn_temp,-3+exopath*8); zeros(50-nn_temp,1)];
gr_temp = [exogenous_shocks(1:nn_temp,-2+exopath*8); zeros(50-nn_temp,1)];
dconc_temp = [exogenous_shocks(1:nn_temp,-1+exopath*8); zeros(50-nn_temp,1)];
px_temp = [exogenous_shocks(1:nn_temp,exopath*8); zeros(50-nn_temp,1)];
pm_temp = [exogenous_shocks(1:nn_temp,1+exopath*8); zeros(50-nn_temp,1)];
pmm_temp = [exogenous_shocks(1:nn_temp,2+exopath*8); zeros(50-nn_temp,1)];
end
izi_perm = 0;
iza_perm = 0;
gr_perm = 0; 
dconc_perm = 0;
oilr_perm = 0;
px_perm = 0;
pm_perm = 0;
pmm_perm = 0;

%% OTHER PARAMETERS AND INITIAL VALUES
bo      = share_b*yo;
bstaro  = share_bstar*yo;
do      = share_d*yo;
dco     = share_dc*yo;
P_no    = 1;
P_xo    = 1;
P_mo    = 1;
P_mmo   = 1;
Po      = 1;
wo      = 1;
P_ko    = 1/(1-alpha_k);
P_zo    = 1/(1-alpha_z);
a_k     = alpha_k/(1-alpha_k);
a_z     = alpha_z/(1-alpha_z);
beta    = ((1+g)^(1/tau))/(1+ro); %- Helping parameter
beta_t  = (beta*(1+g)^(1-1/tau)); %- Discount factor
ro      = ((1+g)^(1/tau))/beta-1;
r_xo    = P_ko*(ro+delta_x);
r_no    = P_ko*(ro+delta_n);
miu     = fo*P_zo*delta_zi;
nu_x    = 1/((delta_x+g)*omega);
nu_n    = 1/((delta_n + g)*omega);
zio      = iziy*yo/(P_zo*(delta_zi+g));
zieo     = s_s*zio;
zao      = izay*yo/(((1+a_za)*P_zo)*(delta_za+g));
zaeo     = s_s*zao;
remito  = share_remit*yo;
grantso = share_grants*yo;
oilro   = oilro*yo;
dploto  = do;
nug     = r_dco-rstar;
nu      = ro-r_dco;
q_no    = VA_n*yo;
q_xo    = (1-VA_n)*yo;
k_no    = (alpha_n/r_no)*q_no;
k_xo    = (alpha_x/r_xo)*q_xo;
L_no    = ((1-alpha_n)/wo)*q_no;
L_xo    = ((1-alpha_x)/wo)*q_xo;
Lo     = (L_no+L_xo)/(1+a_ratio);
Lho     = (a_ratio)*Lo;
i_zio    = (delta_zi+g)*zio;
izi_temp = izi_temp/P_zo;
izi_perm = izi_perm/P_zo;
i_zao    = (delta_za+g)*zao;
iza_temp = iza_temp/((1+a_za)*P_zo);
iza_perm = iza_perm/((1+a_za)*P_zo);
b_nx = R_zao/R_zio;
b_x = b_nx;
b_n = b_nx;
zteo = zieo + b_nx*zaeo;
zto = zio + b_nx*zao;
R_zto = R_zio; 

%% SOLVING FOR PARAMETERS VA_n, eo, eho, To, AND psi_x

% Set initial values
xn0 = [0.5 77 80 8 0.5 0.5]';
x = broyden('calibration',xn0,VA_n,imp2gdp,a_k,delta_x,g,alpha_x,yo,delta_n,alpha_n,a_z,delta_zi,delta_za,P_ko,P_zo,do,dco,r_dco,bstaro,rstar,R_zio,R_zao,b_n,b_x,zio,zao,remito,grantso,oilro,wo,nxpsi,a_ratio,ho,bo,ro,miu,zieo,zaeo,s_s,nu,nug,k_xo,k_no,q_xo,q_no,Savo,zteo,R_zto,hlo,a_za);
x = real(x);
[f, xcal] = calibration(x,VA_n,imp2gdp,a_k,delta_x,g,alpha_x,yo,delta_n,alpha_n,a_z,delta_zi,delta_za,P_ko,P_zo,do,dco,r_dco,bstaro,rstar,R_zio,R_zao,b_n,b_x,zio,zao,remito,grantso,oilro,wo,nxpsi,a_ratio,ho,bo,ro,miu,zieo,zaeo,s_s,nu,nug,k_xo,k_no,q_xo,q_no,Savo,zteo,R_zto,hlo,a_za);
gama_n = xcal(1);
eo     = xcal(2);
eho    = xcal(3);
To     = xcal(4);
psi_x  = xcal(5);
gama_m = xcal(6);

%% Using gama_n, gama_m, eo, eho, To, and psi_x to calculate the rest of parameters and initial values
kappah = wo*(eo^-sigmah)*(1/Po)*((1-hlo)/(1+ho))*(1/(Lo^phhi));
gama_x  = 1-gama_n-gama_m;
rho_x   = gama_x;
rho_m   = gama_m;
psi_n   = nxpsi*psi_x;
a_no    = q_no/(zteo^psi_n * k_no^(xi_n+alpha_n) * L_no^(1-alpha_n)); 
a_xo    = q_xo/(zteo^psi_x * k_xo^(xi_x+alpha_x) * L_xo^(1-alpha_x));

%% INITIAL STEADY STATE VALUES
inc         = 1;
incdc       = 1;
incb        = 1;
inciz       = 0;
incgrants   = 1;
incremit    = 1;
P_x         = P_xo;
P_mm        = P_mmo;
P_m         = P_mo;

% Set initial values
x0 = [bstaro eo+eho (1-rho_x-rho_m)*(eo+eho) eo eho ho (delta_n+g)*k_no (delta_x+g)*k_xo k_no k_xo L_no L_xo Po P_ko P_no P_zo ro r_no r_xo To q_no q_xo wo yo zio zieo zao zaeo Lo Lho hlo]';
% Use Broyden Method to solve the system of equations
x = broyden('steady_state',x0,beta_t,delta_x,delta_n,delta_zi,delta_za,tau,psi_x,psi_n,xi_n,xi_x,alpha_x,alpha_n,g,epsilon,eta,ho,rstar,s_o,rho_x,rho_m,a_k,a_z,miu,ro,To,do,bo,zio,zao,b_n,b_x,P_zo,P_x,P_mm,P_m,a_no,a_xo,inc,r_dco,incdc,dco,incb,inciz,lambda,eo,eho,s_s,a_ratio,remito,grantso,oilro,i_zio,i_zao,incgrants,incremit,sigma_x,sigma_n,nu,bstaro,q_no,q_xo,yo,etag,nug,Savo,zteo,kappah,sigmah,phhi,hlo,wo,Lo, a_za);
x = real(x);
[f, xss] = steady_state(x,beta_t,delta_x,delta_n,delta_zi,delta_za,tau,psi_x,psi_n,xi_n,xi_x,alpha_x,alpha_n,g,epsilon,eta,ho,rstar,s_o,rho_x,rho_m,a_k,a_z,miu,ro,To,do,bo,zio,zao,b_n,b_x,P_zo,P_x,P_mm,P_m,a_no,a_xo,inc,r_dco,incdc,dco,incb,inciz,lambda,eo,eho,s_s,a_ratio,remito,grantso,oilro,i_zio,i_zao,incgrants,incremit,sigma_x,sigma_n,nu,bstaro,q_no,q_xo,yo,etag,nug,Savo,zteo,kappah,sigmah,phhi,hlo,wo,Lo, a_za);
    
    bstar_ini = xss(1);
    c_ini     = xss(2);
    c_n_ini   = xss(3);
    e_ini     = xss(4);
    eh_ini    = xss(5);
    h_ini     = xss(6);
    i_n_ini   = xss(7);
    i_x_ini   = xss(8);
    k_n_ini   = xss(9);
    k_x_ini   = xss(10);
    L_n_ini   = xss(11);
    L_x_ini   = xss(12);
    P_ini     = xss(13);
    P_k_ini   = xss(14);
    P_n_ini   = xss(15);
    P_z_ini   = xss(16);
    r_ini     = xss(17);
    r_n_ini   = xss(18);
    r_x_ini   = xss(19);
    T_ini     = xss(20);
    q_n_ini   = xss(21);
    q_x_ini   = xss(22);
    w_ini     = xss(23);
    y_ini     = xss(24);
    zi_ini     = xss(25);
    zie_ini    = xss(26);
    za_ini     = xss(27); 
    zae_ini    = xss(28);
    L_ini      = xss(29);
    Lh_ini     = xss(30);
    hl_ini     = xss(31);
    
%% USING INITIAL STEADY STATE VALUES
R_zi_ini = R_zio; 
i_zi_ini = (delta_zi+g)*zi_ini;
R_za_ini = R_zao;
i_za_ini = (delta_za+g)*za_ini;
b_ini   = bo;
d_ini   = do;
dc_ini  = dco;
r_do = 0;
rextgo = r_dco;
a_x_ini = a_xo;
a_n_ini = a_no;
Sav_ini = Savo;
zte_ini = zteo;
Rzt_ini = R_zto;
s_ini = s_o;
hl_ini = hlo;

if realism_ind ==1
ppi_nd_x = ppi_temp;
ppi_nd_n = ppi_temp;
end

%% SAVE PARAMETERS AND INITIAL STEADY STATE VALUES

save dsa_params.mat beta beta_t delta_x delta_n delta_zi delta_za alpha_k alpha_z ...
    tau psi_x psi_n xi_n xi_x omega alpha_x alpha_n g epsilon gama_n ...
    gama_x gama_m eta rho_x rho_m yo phi ho r_do rstar ... 
    share_bstar share_b share_d fo s_o a_k a_z miu nu_x nu_n VA_n ro To ...
    do bo P_zo Lho a_no a_xo r_dco dco lambda lambda1 lambda2 ... 
    lambda3 lambda4 eo eho s_s a_ratio nxpsi share_remit  ...  
    share_grants remito grantso sigma_x sigma_n nu q_xo ...  
    q_no bstaro etag nug imp2gdp time_periods time_years upsilon ...
    b_x b_n R_zio R_zao zio zao zieo zaeo i_zio i_zao Savo ...
    b_nx prho_z pxi_z pnu_nd ppi_nd_n ppi_nd_x pvarpi_z a_za...
    pvarpi_k pgamma_zi pgamma_s pgamma_an pgamma_ax kappah sigmah phhi Lo Lho hlo wo;

save steady_state_values.mat b_ini d_ini dc_ini bstar_ini c_ini e_ini ...
    eh_ini h_ini i_n_ini i_x_ini k_n_ini k_x_ini L_n_ini ... 
    L_x_ini P_ini P_k_ini P_n_ini P_z_ini r_ini r_n_ini r_x_ini ...
    q_n_ini q_x_ini w_ini T_ini ... 
    c_n_ini a_x_ini a_n_ini ...
    zi_ini zie_ini za_ini zae_ini i_zi_ini i_za_ini R_zi_ini R_za_ini ...
    Sav_ini zte_ini Rzt_ini L_ini Lh_ini hl_ini; 

