function [features_ecg] = Feature_extraction (signals,compute_DWT)

features_wave = [];
if(compute_DWT)
    % Wavelets
    features_wave{size(signals, 2)} = [];
    
    for(p = 1:size(signals, 2))
        for(b =1:size(signals{1, p}, 2))
            f_cd1 = [];
            f_cd2 = [];
            f_cd3 = [];
            f_cd4 = [];
            f_cd5 = [];
            f_cd6 = [];
            f_cd7 = [];
            f_cd8 = [];
            f_appw = [];
            
        
                    
                    %Daubechies
                    [C, L] = wavedec(signals{1, p}(:, b), 8, 'db6');
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
% calculamos variables estadisticas
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
for(i = 1:size(signals, 2))
    
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
features_ecg = features_ecg';
end

