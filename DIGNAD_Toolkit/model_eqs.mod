//%------------------------------------------------------------------------
//%              Helping variables 
//%------------------------------------------------------------------------
//%- Adjustment costs in changing the capital stock
#Robx =(nu_x/2)*kx(-1)*((ix/kx(-1)) - delta_x - g)^2; 
#Robn =(nu_n/2)*kn(-1)*((in/kn(-1)) - delta_n - g)^2;

//%- Analogue of (1-rho_x-rho_m)*(pn/p)^(-epsilon)  
#compn = (1-rho_x-rho_m)*pn^(-epsilon)/(rho_m*pm^(1-epsilon)+rho_x*px^(1-epsilon)+(1-rho_x-rho_m)*pn^(1-epsilon));
#Jimz = 1 ; 

//%------------------------------------------------------------------------
//%            Actual equations 
//%------------------------------------------------------------------------
//%- Cobb-Douglas technologies of the firms in each sector - New
[name='Output - Tradable']
qx = a_x*(qx/q_xo)^sigma_x*(zte(-1)^psi_x)*(kx(-1)^(xi_x + alpha_x))*(L_x^(1 - alpha_x));
[name='Output - Nontradable']
qn = a_n*(qn/q_no)^sigma_n*(zte(-1)^psi_n)*(kn(-1)^(xi_n + alpha_n))*(L_n^(1 - alpha_n));

//% Public Capital
[name='Public Capital']
zte = (zie + b_nx*zae); % Perfect substitutes


//% TFP
[name='TFP - Tradable']
a_x = (1+shocknd_ax+tfp_adj/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))*a_xo;
[name='TFP - Nontradable']
a_n = (1+shocknd_an+tfp_adj/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))*a_no; 

//%- Supply prices of pvt and public capital
[name='Prices - private capital']
pk = pmm + a_k*pn;
[name='Prices - public capital']
pz = pmm + a_z*pn;

//%- CPI (relative) associated with CES consumption basket
[name='CPI']
p = (rho_m*pm^(1-epsilon) + rho_x*px^(1-epsilon) + (1-rho_m-rho_x)*pn^(1-epsilon))^(1/(1-epsilon));

//%- First-order conditions of the consumers' maximization problem
[name='FOC']
((e(+1)/p(+1))/(e/p))^(1/tau) = beta_t*(1+h)*(1+r)/((1+h(+1))*(1+g));
(1+r)*(p(+1)/p)*(pk/pk(+1))*(1 + nu_x*((ix/kx(-1))-delta_x-g)) = (rx(+1)/pk(+1)) + (1-delta_x) + nu_x*((ix(+1)/kx)-delta_x-g)*((ix(+1)/kx)+1-delta_x) - (nu_x/2)*(((ix(+1)/kx)-delta_x-g)^2);
(1+r)*(p(+1)/p)*(pk/pk(+1))*(1 + nu_n*((in/kn(-1))-delta_n-g)) = (rn(+1)/pk(+1)) + (1-delta_n) + nu_n*((in(+1)/kn)-delta_n-g)*((in(+1)/kn)+1-delta_n) - (nu_n/2)*(((in(+1)/kn)-delta_n-g)^2);
1+rext=(1-eta*(bstar-bstaro))*(1+r)*p(+1)/p;


//%- Law of motion of pvt capital in each sector
[name='Private capital-Tradable']
(1+g)*kx = (ix + (1-delta_x)*kx(-1)) * (1 - shocknd_yx/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))^(pvarpi_kx); 
[name='LoM - private capital-Nontradable']
(1+g)*kn = (in + (1-delta_n)*kn(-1)) * (1 - shocknd_yn/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))^(pvarpi_kn); 


//%- Law of motion of public capital (normal) - New
[name='Public standard capital']
(1+g)*zi = ((s/s_o)*(izi) + (1-delta_zi)*zi(-1)) * (1 - ((shocknd_yx+shocknd_yn)/2)/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))^(pvarpi_z); 
[name='Standard effective capital']
zie = s_o*zi;


//%- Public investment efficiency
[name='Public investment efficiency']
s = (1+shocknd_s+shock_s)*s_o; 

//%- Law of motion of public adaptation capital - New 
[name='LoM - public adaptation capital']
(1+g)*za = ((s/s_o)*iza + (1-delta_za)*za(-1)) * (1 - ((shocknd_yx+shocknd_yn)/2)/((1+ppi_nd_x*(P_zo*zae/yo))^pnu_nd))^(pvarpi_z);
[name='Adaptation effective capital']
zae = s_o*za;


//%- Marginal product of capital and labor in each sector (i.e. T and NT); wage is equal across the sectors;
[name='w']
pn*(1-alpha_n)*qn/L_n = w;
px*(1-alpha_x)*qx/L_x = w;
[name='r']
pn*alpha_n*qn/kn(-1) = rn;
px*alpha_x*qx/kx(-1) = rx;

//%- Market clearing conditions - New
[name='MCC']
qn = compn*(e+eh) + a_k*(ix+in+Robx+Robn) + a_z*Jimz*izi + a_z*(1+a_za)*iza;

//%- Market clearing conditions - Labor
[name='Total Labor']
L_x + L_n = L+Lh;
[name='FOC-Labor']
p*kappah*(L^phhi)*(1+h)=(1-hl)*w*((e)^(-sigmah));
[name='Labor-Nonsavers']
Lh = (a_ratio)*L ;

//%- Market clearing: acounting identity - growth in the country's net foreign debt equals the national spending less national income - New
[name='Market Clearing']
d + dc + bstar - Sav = (e+eh) + pk*(ix+in+Robx+Robn) + pz*Jimz*izi + (1+a_za)*pz*iza + (1+r_d)*d(-1)/(1+g)+ (1+rextg(-1))*dc(-1)/(1+g) + (1+rext(-1))*bstar(-1)/(1+g) + (eta/2)*(bstar-bstaro)^2 - (pn*qn) - (px*qx) - (grants+oilr) - remit - (1+rstar)*Sav(-1)/(1+g);

//%- Non-savers' budget constraint
[name='Budget Constraint Nonsavers']
eh = ((1-hl)*w*Lh+(a_ratio/(1+a_ratio))*(T+remit))/(1+h);

//%- Gross return on infrastructure (note, pn*qn=VA_n) - New
[name='Return on Infrastructure']
Rzt = (psi_n*pn*qn+psi_x*px*qx)/(pz*zte(-1));
[name='Return on Standard Infrastructure']
Rzi = Rzt;
[name='Return on Adaptation Infrastructure']
Rza = b_nx*Rzi;

//%- RIRs
//%- |rextg| - in paper named |r_dc|
//%- |rstar| - in paper named |r_f|
//%- |rext|  - in paper named |r*|
//%- |nu|    - public debt risk premium
[name='r_dc']
rextg = (rstar+(nug+shocknd_rextg)*exp(etag*(d/ynom+dc/ynom-do/yo-dco/yo)));
[name='r*']
rext = rextg+nu;

//%- Nominal GDP
[name='Nominal GDP']
ynom = pn*qn + px*qx ;

[name='Growth plot']
growth_plot = (qn-qn(-1))/qn(-1) + (qx-qx(-1))/qx(-1) + g; % growth_plot is created just to plot the path of actual GDP growth

#uazuaz = yo/ynom;
//%------------------------------------------------------------------------
//%         Fiscal GAP and adjustment via transfers (T) and taxes (h) 
//%------------------------------------------------------------------------
//%- Note: e+eh = p*c (sum of expenditures of savers(e) & non-savers(eh) equals overall value of consumption) - New
#DD = ((1+r_d)*d(-1)/(1+g) - d) + ((1+rextg(-1))*dc(-1)/(1+g) - dc) + ((1+r(-1))*p*b(-1)/(1+g) - p*b) + (pz*Jimz*izi) + ((1+a_za)*pz*iza) + To - ho*(e+eh) - (grants+oilr) - miu*zie(-1) - ((1+rstar)*Sav(-1)/(1+g) - Sav)-(hl-hlo)*w*(1+a_ratio)*L;
#DDo = (r_d-g)*do/(1+g) + (rstar+nug-g)*dco/(1+g) + (ro-g)*bo/(1+g) + P_zo*(delta_zi+g)*zio + (1+a_za)*P_zo*(delta_za+g)*zao + To - ho*(eo+eho) - (grantso+oilro) - miu*zieo - (rstar-g)*Savo/(1+g) - (hl-hlo)*wo*(1+a_ratio)*Lo ;


//%- Defining the targets (h_target and T_target)
#h_target = ho + lambda_h*(GAP)/(e+eh);
#T_target = (To - lambda*GAP);
#hl_target = hlo + lambda_hl*(GAP)/(w*(L+Lh));  

#h1 = h(-1) + lambda1*(h_target-h(-1)) + lambda2*(dc(-1)-dc_target)/(pn*qn + px*qx);
#T1 = T(-1) + lambda3*(T_target-T(-1)) - lambda4*(dc(-1)-dc_target);
#hl1 = hl(-1) + lambda5*(hl_target-hl(-1)) + lambda6*(dc(-1)-dc_target)/(pn*qn + px*qx);


//%- Fiscal gap
@#if exogenous
   //%- I. For the unconstrained fiscal adjustment, i.e. for concessional debt only
[name='GAP1']
GAP = (DD - DDo) ;
@#else
   //%- II. For the constrained fiscal adjustment, i.e. for  endogenous borrowing only 
[name='DD']
   (h-ho)*(e+eh) - (T-To) + (hl-hlo)*w*(L+Lh) = DD ;
[name='GAP']
   GAP = (dc-dc(-1)) + (p*b-p*b(-1)) + (h-ho)*(e+eh) - (T-To) - (Sav-Sav(-1)) + (hl-hlo)*w*(L+Lh) ;
@#endif

//%------------ Different specifications of taxes and transfers -----------
//%- (0) Transfers and taxes at the target level
@#if exogenous
[name='Transfers']
   T = T_target/uazuaz;
[name='VAT1']
   h = h_target;
[name='PT1']
   hl= hl_target;
@#endif


//%- (1) Exogenous ceiling path for taxes (hbar_staggered). 
#hbar_staggered = ho + shock0_hbar ;
#hlbar_staggered = hlo + shock0_hlbar ;
@#if endogenous_commercial || endogenous_domestic || all_debt
[name='VAT']
    h =  Dummy_tax*h1 + (1-Dummy_tax)*ho;
[name='PT']
    hl =  Dummy_tax*hl1 + (1-Dummy_tax)*hlo;
 @#endif

//%- (2) Exogenous floor path for transfers (Tbar_staggered).
#Tbar_staggered = To + shock0_Tbar;
@#if endogenous_commercial || endogenous_domestic || all_debt
  [name='Transfers']
    T =  Dummy_tax*T1 +(1-Dummy_tax)*To;
@#endif

//%------------------------------------------------------------------------
//%         Creating exogenous profiles 
//%------------------------------------------------------------------------
//%- Exogenous concessional borrowing
[name='Concessional borrowing']
d = do*g/(1+g) + d(-1)/(1+g) + shock0_d/uazuaz + shock1_d/uazuaz - shockneg0_d/uazuaz - shockneg1_d/uazuaz;
netbwconc = shock0_d + shock1_d - shockneg0_d - shockneg1_d ;
dplot = shock0_d + shock1_d - shockneg0_d - shockneg1_d + dplot(-1); % dplot is created just to plot the path of actual d, not d deflated by trend growth.

//%- Exogenous domestic borrowing (either if the fiscal adjustment is unconstrained or if the adjustment comes from external commercial debt)
@#if exogenous
   b =  bo;
@#endif
@#if endogenous_commercial
   b = bo;
@#endif

//%- Exogenous commercial borrowing (either if the fiscal adjustment is unconstrained or if the adjustment comes from internal public debt)
@#if exogenous
   dc = dco;
@#endif
@#if endogenous_domestic
   dc = dco;
@#endif

//%- All debt scenario 
@#if all_debt
   upsilon*(dc-dc(-1)) = (1-upsilon)*p*(b-b(-1));
@#endif

//%- Domestic savings withdrawals (Natural Disaster Fun)
Sav = (Sav(-1) + shocknd_sav);

//%- Exogenous public investment - New
#uaz = pz/P_zo*yo/ynom;
izi = (delta_zi+g)*zio + shock0_izi + shocknd_izi; 
iza = (delta_za+g)*zao + shock0_iza  ;



//%- Exogenous grants, oil, and remittance revenues
grants*uazuaz = grantso + shock0_grants + shock1_grants - shockneg0_grants - shockneg1_grants + shocknd_grantsizi + shocknd_grantsiza;
oilr*uazuaz = oilro + shock0_oilr + shock1_oilr - shockneg0_oilr - shockneg1_oilr;
remit*uazuaz = remito + shock0_remit - shockneg0_remit - shockneg1_remit;

//%- Exogenous relative prices
px  = 1 + shock0_px + shock1_px - shockneg0_px - shockneg1_px;
pm  = 1 + shock0_pm + shock1_pm - shockneg0_pm - shockneg1_pm;
pmm = 1 + shock0_pmm + shock1_pmm - shockneg0_pmm - shockneg1_pmm;

//%------------------------------------------------------------------------
//%         Defining some additional variables 
//%------------------------------------------------------------------------
//%- Interest repayment on concessional debt
#foo = d(-1)/(1+g);
#int_repayment = int_repayment0 + int_repayment1;
r_d*foo = int_repayment/uazuaz;

//%- Real exchange rate
rer = pn/px;

//%- Terms of trade
tot = px/pm;
totmm = px/pmm;