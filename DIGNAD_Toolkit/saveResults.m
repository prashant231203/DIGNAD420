%% SAVE RESULTS
% IMF RES-DM, 2016, 2022 
% Email DIGNAD@imf.org for inquiries, support or to provide feedback.

%%
if ~isstr(results)
    error('Please specify the name of the variable where you want the results to be saved');
end
eval([results '= struct([]);']);

%% Create and save help variables for report
blag  =[bo b(1:1001)']'; 
dclag = [dco dc(1:1001)']';
dlag = [ do d(1:1001)']';
rextlag = [rstar+nu rext(1:1001)']'; 
rextglag = [rstar+nug rextg(1:1001)']'; 
rlag =[ro r(1:1001)']';
bstarlag  =[bstaro bstar(1:1001)']'; 
cad = d + dc + bstar - (dlag + dclag + bstarlag)./(1+g);
pfd = p.*(b-blag)+d-dlag+dc-dclag-(r_d-g).*dlag./(1+g)-(rextglag-g).*dclag./(1+g)-(rlag-g).*p.*blag/(1+g);
publicriskpremium = rextg - rstar;
y = qx+qn;
k = kx+kn;
c = (e+eh)./p;
co = (e_ini+eh_ini)./P_ini;
ixn = ix + in;
ixno = i_x_ini + i_n_ini;
kxo = k_x_ini;
kno = k_n_ini;
qxo = q_x_ini;
qno = q_n_ini;
ddc = 100*(d+dc)./ynom ;
privconsgr = 100*(c/co-1);                              % Private Consumption growth (% dev from SS)
pubinvgdp = 100*(pz.*izi)./ynom;                        % Public investment (in % of GDP)
pubadapgdp = (100*(pz.*iza)./ynom)*(1+a_za);            % Public Adaptation investment (in % of GDP) ><
privinvgr = 100*(ixn/ixno-1);                           % Private Investment growth (% dev from SS)
privxinvgr = 100*(ix/i_x_ini-1);                        % Private Investment growth (% dev from SS)
privninvgr = 100*(in/i_n_ini-1);                        % Private Investment growth (% dev from SS)
privcapgr = (kx+kn - kxo - kno).*100./(kxo + kno);      % Private Capital growth (% dev from SS)
privxcapgr = 100*(kx - kxo)/kxo;                        % Private Tradable Capital growth 
privncapgr = 100*(kn - kno)/kno;                        % Private Nontradable Capital growth
pubeffcapigr = 100*(zie-zieo)./zieo;                    % Public Effective Capital growth (% dev from SS) 
pubeffcapagr = 100*(zae-zaeo)./zaeo;                    % Public Effective Adaptation Capital growth (% dev from SS) 
grantsgdp = 100*grants./ynom;                           % Loans and grants (in % of GDP)
loangrantgdp = 100*(netbwconc+(grants-grantso))./ynom;  % Loans and grants (in % of GDP)
Tchangegdp = 100*(T-To)./ynom;                          % Transfers Change (in % of GDP)
extpdebtgdp = 100*bstar./ynom;                          % External Private Debt (in % of GDP)
concdebtgdp = 100.*d./ynom;                             % Concessional Debt (in % of GDP)
commdebtgdp = 100*dc./ynom;                             % External Public Commercial Debt (% of GDP)
commdebtchagdp = 100*(dc-dco)./ynom;                    % External Public Commercial Debt Change (% of GDP)
domdebtgdp = 100.*p.*b./ynom;                           % Domestic Public Debt (% of GDP)
totpubdebt = 100.*(p.*b + d + dc)./ynom;                % Total Public Debt (in % of GDP)
hpercent = 100*h;                                       % Consumption Taxes (%)
hlpercent = 100*hl;                                     % Labor Income Taxes (%)
relpn = 100*(pn/P_no-1);                                % Relative Price of NT Goods (% dev from SS)
relpz = 100*(pz-P_zo);                                  % Relative Price of public infrastructure investment (in %)
rpercent = 100*r;                                       % Real Interest Rate (in %)
rextgpercent = 100*rextg;                               % Real Interest Rate on External Commercial Debt (in %)
rerpercent = 100*(rer./(P_no/P_xo)-1);                  % Real Exchange Rate (% dev from SS)
rwageslev = w./p;                                       % Wages (level)
rwages = 100*((w./p)/(wo/Po)-1);                        % Wages (% dev from SS)
rgdpgryoy = 100*growth_plot;                            % Real GDP Growth (% YoY) - growth_plot=(qn-qn(-1))/qn(-1) + (qx-qx(-1))/qx(-1) + g;
rgdp = 100*(y/yo-1);                                    % Real GDP (% dev from SS)
rgdpx = (qx-qxo).*100./qxo;                             % Tradable Output growth (% dev from SS) 
rgdpn = (qn-qno).*100./qno;                             % Non-Tradable Output growth  (% dev from SS)
fiscaldef = 100.*(pfd./ynom);                           % Fiscal Deficit (in % of GDP)
cadef = 100.*(cad./ynom);                               % Current Deficit (in % of GDP)
roizipercent = 100*Rzi;                                 % Return on Public Infrastructure Investment (in %)
roizapercent = 100*Rza;                                 % Return on Public Adaptation Infrastructure Investment (in %)
pubeff = 100*s;                                         % Public capital efficiency (%)
totcons = 100*(tot./(P_xo/P_mo)-1);                     % Terms of Trade in Consumption Goods (% dev from SS)
totcap = 100*(totmm./(P_xo/P_mmo)-1);                   % Terms of Trade in Capital Goods (% dev from SS)
oilrevgdp = 100*oilr./ynom;                             % Natural resources revenue (in % of GDP)
curexpgdp = 100*T./ynom;                                % Public current expenditures (% of GDP)
savgdp = 100*Sav./ynom;                                 % Natural disaster fund (% of GDP)
tfpxgr = 100*(a_x - a_xo)/a_xo;                         % Tradable TFP growth (% dev from SS) 
tfpngr = 100*(a_n - a_no)/a_no;                         % Nontradable TFP growth (% dev from SS) 

%% Save variables to results_*
eval([results '(1).cad = 100*cad./ynom;']);
for i=1:length(M_.endo_names)
    eval([results '.' M_.endo_names(i,:) '=' mat2str(oo_.endo_simul(i,:)') ';'])
end
for i=1:length(M_.param_names)
    eval([results '.' M_.param_names(i,:) '=' num2str(M_.params(i,:)) ';']);
end
for i=1:length(M_.exo_names)
    eval([results '.' M_.exo_names(i,:) '=' mat2str(oo_.exo_simul(:,i)') ';'])
  
end
%% Anticipation effect
nn_natdis = natdis2_var(1,1) ;
if nn_natdis == 1 ;
   nn_natdis1 = natdis2_var(1,1); 
   ynom = [ynom(1)*ones(nn_natdis1,1); ynom(2:1003-nn_natdis1)];
    eval([results '.pfd = [pfd(1)*ones(nn_natdis1,1); pfd(2:end-nn_natdis1+1)];']);
    eval([results '.cadef = [cadef(1)*ones(nn_natdis1,1); cadef(2:end-nn_natdis1+1)];']);
    eval([results '.pubinvgdp = [pubinvgdp(1)*ones(nn_natdis1,1); pubinvgdp(2:end-nn_natdis1+1)];']);
    eval([results '.privinvgr = [privinvgr(1)*ones(nn_natdis1,1); privinvgr(2:end-nn_natdis1+1)];']);
    eval([results '.c = [c(1)*ones(nn_natdis1,1); c(2:end-nn_natdis1+1)];']);
    eval([results '.co = [co(1)*ones(nn_natdis1,1); co(2:end-nn_natdis1+1)];']);
    eval([results '.privconsgr = [privconsgr(1)*ones(nn_natdis1,1); privconsgr(2:end-nn_natdis1+1)];']);
    eval([results '.pubadapgdp = [pubadapgdp(1)*ones(nn_natdis1,1); pubadapgdp(2:end-nn_natdis1+1)];']);
    eval([results '.privxinvgr = [privxinvgr(1)*ones(nn_natdis1,1); privxinvgr(2:end-nn_natdis1+1)];']);
    eval([results '.privninvgr = [privninvgr(1)*ones(nn_natdis1,1); privninvgr(2:end-nn_natdis1+1)];']);
    eval([results '.k = [k(1)*ones(nn_natdis1,1); k(2:end-nn_natdis1+1)];']);
    eval([results '.privcapgr = [privcapgr(1)*ones(nn_natdis1,1); privcapgr(2:end-nn_natdis1+1)];']);
    eval([results '.privxcapgr = [privxcapgr(1)*ones(nn_natdis1,1); privxcapgr(2:end-nn_natdis1+1)];']);
    eval([results '.privncapgr = [privxcapgr(1)*ones(nn_natdis1,1); privxcapgr(2:end-nn_natdis1+1)];']);
    eval([results '.pubeffcapigr = [pubeffcapigr(1)*ones(nn_natdis1,1); pubeffcapigr(2:end-nn_natdis1+1)];']);
    eval([results '.pubeffcapagr = [pubeffcapagr(1)*ones(nn_natdis1,1); pubeffcapagr(2:end-nn_natdis1+1)];']);
    eval([results '.loangrantgdp = [loangrantgdp(1)*ones(nn_natdis1,1); loangrantgdp(2:end-nn_natdis1+1)];']);
    eval([results '.Tchangegdp = [Tchangegdp(1)*ones(nn_natdis1,1); Tchangegdp(2:end-nn_natdis1+1)];']);
    eval([results '.y = [y(1)*ones(nn_natdis1,1); y(2:end-nn_natdis1+1)];']);
    eval([results '.rgdp = [rgdp(1)*ones(nn_natdis1,1); rgdp(2:end-nn_natdis1+1)];']);
    eval([results '.rgdpgryoy = [rgdpgryoy(1)*ones(nn_natdis1,1); rgdpgryoy(2:end-nn_natdis1+1)];']);
    eval([results '.rgdpx = [rgdpx(1)*ones(nn_natdis1,1); rgdpx(2:end-nn_natdis1+1)];']);
    eval([results '.rgdpn = [rgdpn(1)*ones(nn_natdis1,1); rgdpn(2:end-nn_natdis1+1)];']);
    eval([results '.rwageslev = [rwageslev(1)*ones(nn_natdis1,1); rwageslev(2:end-nn_natdis1+1)];']);
    eval([results '.rwages = [rwages(1)*ones(nn_natdis1,1); rwages(2:end-nn_natdis1+1)];']);
    eval([results '.grantsgdp = [grantsgdp(1)*ones(nn_natdis1,1); grantsgdp(2:end-nn_natdis1+1)];']);
    eval([results '.commdebtgdp = [commdebtgdp(1)*ones(nn_natdis1,1); commdebtgdp(2:end-nn_natdis1+1)];']);
    eval([results '.commdebtchagdp = [commdebtchagdp(1)*ones(nn_natdis1,1); commdebtchagdp(2:end-nn_natdis1+1)];']);
    eval([results '.concdebtgdp = [concdebtgdp(1)*ones(nn_natdis1,1); concdebtgdp(2:end-nn_natdis1+1)];']);
    eval([results '.ddc = [ddc(1)*ones(nn_natdis1,1); ddc(2:end-nn_natdis1+1)];']);
    eval([results '.domdebtgdp = [domdebtgdp(1)*ones(nn_natdis1,1); domdebtgdp(2:end-nn_natdis1+1)];']);
    eval([results '.extpdebtgdp = [extpdebtgdp(1)*ones(nn_natdis1,1); extpdebtgdp(2:end-nn_natdis1+1)];']);
    eval([results '.totpubdebt =' results '.domdebtgdp+' results '.ddc;']);
    eval([results '.hpercent = [hpercent(1)*ones(nn_natdis1,1); hpercent(2:end-nn_natdis1+1)];']);
    eval([results '.hlpercent = [hlpercent(1)*ones(nn_natdis1,1); hlpercent(2:end-nn_natdis1+1)];']);
    eval([results '.relpn = [relpn(1)*ones(nn_natdis1,1); relpn(2:end-nn_natdis1+1)];']);
    eval([results '.relpz = [relpz(1)*ones(nn_natdis1,1); relpz(2:end-nn_natdis1+1)];']);
    eval([results '.rpercent = [rpercent(1)*ones(nn_natdis1,1); rpercent(2:end-nn_natdis1+1)];']);
    eval([results '.rextgpercent = [rextgpercent(1)*ones(nn_natdis1,1); rextgpercent(2:end-nn_natdis1+1)];']);
    eval([results '.rerpercent = [rerpercent(1)*ones(nn_natdis1,1); rerpercent(2:end-nn_natdis1+1)];']);
    eval([results '.roizipercent = [roizipercent(1)*ones(nn_natdis1,1); roizipercent(2:end-nn_natdis1+1)];']);
    eval([results '.roizapercent = [roizapercent(1)*ones(nn_natdis1,1); roizapercent(2:end-nn_natdis1+1)];']);
    eval([results '.pubeff = [pubeff(1)*ones(nn_natdis1,1); pubeff(2:end-nn_natdis1+1)];']);
    eval([results '.totcons = [totcons(1)*ones(nn_natdis1,1); totcons(2:end-nn_natdis1+1)];']);
    eval([results '.totcap = [totcap(1)*ones(nn_natdis1,1); totcap(2:end-nn_natdis1+1)];']);
    eval([results '.oilrevgdp = [oilrevgdp(1)*ones(nn_natdis1,1); oilrevgdp(2:end-nn_natdis1+1)];']);
    eval([results '.curexpgdp = [curexpgdp(1)*ones(nn_natdis1,1); curexpgdp(2:end-nn_natdis1+1)];']);
    eval([results '.savgdp = [savgdp(1)*ones(nn_natdis1,1); savgdp(2:end-nn_natdis1+1)];']);
    eval([results '.tfpxgr = [tfpxgr(1)*ones(nn_natdis1,1); tfpxgr(2:end-nn_natdis1+1)];']);
    eval([results '.tfpngr = [tfpngr(1)*ones(nn_natdis1,1); tfpngr(2:end-nn_natdis1+1)];']);
    eval([results '.a_n = [a_n(1)*ones(nn_natdis1,1); a_n(2:end-nn_natdis1+1)];']);
    eval([results '.a_x = [a_x(1)*ones(nn_natdis1,1); a_x(2:end-nn_natdis1+1)];']);
    eval([results '.fiscaldef = [fiscaldef(1)*ones(nn_natdis1,1); fiscaldef(2:end-nn_natdis1+1)];']);
else
    eval([results '.pfd = pfd;']);
    eval([results '.cadef = cadef;'])
    eval([results '.pubinvgdp = pubinvgdp;']);
    eval([results '.privinvgr = privinvgr;']);
    eval([results '.c = (e+eh)./p;']);
    eval([results '.co = (e_ini+eh_ini)./P_ini;']);
    eval([results '.privconsgr = 100*(c/co-1);']);
    eval([results '.pubadapgdp = pubadapgdp;']);
    eval([results '.privxinvgr = privxinvgr;']);
    eval([results '.privninvgr = privninvgr;']);
    eval([results '.k = k;']);
    eval([results '.privcapgr = (kx+kn - kxo - kno).*100./(kxo + kno);']);
    eval([results '.privxcapgr = privxcapgr;']);
    eval([results '.privncapgr = privncapgr;']);
    eval([results '.pubeffcapigr = (zie-zieo).*100./zieo;']);
    eval([results '.pubeffcapagr = pubeffcapagr;']);
    eval([results '.loangrantgdp = 100*(netbwconc+(grants-grantso))./ynom;']);
    eval([results '.Tchangegdp = 100*(T-To)./ynom;']);
    eval([results '.y = y;']);
    eval([results '.rgdp = y-100;']);
    eval([results '.rgdpgryoy = 100*growth_plot;']);
    eval([results '.rgdpx = (qx-qxo).*100./qxo;']);
    eval([results '.rgdpn = (qn-qno).*100./qno;']);
    eval([results '.rwageslev = w./p;']);
    eval([results '.rwages = ((w./p)-1).*100;']);
    eval([results '.grantsgdp = grantsgdp;']);
    eval([results '.commdebtgdp = 100*dc./ynom;']);
    eval([results '.commdebtchagdp = 100*(dc-dco)./ynom;']);
    eval([results '.concdebtgdp = 100.*d./ynom;']);
    eval([results '.ddc = 100*(d+dc)./ynom;']);
    eval([results '.domdebtgdp = 100.*p.*b./ynom;']);
    eval([results '.extpdebtgdp = 100*bstar./ynom;']);
    eval([results '.totpubdebt =' results '.domdebtgdp+' results '.ddc;']);
    eval([results '.hpercent = 100*h;']);
    eval([results '.hlpercent = 100*hl;']);
    eval([results '.relpn = 100*(pn-1);']);
    eval([results '.relpz = 100*(pz-P_zo);']);
    eval([results '.rpercent = 100*r;']);
    eval([results '.rextgpercent = 100*rextg;']);
    eval([results '.rerpercent = 100*(rer-1);']);
    eval([results '.roizipercent = 100*Rzi;']);
    eval([results '.roizapercent = roizapercent;']);
    eval([results '.pubeff = 100*s;']);
    eval([results '.totcons = 100*(tot./(P_xo/P_mo)-1);']);
    eval([results '.totcap = 100*(totmm./(P_xo/P_mmo)-1);']);
    eval([results '.oilrevgdp = 100*oilr./ynom;']);
    eval([results '.curexpgdp = 100*T./ynom;']);
    eval([results '.savgdp = savgdp;']);
    eval([results '.tfpxgr = tfpxgr;']);
    eval([results '.tfpngr = tfpngr;']);
    eval([results '.a_n = a_n;']);
    eval([results '.a_x = a_x;']);
    eval([results '.fiscaldef = 100.*(pfd./ynom);']);
end


%% Saving results
eval([results '.ixo = i_x_ini;']);
eval([results '.ino = i_n_ini;']);
eval([results '.ixno =' results '.ixo+' results '.ino;']);
eval([results '.ixn = ix + in;']);
eval([results '.kxo = k_x_ini;']);
eval([results '.kno = k_n_ini;']);
eval([results '.grantso = grantso;']);
eval([results '.qxo = q_x_ini;']);
eval([results '.qno = q_n_ini;']);

% Final
eval([results '.scenario = scenario;']);
eval([results '.name_calib = name_calib;']);
eval([results '.time_line = time_line;']);
eval(['save ' results '.mat ' results ';']);
eval([results '= 0;']);
