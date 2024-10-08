%% SIMULATE MODEL
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
[scen_val,scen_names, scen_all] = xlsread('input_DIG-ND.xlsx','Scenario','C2:C4');    
alignment_do = xlsread('input_DIG-ND.xlsx','Alignment','E2'); 
[path_val,path_names, path_all] = xlsread('input_DIG-ND.xlsx','Scenario','F2:I4'); 
natdis1_val=1;
natdis1_names = 'nd_shock';
alt_scenar = reshape(scen_names,1,[]);
alt_calib = 1;
alt_exopath = reshape(path_val(:,1),1,[]);
alt_natdis = reshape(natdis1_val(:,1),1,[]);
[jmm,jnn] = size(alt_scenar);
mmj = 1;
nnj = 1;
name_calib1 = 'DIGNAD'; 
name_calib2 = ''; 
name_calib3 = ''; 
name_calib = {name_calib1,name_calib2,name_calib3};
temporary = 'yes';
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
disp('--------------------------------------------------------')
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
        calib = alt_calib(iji);
        exopath = alt_exopath(ijj);
        nn_temp = path_val(ijj,2);
        perm = alt_perm(jji);
        nd_scen = alt_natdis(jndi);
        initialSSandParams;
        natdisasters2;
        dynare  mergedModel.mod noclearall nolog nowarn nostrict 
        results = ['results_',scenario,'_',char(name_calib(iji)),'_temp',int2str(exopath),'_perm',int2str(perm)];
        saveResults;
            end
        end
    end
end
end
disp('********************************************************')
disp('Saving your output in Excel...')
save2Excel;
disp(' ')
disp('--------------------------------------------------------')
disp('Preparing graphs...')
run_plots_combined;
disp(' ')

%% Clean folder
delete mergedModel_*.log
delete mergedModel_*.m
rmdir('mergedModel','s')
delete mergedModel_*.mat
delete dsa_*.mat
delete steady_*.mat
delete scen.mat
delete results_*.mat
delete results_*.mat

%% Go back to folder
disp('********************************************************')
disp(' ')
disp('Thank you for running the model, your results are ready!')
disp(' ')
disp('Any questions or comments, please email DIGNAD@imf.org.')
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
    rethrow(errormsg);

end

