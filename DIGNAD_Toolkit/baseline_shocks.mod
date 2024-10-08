shocks;

% ----- Public investment profile -----
% Stand investment ex series
var shock0_izi; 
periods 1:50;
values (izi_temp);

var shock1_izi;
periods 1:250;
values (izi_perm);

% Stand investment reconstruction plan
var shocknd_izi; 
periods 1:50;
values (izi_reconst);

% Adapt Investment ex series
var shock0_iza; 
periods 1:50;
values (iza_temp);

var shock1_iza;
periods 1:250;
values (iza_perm);

% ----- Grants profile -----
var shock0_grants;
periods 1:50;
values (gr_temp);

var shock1_grants;
periods 1:250;
values (gr_perm);

var shocknd_grantsizi;
periods 1:50;
values (gr_izi_nd);
      

% ----- Concessional borrowing profile -----
var shock0_d; 
periods  1:50;
values (dconc_temp);

var shock1_d; 
periods  1:250;
values (dconc_perm);

% ----- Oil revenues profile -----
var shock0_oilr; 
periods  1:50;
values (oilr_temp);

var shock1_oilr; 
periods  1:250;
values (oilr_perm);

% ----- Price of exported goods -----
var shock0_px; 
periods  1:50;
values (px_temp);

var shock1_px; 
periods  1:250;
values (px_perm);

% ----- Price of imported consumption goods -----
var shock0_pm; 
periods  1:50;
values (pm_temp);

var shock1_pm; 
periods  1:250;
values (pm_perm);

% ----- Price of imported capital goods -----
var shock0_pmm; 
periods  1:50;
values (pmm_temp);

var shock1_pmm; 
periods  1:250;
values (pmm_perm);

% ----- Tax ceiling VAT ------
var shock0_hbar;
periods 1:500;
values (hbar_sh);

% ----- Tax ceiling Labor ----
var shock0_hlbar;
periods 1:500;
values (hlbar_sh);

% ----- Transfers floor ----
var shock0_Tbar;
periods 1:500;
values (0);


%----- ND shock to Productivity -----
var shocknd_ax;
periods 1:50;    
values (ax_nd_dev); 

var shocknd_an;
periods 1:50;    
values (an_nd_dev); 

%---- ND shock to Capital stocks -----
var shocknd_kx;
periods 1:50;       
values (kx_nd);  

var shocknd_kn;
periods 1:50;
values (kn_nd);

var shocknd_z;
periods 1:50;
values (z_nd);

%---- ND shock to External public debt risk premium -----
var shocknd_rextg;
periods 1:50;       
values (rextg_nd_shock); %(rextg_nd);  

%---- ND shock to Public investment efficiency -----
var shocknd_s;
periods 1:50;       
values (s_nd_reconstdev); 

%---- Scaleup Public investment efficiency -----
var shock_s;
periods 1:50;       
values (sup_s);   

%---- ND shock to Total output -----
var shocknd_yx;
periods 1:50;       
values (yx_nd);  

var shocknd_yn;
periods 1:50;       
values (yn_nd);

%---- ND Fund accumulation and withdrawal ----- 
var shocknd_sav; 
periods 1:50;       
values (sav_temp);  

%---- Timeline -----
var sh_timeline;
periods 2:7;
values (time_line3);

%---- Dummy Tax -----
@#if exogenous
var Dummy_tax;
periods 1:50;
values 0;
@#else
var Dummy_tax;
periods 1:50;
values (dummy_tax);
@#endif

%---- TFP adj -----
var tfp_adj;
periods 1:1000;
values (tfp_shock);

end;