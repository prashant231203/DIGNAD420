% -------------------------------------------------------------------------
% The Debt, Public Investment, and Growth (DIG) Model with Natural
% Disasters
% -------------------------------------------------------------------------

var      

@#include "end_vars.mod"

; 

varexo  

@#include "exo_vars.mod"
tfp_adj shock_s
;

parameters  

@#include "params.mod"

;
                        
load dsa_params.mat;          

for i=1:length(M_.params)
    deep_parameter_name = M_.param_names(i,:);
    eval(['M_.params(i)  = ' deep_parameter_name ' ;'])
end   

%% Model
model;


@#include "model_eqs.mod"

end;

%% Initial values
load steady_state_values.mat;

options_.simul.maxit = itermax;

initval;

T = T_ini;
qx = q_x_ini;
qn = q_n_ini; 
kx = k_x_ini; 
kn = k_n_ini; 
L_x = L_x_ini;
L_n = L_n_ini; 
L = L_ini;
Lh = Lh_ini;
pk = P_k_ini; 
pz = P_z_ini; 
e = e_ini; 
eh = eh_ini;
w = w_ini;
pn = P_n_ini; 
p = P_ini; 
ix = i_x_ini; 
in = i_n_ini; 
h = h_ini; 
rx = r_x_ini; 
rn = r_n_ini; 
r = r_ini; 
bstar = bstar_ini;  
b = bo;
d = do;
dc = dco;
dplot = do;
remit=remito;
grants=grantso;
oilr = oilro;
ynom = yo;
growth_plot = g;
netbwconc = 0;
rextg =rstar+nug;
rext = rextg+nu;
px=1;
pm=1;
pmm=1;
rer = P_n_ini/px;
tot = px/pm;
totmm = px/pmm;
r_d = 0;
GAP = 0;
dc_target = dco;
a_x = a_x_ini;
a_n = a_n_ini;
zi = zi_ini;
zie = zie_ini;
za = za_ini;
zae = zae_ini;
izi = i_zi_ini;
iza = i_za_ini; 
Rzi = R_zi_ini;
Rza = R_za_ini;
Sav = Sav_ini;
zte = zte_ini;
Rzt = Rzt_ini;
s = s_ini;
hl =hl_ini;

end;

steady;
resid(1)
check;
%------------------------
