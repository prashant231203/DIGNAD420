function selectScenario2(modelname, scenario)
    % Opening the file to both read and write 
    fid = fopen(modelname,'r+');
    if strcmp(scenario, 'domestic_debt')
        conf_array = {'@#define exogenous = 0', ...
                      '@#define endogenous_domestic = 1', ...
                      '@#define endogenous_commercial = 0',...
                      '@#define all_debt = 0'};
        scenario = 'dom';
    elseif strcmp(scenario, 'commercial_debt')
        conf_array = {'@#define exogenous = 0', ...
                      '@#define endogenous_domestic = 0', ...
                      '@#define endogenous_commercial = 1',...
                      '@#define all_debt = 0'};
        scenario = 'com';
    elseif strcmp(scenario, 'exogeneous')
        conf_array = {'@#define exogenous = 1', ...
                      '@#define endogenous_domestic = 0', ...
                      '@#define endogenous_commercial = 0',...
                      '@#define all_debt = 0'};
        scenario = 'exo';
    elseif strcmp(scenario, 'all_debt')
        conf_array = {'@#define exogenous = 0', ...
                      '@#define endogenous_domestic = 0', ...
                      '@#define endogenous_commercial = 0',...
                      '@#define all_debt = 1'};
        scenario = 'all';
    else
        error('Valid debt scenarios are: ''fiscal_instruments'', ''domestic_debt'', ''commercial_debt'', or ''all_debt''');
    end
    save scen.mat scenario 
    for i = 1:4
        location = ftell(fid);
        fseek(fid,location,'bof');
        fprintf(fid,'\n'); 
        fseek(fid,-1,'cof'); 
        conf_line = conf_array{i};
        fprintf(fid,'%s',conf_line); 
        temp_line = fgetl(fid);
    end
    fprintf(fid,'\n');
    fclose(fid);  