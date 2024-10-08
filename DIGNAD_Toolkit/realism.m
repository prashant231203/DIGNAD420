%% REALISM TOOL
% IMF RES-DM, 2016, 2022 
% Email DIGNAD@imf.org for inquiries, support or to provide feedback

%% Simulating scenarios
clear all; 
clc; 
itermax = 30;
path_to_toolkit = pwd;
addpath(strcat(path_to_toolkit,'\epackages\dynare\4.5.6\matlab'));
addpath(strcat(path_to_toolkit,'\epackages\compecon2011\CEtools'));

% Disable warnings 
warning('off','all');

% -------------------------------------------------------------------------
% Simulating scenarios
% -------------------------------------------------------------------------

try
disp('********************************************************')
disp('********************************************************')
disp('Initializing the DIGNAD toolkit...')
disp('********************************************************')
disp('********************************************************')
disp('Importing your data and preferences...')
disp('********************************************************')
[scen_val,scen_names, scen_all] = xlsread('input_DIG-ND.xlsx','Scenario','C2:C4');    
alignment_do = xlsread('input_DIG-ND.xlsx','Alignment','E2'); 
[path_val,path_names, path_all] = xlsread('input_DIG-ND.xlsx','Scenario','F2:H2');
protec_param = xlsread('input_DIG-ND.xlsx','Realism','C3:E3');
natdis1_val=1;
natdis1_names = 'nd_shock';
alt_scenar = reshape(scen_names,1,[]);
alt_calib = 1;
alt_exopath = reshape(path_val(:,1),1,[]);
alt_natdis = reshape(natdis1_val(:,1),1,[]);
[jmm,jnn] = size(alt_scenar);
mmj = 1;
nnj = 1;
name_calib1 = 'Baseline'; 
name_calib2 = ''; 
name_calib3 = ''; 
name_calib = {name_calib1,name_calib2,name_calib3};
temporary = 'yes';
if strcmp(temporary, 'no')
    alt_exopath = 0;
    name_path0 = 'No';
end
permanent = 'no';
alt_perm = 0; 
name_perm0 = 'No';
[jjm,jjn] = size(alt_perm);
[mjj,njj] = size(alt_exopath);
for i = 1:njj
    eval(['name_path' int2str(path_val(i,1)) '= char(path_names(i,1));']);
end
[mndj,nndj] = size(alt_natdis);
for i = 1:nndj
    eval(['name_natdis' int2str(natdis1_val(i,1)) '= 0;']);
end

% Pre-simulation checks
err_preproc = 0;

% Check if alignment is correctly specified
if alignment_do == 0
            tfp_shock = zeros(1000,1);
elseif alignment_do ==1
            % Load shocks and check
            if isfile('ebaseline_shocks.mat')
                load('ebaseline_shocks.mat','tfp_param_values','tfp_external_baseline');
                new_external_baseline = xlsread('input_DIG-ND.xlsx','Alignment','B3:B32'); 
                    if isequal(tfp_external_baseline,new_external_baseline)
                        % If ok
                        disp(['CHECK: Shocks used to align with an external baseline have been provided.']);
                        load('ebaseline_shocks.mat','tfp_shock');
                    else
                        % If not
                    fprintf(2, 'ERROR:')     
                    disp(['Saved shocks do not correspond to the current setup. Run the alignment tool (alignment) again.']);
                    err_preproc = err_preproc + 1;
                    end
             else
                fprintf(2, 'ERROR:') 
                disp([' ebaseline_shocks.mat is missing. Run the alignment tool (alignment).'])
                err_preproc = err_preproc + 1;
                
            end       
            
else 
             fprintf(2, 'ERROR:') 
             disp([' Please use either 1 or 0 to define scenario for alignment.'])
             err_preproc = err_preproc + 1;
            
end


if err_preproc >0
disp(' ')    
disp('Please correct your inputs and try again.')
disp(' ')
disp('########################################################################################################################')
else
disp(' ')
disp('Preprocessing completed!')
disp(' ')
disp('********************************************************')
disp(' ')
disp('Simulating your model...')
for jii = 1: jnn
selectScenario('mergedModel.mod', alt_scenar(jii));
scenar = alt_scenar(jii);
for iji = 1:nnj
    for ijj = 1:njj
        for jji = 1:jjn
            for jndi = 1:nndj
                realism_ind=1;
                calib = alt_calib(iji);
                exopath = alt_exopath(ijj);
                nn_temp = path_val(ijj,2);
                perm = alt_perm(jji);
                nd_scen = alt_natdis(jndi);
                for zzz=1:size(protec_param,2)
                    ppi_temp = protec_param(1,zzz);
                    initialSSandParamsA;
                    natdisasters2;
                    dynare  mergedModel.mod noclearall nolog nowarn nostrict
                    y = qx+qn;
                    rgdp = 100*(y/yo-1);
                    totpdebt = 100.*(p.*b + d + dc)./ynom;
                    eval(['real_gdp' int2str(zzz) '= rgdp(1:50);']);
                    eval(['pdebt' int2str(zzz) '= totpdebt(1:50);']);

                    if isfile('realism_results.mat') %saving shocks
                            eval(['save(''realism_results.mat'',''real_gdp' int2str(zzz) ''',''pdebt' int2str(zzz) ''',''-append'');'])
                    else
                            eval(['save(''realism_results.mat'',''real_gdp' int2str(zzz) ''',''pdebt' int2str(zzz) '''' ');'])
                    end

                end
        
            end
        end
    end
end
end
disp('********************************************************')
disp('Preparing graphs...')

%% Figures
load('realism_results');
horizon = xlsread('input_DIG-ND.xlsx','Graphs','D3');
t = time_line(1:horizon);

fig_title = ['Realism results'];
h = figure('name', fig_title,'Position', [800, 0, 1000, 500]);
            subplot(1,2,1)
            pdebt=plot(t,real_gdp1(1:horizon),t,real_gdp2(1:horizon),t,real_gdp3(1:horizon));
            ylabel('%');
            xlabel('Year');
            set(gca, 'XTick', t(1):3:t(end));
            title({'Real GDP','(Percent change from initial year)'});
            axis tight
            pdebt(1).LineStyle = '-';
            pdebt(1).LineWidth = 2;
            pdebt(1).Color = 'g';
            pdebt(2).LineStyle = '--';
            pdebt(2).LineWidth = 2;
            pdebt(2).Color = 'k';
            pdebt(3).LineStyle = '-.';
            pdebt(3).LineWidth = 2;
            pdebt(3).Color = 'r';
            legend('Low','Baseline','High')
            legend('Location','southoutside')
            
            subplot(1,2,2)
            pdebt=plot(t,pdebt1(1:horizon),t,pdebt2(1:horizon),t,pdebt3(1:horizon));
            ylabel('%');
            xlabel('Year');
            set(gca, 'XTick', t(1):3:t(end));
            title({'Total Public Debt','(Percent of GDP)'});
            axis tight
            pdebt(1).LineStyle = '-';
            pdebt(1).LineWidth = 2;
            pdebt(1).Color = 'g';
            pdebt(2).LineStyle = '--';
            pdebt(2).LineWidth = 2;
            pdebt(2).Color = 'k';
            pdebt(3).LineStyle = '-.';
            pdebt(3).LineWidth = 2;
            pdebt(3).Color = 'r';
            legend('Low','Baseline','High')
            legend('Location','southoutside')
    %% Saving Figures    
    fig_title4 = ['Realism results'];
    gcfig4 = gcf;
    fig_title1 = [fig_title4,datestr(now,'_ddmmmyyyy')];
    saveas(gcfig4, [fig_title1,'.fig']);
    set(gcfig4,'PaperPositionMode','auto');
    set(gcfig4,'PaperOrientation','landscape');
    set(gcfig4,'PaperUnits','normalized');
    set(gcfig4,'PaperPosition', [0 0 1 1]);
    print(gcfig4, '-dpdf', [fig_title1,'.pdf']);
    movefile([fig_title1,'.fig'],[cd,['\Figures output\matlab figures\' datestr(now,'ddmmmyyyy')]]);
    movefile([fig_title1,'.pdf'],[cd,['\Figures output\pdf figures\' datestr(now,'ddmmmyyyy')]]);
    disp([[fig_title1,'.fig'] ' and ' [fig_title1,'.pdf'] ' saved in the Figures output folder.']);
    
%% Clean folder
delete mergedModel_*.log
delete mergedModel_*.m
rmdir('mergedModel','s')
delete mergedModel_*.mat
delete dsa_*.mat
delete steady_*.mat
delete scen.mat
delete results_*.mat

%% Go back to folder
disp('********************************************************')
disp(' ')
disp('Thank you for running the model, your results are ready!')
disp(' ')
disp('Any questions or comments, please contact DIGNAD@imf.org')
disp(' ')
disp('********************************************************')
disp('********************************************************')
end

catch errormsg
    delete mergedModel_*.log
    delete mergedModel_*.mat
    delete dsa_*.mat
    delete steady_*.mat
    delete scen.mat
    delete realism*.mat
    rethrow(errormsg);

end