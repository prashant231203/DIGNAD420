%% DONOR SAVINGS TOOL
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
[path_val,path_names, path_all] = xlsread('input_DIG-ND.xlsx','Scenario','F2:H4'); 
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
temporary = 'yes';
realism_ind=0;
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
disp('--------------------------------------------------------');
else
disp('********************************************************')
disp('Preprocessing completed!')
disp('********************************************************')
disp(' ')
disp('Simulating Donor Savings Toolkit...')
disp(' ')
disp('********************************************************')

for jii = 1
selectScenario('mergedModel.mod', alt_scenar(jii));
scenar = alt_scenar(jii);
for iji = 1
    for ijj = 1
        for jji = 1
% Run an unadjusted model
        for jndi = 1
        calib = alt_calib(iji);
        exopath = 1;
        nn_temp = path_val(ijj,2);
        perm = alt_perm(jji);
        nd_scen = alt_natdis(jndi);
        initialSSandParamsD;
        natdisasters2;
        dynare  mergedModel.mod noclearall nolog nowarn nostrict
        results = ['donor0'];
        saveResults;
     end
% Run the adjusted model    
        for jndi = 1
            calib = alt_calib(iji);
        exopath = 1;
        nn_temp = path_val(ijj,2);
        perm = alt_perm(jji);
        nd_scen = alt_natdis(jndi);
        initialSSandParamsA;
        natdisasters2;    
        dynare  mergedModel.mod noclearall nolog nowarn nostrict
        results = ['donor1'];
        saveResults;
        
            end
        end
    end
end
end
disp('********************************************************')
disp('Calculating donor savings...')
donors1;

%% saving excel donor savings 
disp('Saving your output in Excel...')
movefile(fileName3,[cd,['\Excel output\' datestr(now,'ddmmmyyyy')]]);
disp([fileName3 ' saved in the Excel output folder.']);

%% Go back to folder
disp('********************************************************')
disp('Thank you for running the Donor Savings Toolkit, your results are ready!')
disp('')
disp('--------------------------------------------------------');
disp(T1);
disp('--------------------------------------------------------');
disp('')
disp('Any questions or comments, please contact DIGNAD@imf.org.')
disp('')
disp('********************************************************')
disp('********************************************************')
%% Clean folder
delete mergedModel_*.log
delete mergedModel_*.m
rmdir('mergedModel','s')
delete mergedModel_*.mat
delete dsa_*.mat
delete steady_*.mat
delete scen.mat
delete donor*.mat
delete results_*.mat

end

catch errormsg
    delete mergedModel_*.log
    delete mergedModel_*.mat
    delete dsa_*.mat
    delete steady_*.mat
    delete scen.mat
    rethrow(errormsg);
end

