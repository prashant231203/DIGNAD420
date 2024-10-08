%% RUN PLOTS
% IMF RES-DM, 2016, 2022 
% Email DIGNAD@imf.org for inquiries, support or to provide feedback

%% Disable warnings 
warning('off','all');

%% Useful variables for plots

startdate = time_line(1);
[mmj,nnj] = size(alt_calib);
[mjj,njj] = size(alt_exopath); 
name_calib = name_calib(~cellfun(@isempty, name_calib)); % To remove empty cells
mrk = {'-.',':', '--', '-.','+','^','o','s','*','v'};
[graph_var,graph_options, graph_all] = xlsread('input_DIG-ND.xlsx','Graphs','C2:X4');
mkdir('pdf figures');
mkdir('matlab figures');
mkdir('pdf figures',datestr(now,'ddmmmyyyy'));
mkdir('matlab figures',datestr(now,'ddmmmyyyy'));

%% Defining variables

all_strs = {'pubinvgdp' % Public infrastructure investment (% of GDP)
            'pubadapgdp' % Public infrastructure adaptation investment (% of GDP)
            'pubeffcapigr' % Public Effective Capital growth (% dev from SS) 
            'pubeffcapagr' % Public Effective Adaptation Capital growth (% dev from SS) 
            'rgdpgryoy' % Real GDP Growth (% YoY)
            'rgdp' % Real GDP (% dev from SS);
            'rgdpx' % Tradable Output (% dev from SS)
            'rgdpn' % Non-Tradable Output (% dev from SS)
            'privconsgr' % Private Consumption growth (% dev from SS)
            'privinvgr' % Private Investment growth (% dev from SS)
            'privcapgr' % Private Capital growth (% dev from SS)
            'hpercent' % Consumption Tax (%)
            'Tchangegdp' % Transfers Change (% of GDP)
            'grantsgdp' % Grants (% of GDP)
            'loangrantgdp' % Loans and grants (% of GDP)
            'extpdebtgdp' % External Private Debt (% of GDP)
            'domdebtgdp' % Domestic Public Debt (% of GDP)
            'concdebtgdp' % Concessional Debt (% of GDP)
            'commdebtgdp' % External Public Commercial Debt (% of GDP)
            'commdebtchagdp' % External Public Commercial Debt Change (% of GDP)
            'totpubdebt' % Total Public Debt (% of GDP) 
            'fiscaldef' % Fiscal Deficit (% of GDP)
            'cadef' % Current Deficit (% of GDP)
            'rpercent' % Real Interest Rate (%)
            'rextgpercent' % Real Interest Rate on External Commercial Debt (%)
            'rerpercent' % Real Exchange Rate (dep. -, % dev from SS)
            'relpn' % Relative Price of NT Goods (% dev from SS)
            'relpz' % Relative Price of public infrastructure investment (%)
            'rwages' % Real Wages (% dev from SS)
            'roizipercent' % Return on Public Infrastructure Investment (%)
            'roizapercent' % Return on Public Infrastructure Investment (%)
            'totcons' % Terms of Trade in Consumption Goods (% dev from SS)
            'totcap' % Terms of Trade in Capital Goods (% dev from SS)
            'oilrevgdp' % Oil revenues (% of GDP)
            'curexpgdp' % Public current expenditures (% of GDP)
            'savgdp' % Natural disaster fund (% of GDP)
            'y' % Real GDP (level)
            'zi' % Public Standard Capital (level)
            'zie' %  Public Effective Standard Capital (level)
            'za' % Public Adaptation Capital (level)
            'zae' %  Public Effective Adaptation Capital (level)
            'k' % Private Capital (level)
            'kn' % Private Capital in NT (level)
            'kx' % Private Capital in T (level)
            'a_n' % TFP in the NT sector (level)
            'a_x' % TFP in the T sector (level)
            'hlpercent' % Labor Income Tax (%)
            };             
all_names = char('Public Infrastructure Inv. (\% of GDP)', 'Public Adaptation Inv. (\% of GDP)', 'Public Effective Capital Growth (\% dev. from SS)', ...
            'Public Eff. Adaptation Cap. Gr. (\% dev. from SS)', 'Real GDP Growth (\% YoY)',... 
            'Real GDP (\% dev. from SS)', 'Tradable Output Growth (\% dev. from SS)', 'Non-Tradable Output Growth (\% dev. from SS)', ...
            'Private Consumption Growth (\% dev. from SS)','Private Inv. Growth (\% dev. from SS)','Private Capital Growth (\% dev. from SS)', ...
            'Consumption Tax (\%)', 'Transfers Change (\% of GDP)','Grants (\% of GDP)','Loans and Grants Change (\% of GDP)', 'External Private Debt (\% of GDP)', ...
            'Domestic Public Debt (\% of GDP)', 'Concessional Debt (\% of GDP)', 'External Public Comm. Debt (\% of GDP)', 'External Public Comm. Debt Change (\% of GDP)',...
            'Total Public Debt (\% of GDP)', 'Fiscal Deficit (\% of GDP)', 'Current Account Deficit (\% of GDP)', 'Real Interest Rate (\%)',...
            'Real Interest Rate on External Comm. Debt (\%)', 'Real Exchange Rate (dep. -, \% dev. from SS)', 'Relative Price of NT Goods (\% dev. from SS)', ...
            'Relative Price of Public Infra. Inv. (\%)', 'Real Wages (\% dev. from SS)', 'Return on Public Infra. Inv. (\%)', 'Return on Adapt. Infra. Inv. (\%)', ...
            'Terms of Trade (Cons., \% dev from SS)', 'Terms of Trade (Cap., \% dev from SS)', 'Oil Revenues (\% of GDP)', ...
            'Public Current Expenditures (\% of GDP)', 'Natural disaster fund (\% of GDP)', 'Real GDP (level)', ...
            'Public Standard Capital (level)', 'Public Effective Standard Capital (level)', 'Public Adaptation Capital (level)', 'Public Effective Adaptation Capital (level)', ...
            'Private Capital (level)', 'Private Capital in NT (level)', 'Private Capital in T (level)', ...
            'TFP in the NT sector (level)', 'TFP in the T sector (level)', 'Labor Income Tax (\%)' );       

%% Graph comparing financing scenarios and shocks

if strcmp(graph_options(2,1),'yes')
    
NN = graph_var(2,1);
enddate = time_line(1)+NN;
rrr = graph_var(2,2); % # of rows
ccc = graph_var(2,3); % # of columns
select_strs = reshape(graph_options(2,7:6+graph_var(2,5)),[],1);
[mmm,nnn] = size(select_strs); 
for iii = 1:mmm
    ind=find(ismember(all_strs, select_strs(iii)));
    select_names(iii,:) = all_names(ind,:);
end
list = ls('results_*.mat');    
for aaa = char(alt_scenar)'; %['exo';'dom'; 'com']'
    aaa = aaa(1:3);
    if aaa == ['exo']'
        scenari = 'fiscal_instruments';
    elseif aaa == ['dom']'
        scenari = 'domestic_debt';
    elseif aaa == ['com']'
        scenari = 'commercial_debt';
    elseif aaa == ['all']'
        scenari = 'dom & ext';
    end
    if any(ismember(list(:,9:11),aaa'))
        fig_title = ['Simulation results '];
        h = figure('name', fig_title,'Position', [800, 0, 1200, 900]);
        curve = zeros(1,nnj);
    end 
    for bbb = name_calib;
        bbb = char(bbb);         
        for ijj = alt_exopath
            for jji = alt_perm
            if exist(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.mat'],'file')
                load(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.mat'])                              
                all_simulations_matrix =[eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.pubinvgdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.pubadapgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.pubeffcapigr']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.pubeffcapagr']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rgdpgryoy']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rgdpx']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rgdpn']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.privconsgr']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.privinvgr']) ... 
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.privcapgr']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.hpercent']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.Tchangegdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.grantsgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.loangrantgdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.extpdebtgdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.domdebtgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.concdebtgdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.commdebtgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.commdebtchagdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.totpubdebt']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.fiscaldef']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.cadef']) ... 
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rpercent']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rextgpercent']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rerpercent']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.relpn']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.relpz']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.rwages']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.roizipercent']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.roizapercent']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.totcons']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.totcap']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.oilrevgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.curexpgdp']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.savgdp']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.y']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.zi']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.zie']) ... 
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.za']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.zae']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.k']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.kn']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.kx']) ...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.a_n']) eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.a_x'])...
                            eval(['results_' aaa' '_' bbb '_temp' int2str(ijj),'_perm' int2str(jji) '.hlpercent'])];                                                       
                for iii = 1:mmm
                    ind=find(ismember(all_strs, select_strs(iii)));
                    select_simulations_matrix(:,iii) = all_simulations_matrix(:,ind);
                end                
                for j = 1:mmm                     
                    subplot(rrr,ccc,j); 
                          curve(iji) = plot(time_line(1:NN),select_simulations_matrix(1:NN,j),'LineWidth',2,'DisplayName',[bbb ' - ' scenari ', ' eval(['name_path' int2str(ijj)]) ' temp. shock. '] ); hold on; 
                          title(select_names(j,:),'FontSize',10,'Interpreter','latex');
                          grid on;
                          xlim([startdate enddate]);
                          xlabel('$years$','FontSize', 8, 'Interpreter', 'latex')
                          ylabel('','FontSize', 8,'Interpreter','latex')
                          set(gca,'FontSize',8,'TickLabelInterpreter','latex')
                          set(gca,'LineStyleOrder',mrk(iji))
                end
            end
            end
        end
    end
        leg = legend('-DynamicLegend');
        set(leg,'location','best','Interpreter','latex','FontSize', 9);
if any(ismember(list(:,9:11),aaa'))        
    gcfig2 = gcf;
    fig_title2 = [fig_title,datestr(now,'_ddmmmyyyy')];
    saveas(gcfig2, [fig_title2,'.fig']);
    set(gcfig2,'PaperPositionMode','auto');
    set(gcfig2,'PaperOrientation','landscape');
    set(gcfig2,'PaperUnits','normalized');
    set(gcfig2,'PaperPosition', [0 0 1 1]);
    print(gcfig2, '-dpdf', [fig_title2,'.pdf']);
    movefile([fig_title2,'.fig'],[cd,['\matlab figures\' datestr(now,'ddmmmyyyy')]]);
    movefile([fig_title2,'.pdf'],[cd,['\pdf figures\' datestr(now,'ddmmmyyyy')]]);
    disp([[fig_title2,'.fig'] ' and ' [fig_title2,'.pdf'] ' saved in the Figures output folder.']);
end
end

end

%% File back to previous folder

mkdir('Figures output');
movefile('matlab figures','Figures output');
movefile('pdf figures','Figures output');



