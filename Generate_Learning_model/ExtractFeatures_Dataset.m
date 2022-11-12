%% Variables 
window_l = 99;
window_r = 100;
max_RR = 1;
remove_Savitzky_Golay =true;
compute_DWT = true;
class_division = 1;
signals_used = [1, 0]
patient_list = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 113, 114,... 
                115, 116, 117, 118, 119, 121, 122, 123, 124, 200, 201, 202, 203, 205,...
                207, 208, 209, 210, 212, 213, 214, 215, 217, 219, 220, 221, 222, 223,...
                228, 230, 231, 232, 233, 234];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 We load the data of model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_dataset ='../File Models/';
full_path = [path_dataset];
%full_path = ['/home/mondejar/Dropbox/ECG/code/'];

if window_l == 256
    full_name_dataset = [full_path, 'data_'];
else
    full_name_dataset = [full_path, 'data_w_', num2str(window_l), '_', num2str(window_r)];
end

if(max_RR == 1)
    full_name_dataset = [full_name_dataset, '_max_RR'];
elseif max_RR == 2
    full_name_dataset = [full_name_dataset, '_min_RR'];
end
if(remove_Savitzky_Golay)
    full_name_dataset = [full_name_dataset, '_remove_Savitzky_Golay'];
end

full_name_dataset = [full_name_dataset,'.mat'];

disp(['loading', full_name_dataset]);
load(full_name_dataset);

signal_patients = [];
%signals_per_class{4} = [];

if(isempty(patient_list) == false)
    datasetAux.patients = [];
    subclasses{1} = {''};
    for p=1:size(patient_list,2)
        pos = find(db.patients == patient_list(p));
        
        signal_patients(p) = size(db.signals{pos}, 2);

        datasetAux.patients = [datasetAux.patients patient_list(p)];
        datasetAux.signals{1, p} = db.signals{1, pos};
        datasetAux.signals{2, p} = db.signals{2, pos};
        
        datasetAux.classes{p} = db.classes{pos};
        
    end
    
    datasetAux.window_l = window_l;        subclasses{1} = {''};
    datasetAux.window_r = window_r;
    
    db = datasetAux;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 Feature extraction (Create descriptor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
features_wave = [];
if(compute_DWT)
    % Wavelets
    features_wave{size(db.signals, 2)} = [];
    
    for(p = 1:size(db.signals, 2))
        for(b =1:size(db.signals{1, p}, 2))
            f_cd1 = [];
            f_cd2 = [];
            f_cd3 = [];
            f_cd4 = [];
            f_cd5 = [];
            f_cd6 = [];
            f_cd7 = [];
            f_cd8 = [];
            f_appw = [];
            
            for s = 1:2
                if signals_used(s)
                    
                    %Daubechies
                    [C, L] = wavedec(db.signals{s, p}(:, b), 8, 'db6');
                    [cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8]= detcoef(C,L,[1,2,3,4,5,6,7,8]);
                    app_w = appcoef(C, L, 'db6', 8);
                    f_cd1 = [f_cd1; cd1];
                    f_cd2 = [f_cd2; cd2];
                    f_cd3 = [f_cd3; cd3];
                    f_cd4 = [f_cd4; cd4];
                    f_cd5 = [f_cd5; cd5];
                    f_cd6 = [f_cd6; cd6];
                    f_cd7 = [f_cd7; cd7];
                    f_cd8 = [f_cd8; cd8];
                    f_appw= [f_appw; app_w];
                end
            end
            features_wave{1,p}(1:length(f_cd1), b) = f_cd1;
            features_wave{2,p}(1:length(f_cd2), b) = f_cd2;
            features_wave{3,p}(1:length(f_cd3), b) = f_cd3;
            features_wave{4,p}(1:length(f_cd4), b) = f_cd4;
            features_wave{5,p}(1:length(f_cd5), b) = f_cd5;
            features_wave{6,p}(1:length(f_cd6), b) = f_cd6;
            features_wave{7,p}(1:length(f_cd7), b) = f_cd7;
            features_wave{8,p}(1:length(f_cd8), b) = f_cd8;
            
        end
    end
    
end
% we calculate statistical variables
features_ecg = [];
data = [];
label = [];
min_cd1 = [];
max_cd1 = [];
var_cd1 = []; 
min_cd2 = [];
max_cd2 = [];
var_cd2 = [];
min_cd3 = [];
max_cd3 = [];
var_cd3 = [];
min_cd4 = [];
max_cd4 = [];
var_cd4 = [];
min_cd5 = [];
max_cd5 = [];
var_cd5 = [];
min_cd6 = [];
max_cd6 = []; 
var_cd6 = [];
min_cd7 = [];
max_cd7 = []; 
var_cd7 = [];
min_cd8 = [];
max_cd8 = []; 
var_cd8 = [];
for(i = 1:size(db.signals, 2))
    
    min_cd1 =[min_cd1, min(features_wave{1,i})];
    
    max_cd1=[max_cd1, max(features_wave{1,i})];
     
    var_cd1=[var_cd1,  var(features_wave{1,i})];
    
    
    min_cd2 =[min_cd2, min(features_wave{2,i})];
    
    max_cd2=[max_cd2, max(features_wave{2,i})];
    
    var_cd2=[var_cd2,  var(features_wave{2,i})];
    
 
    min_cd3 =[min_cd3, min(features_wave{3,i})];
    
    max_cd3=[max_cd3, max(features_wave{3,i})];
    
    var_cd3=[var_cd3,  var(features_wave{3,i})];
    
    
    min_cd4 =[min_cd4, min(features_wave{4,i})];
    
    max_cd4=[max_cd4, max(features_wave{4,i})];
    
    var_cd4=[var_cd4,  var(features_wave{4,i})];
    
    
    min_cd5 =[min_cd5, min(features_wave{5,i})];
    
    max_cd5=[max_cd5, max(features_wave{5,i})];
    
    var_cd5=[var_cd5,  var(features_wave{5,i})];
    
    
    min_cd6 =[min_cd6, min(features_wave{6,i})];
    
    max_cd6 =[max_cd6, max(features_wave{6,i})];
    
    var_cd6=[var_cd6,  var(features_wave{6,i})];
    
     
    min_cd7 =[min_cd7, min(features_wave{7,i})];
    
    max_cd7 =[max_cd7, max(features_wave{7,i})];
    
    var_cd7 =[var_cd7,  var(features_wave{7,i})];
    
   
    min_cd8 =[min_cd8, min(features_wave{8,i})];
    
    max_cd8 =[max_cd8, max(features_wave{8,i})];
    
    var_cd8 =[var_cd8,  var(features_wave{8,i})];
    
    features_ecg = [min_cd1; max_cd1; var_cd1;
                    min_cd2; max_cd2; var_cd2;
                    min_cd3; max_cd3; var_cd3;
                    min_cd4; max_cd4; var_cd4;
                    min_cd5; max_cd5; var_cd5;
                    min_cd6; max_cd6; var_cd6;
                    min_cd7; max_cd7; var_cd7;
                    min_cd8; max_cd8; var_cd8;];
end

%% Create Classes
num_classes = 5;

if class_division == 1 %articulo a comparar
    subclasses{1} = {'N', 'L', 'R', 'j', 'e'};
    subclasses{2} = {'A', 'a', 'S', 'J'};
    subclasses{3} = {'V', 'E'};
    subclasses{4} = {'F'};
    subclasses{5} = {'Q', '/', 'P', 'f'};
    
    
elseif class_division == 2 %articulo 2 desicion tree (2020)
    num_classes = 6;
    subclasses{1} = {'N'};
    subclasses{2} = {'L'};
    subclasses{3} = {'R'};
    subclasses{4} = {'V'};
    subclasses{5} = {'A'};
    subclasses{6} = {'/'};
    
elseif class_division == 3 %considering all subclasses
    
    num_classes = 15;
    
    subclasses{1} = {'N'};
    subclasses{2} = {'L'};
    subclasses{3} = {'R'};
    subclasses{4} = {'e'};
    subclasses{5} = {'j'};
    subclasses{6} = {'A'};
    subclasses{7} = {'a'};
    subclasses{8} = {'J'};
    subclasses{9} = {'S'};
    subclasses{10} = {'V'};
    subclasses{11} = {'E'};
    subclasses{12} = {'F'};
    subclasses{13} = {'/'};
    subclasses{14} = {'f'};
    subclasses{15} = {'Q'};
    
elseif class_division == 4 % Articulo 9 (LSTM)
    subclasses{1} = {'N'};
    subclasses{2} = {'L'};
    subclasses{3} = {'R'};
    subclasses{4} = {'V'};
    subclasses{5} = {'A'};
else % chazal

    subclasses{1} = {'N', 'L', 'R', 'e', 'A'};
    subclasses{2} = {'S', 'j', 'J', 'a'};
    subclasses{3} = {'E', 'V'};
    subclasses{4} = {'F'};
    %subclasses{5} = {'P', '/', 'f', 'u'};
    
end

label = [];
selected_beat = [];

for(p = 1:size(db.signals,2))
    for(b=1:size(db.classes{p},2))
        select = 0;
        
        for(n=1:num_classes) % +1
            if(sum(strcmp(db.classes{p}(b) , subclasses{n})))
                label = [label n];
                select = 1;
            end
        end
        selected_beat = [selected_beat, select];
    end
end

features_ecg = features_ecg';
features_ecg = features_ecg(find(selected_beat == 1),:);
label=label';
features_ecg(:,25) = label;
%% Export as .mat files
full_name = [path_dataset, 'features'];

if(remove_Savitzky_Golay)
    full_name = [full_name, '_remove_Savitzky_Golay'];
end
if(compute_DWT)
    full_name = [full_name, '_extraction_DWT'];
end

full_name = [full_name, '.mat'];

full_name
save(full_name, 'features_ecg');



