%% System of Equations for Calibration
% IMF RES-DM, 2016, 2022

function [f, xout] = calibration(x,VA_n,imp2gdp,a_k,delta_x,g,alpha_x,yo,delta_n,alpha_n,a_z,delta_zi,delta_za,P_ko,P_zo,do,dco,r_dco,bstaro,rstar,R_zio,R_zao,b_n,b_x,zio,zao,remito,grantso,oilro,wo,nxpsi,a_ratio,ho,bo,ro,miu,zieo,zaeo,s_s,nu,nug,k_xo,k_no,q_xo,q_no,Savo,zteo,R_zto,hlo, a_za)
f = zeros(length(x),1);
r_do = 0;
gama_n = x(1);
e      = x(2);
eh     = x(3);
T      = x(4);
psi_x  = x(5);
gama_m = x(6);

f(1) = gama_n*(e+eh) + a_k*((delta_x+g)*k_xo + (delta_n+g)*k_no) + a_z*(delta_zi+g)*zio + (1+a_za)*a_z*(delta_za+g)*zao - q_no;
f(2) = e+eh + P_ko*((delta_x+g)*k_xo+(delta_n+g)*k_no) + P_zo*(delta_zi+g)*zio + (1+a_za)*P_zo*(delta_za+g)*zao + do*(1+r_do)/(1+g) + dco*(1+rstar+nug)/(1+g) + bstaro*(1+rstar+nu+nug)/(1+g) - yo - bstaro - do - dco - remito - (grantso+oilro) - (1+rstar)*Savo/(1+g) + Savo;
f(3) = (1+ho)*eh - (1-hlo)*wo*(a_ratio/(1+a_ratio))*((1-alpha_x)*q_xo+(1-alpha_n)*q_no) - (a_ratio/(1+a_ratio))*(remito + T);
f(4) = bo + do + dco - Savo - P_zo*(delta_zi+g)*zio - (1+a_za)*P_zo*(delta_za+g)*zao - bo*(1+ro)/(1+g) - do*(1+r_do)/(1+g) - dco*(1+rstar+nug)/(1+g) + ho*(e+eh) + miu*zieo + (grantso+oilro) - T + (1+rstar)*Savo/(1+g);
f(5) = zteo - (nxpsi*psi_x*VA_n+psi_x*(1-VA_n))*yo/(R_zto*P_zo);
f(6) = gama_m*(e+eh) + (delta_x+g)*k_xo + (delta_n+g)*k_no + (delta_zi+g)*zio + (delta_za+g)*zao - imp2gdp;

xout = [gama_n; e; eh; T; psi_x; gama_m];

