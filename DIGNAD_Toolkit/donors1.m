%% DONOR SAVINGS 
% IMF RES-DM, 2016, 2022 
% Email dignad@imf.org for inquiries, support or to provide feedback

%% using reconstruction of public capital
load donor0.mat
load donor1.mat
izi0 = reshape(donor0.shocknd_izi(1:50),[],1);
izi1 = reshape(donor1.shocknd_izi(1:50),[],1);
iza = reshape(donor1.iza(1:50),[],1);
yini = xlsread('input_DIG-ND.xlsx','Donor_Savings','C5');
drate = xlsread('input_DIG-ND.xlsx','Donor_Savings','C6');

%multiply by initial GDP 
izi0 = yini.*izi0/100;
izi1 = yini.*izi1/100;
iza = yini.*iza./100 ;

% Net Present Values
NPV_Exante_Adap = pvvar(iza,drate);
for i=1:11
    if sum(iza)==0
        NPV_No_Adap (i) = pvvar(izi0,drate)*(1+(i-1)/10);   
        NPV_Adap = zeros(1,11);
        NPV_Exante_Adap = 0;
        Net_sav = zeros(1,11);
    else   
        NPV_No_Adap (i) = pvvar(izi0,drate)*(1+(i-1)/10);
        NPV_Adap(i) = pvvar(izi1,drate)*(1+(i-1)/10);
        Net_sav(i) = NPV_No_Adap(i) - (NPV_Adap(i) + NPV_Exante_Adap);
     end
end

%% save results
save donor.mat izi0 izi1 iza NPV_No_Adap NPV_Adap NPV_Exante_Adap Net_sav  ;
% to excel
    
all_names1 = char('NPV of Reconstruction cost - No Adaptation','NPV of Reconstruction cost - Adaptation', ...
                  'NPV of Additional financing for ex ante Adaptation','Net Savings of ex ante Adaptation' );
headers ={'Average Impact (AI)','AI + 30%', 'AI +50%','AI +100%'} ;
Labels = [cellstr(all_names1)];
header = [cellstr(headers)];

AI = [NPV_No_Adap(1); NPV_Adap(1); NPV_Exante_Adap; Net_sav(1)];
AI1 = [NPV_No_Adap(4); NPV_Adap(4); NPV_Exante_Adap; Net_sav(4)];
AI2 = [NPV_No_Adap(6); NPV_Adap(6); NPV_Exante_Adap; Net_sav(6)];
AI3 = [NPV_No_Adap(11); NPV_Adap(11); NPV_Exante_Adap; Net_sav(11)];
T1 = table(Labels,AI,AI1,AI2,AI3);

fileName3 = ['Donor' '_',datestr(now,'ddmmmyyyy'),'.xlsx'];              
writetable(T1,fileName3,'Sheet',1,'Range','A1:E6');
writecell(headers,fileName3,'Sheet',1,'Range','B1:F1');

