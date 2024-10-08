%% ALIGNMENT TOOL
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
[scen_val,scen_names, scen_all] = xlsread('input_DIG-ND.xlsx','Scenario','C2:C2');    
[path_val,path_names, path_all] = xlsread('input_DIG-ND.xlsx','Scenario','F2:H2'); 
ext_baseline = xlsread('input_DIG-ND.xlsx','Alignment','B3:B32'); 
ext_baseline = [0; ext_baseline];
natdis1_val=1;
natdis1_names = 'nd_shock';
alt_scenar = reshape(scen_names,1,[]);
alt_calib = 1;
alt_exopath = reshape(path_val(:,1),1,[]);
alt_natdis = reshape(natdis1_val(:,1),1,[]);
[jmm,jnn] = size(alt_scenar);
mmj = 1;
nnj = 1;
name_calib1 = ''; 
name_calib2 = ''; 
name_calib3 = ''; 
name_calib = {name_calib1,name_calib2,name_calib3};
temporary = 'no';
realism_ind = 0;
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
disp('********************************************************')
disp('Simulating your model...')
for jii = 1: jnn
selectScenario('mergedModel.mod', alt_scenar(jii));
selectScenario('mergedModel2.mod', alt_scenar(jii));
scenar = alt_scenar(jii);
for iji = 1:1
    for ijj = 1:1
        for jji = 1:1
            for jndi = 1:1
        calib = alt_calib(iji);
        exopath = alt_exopath(ijj);
        nn_temp = path_val(ijj,2);
        perm = alt_perm(jji);
        nd_scen = alt_natdis(jndi);
        initialSSandParamsA;
        natdisasters2;
        
        % Run the unadjusted model
        tfp_shock = zeros(1000,1);
        dynare  mergedModel.mod noclearall nolog nowarn nostrict
        y = qx+qn;
        rgdp_model_unadj = 100*(y/yo-1);
        rgdp_model_unadj = rgdp_model_unadj(1:size(ext_baseline,1));
        t = time_line(1:size(ext_baseline,1));
        y_target_shock = ext_baseline(2:end);
            disp('********************************************************')
            disp(' ')
            disp('Computing adjusted projections ') 
                disp(' ') 
                disp(['Aligning projections...']);
                dynare  mergedModel2.mod noclearall nolog nowarn nostrict
                disp(' ') 
                disp(['Desired sequence of shocks found!']);
                
                tfp_shock = tfp_adj(2:1001,:);
                tfp_param_values = param_values;
                tfp_external_baseline = ext_baseline(2:end);
                
                if isfile('ebaseline_shocks.mat') %saving shocks
                    save('ebaseline_shocks.mat','tfp_shock','tfp_param_values','tfp_external_baseline','-append');
                else
                    save('ebaseline_shocks.mat','tfp_shock','tfp_param_values','tfp_external_baseline');
                end
                
                plot_tfp = tfp_shock(1:size(ext_baseline,1));
                             
                disp(' ') 
                disp(' ')
                disp('********************************************************')
                disp('Simulating the revised projection.')
                disp('********************************************************')
             
                dynare  mergedModel.mod noclearall nolog nowarn nostrict
                y = qx+qn;
                rgdp_model_adj = 100*(y/yo-1);
                rgdp_model_adj = rgdp_model_adj(1:size(ext_baseline,1));
             
                disp('********************************************************')
                disp(' ')
                disp('Simulation completed! Shocks saved!')
                disp(' ')
                disp('Thank you for running the Alignment tool, your results are ready!')
                disp(' ')
                end     
 
            end
        end
    end
end

%% Figures
        fig_title = ['Alignment results'];
        h = figure('name', fig_title,'Position', [800, 0, 1000, 800]);
                subplot(2,2,1)
                pdebt=plot(t,rgdp_model_unadj,t,ext_baseline);
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
                legend('Model projection','User-provided projection')
                legend('Location','southoutside')
              
                subplot(2,2,2)
                pdebt=plot(t,rgdp_model_adj,t,ext_baseline);
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
                legend('Model projection','User-provided projection')
                legend('Location','southoutside')

                subplot(2,2,3)
                ptfp=bar(t,plot_tfp.*100);
                ylabel('%\Delta from S.S.');
                xlabel('Year');
                set( gca, 'XTick', t(1):3:t(end));
                title({'TFP shock to GDP',' '});
                axis tight
                legend('Implied by the adjusted baseline')
                legend('Location','southoutside')
                
   %% Saving Figures
 
    fig_title3 = ['Alignment results'];
    gcfig3 = gcf;
    fig_title1 = [fig_title3,datestr(now,'_ddmmmyyyy')];
    saveas(gcfig3, [fig_title1,'.fig']);
    set(gcfig3,'PaperPositionMode','auto');
    set(gcfig3,'PaperOrientation','landscape');
    set(gcfig3,'PaperUnits','normalized');
    set(gcfig3,'PaperPosition', [0 0 1 1]);
    print(gcfig3, '-dpdf', [fig_title1,'.pdf']);
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
delete mergedModel2_*.log
delete mergedModel2_*.m
rmdir('mergedModel2','s')
delete mergedModel2_*.mat

%% Go back to folder
disp(' ')
disp('********************************************************')
disp(' ')
disp('If you wish to use shocks generated by the Alignment tool')
disp(' ')
disp('please, insert "1" (cell "E2" in input_DIG-ND.xlsx Alignment worksheet) save and run "simulate".')
disp(' ')
disp('Any questions or comments, please email DIGNAD@imf.org.')
disp(' ')
disp('********************************************************')
disp('********************************************************')
catch errormsg
    delete mergedModel_*.log
    delete mergedModel_*.mat
    delete dsa_*.mat
    delete steady_*.mat
    delete scen.mat
    rethrow(errormsg);
end


 
   
 