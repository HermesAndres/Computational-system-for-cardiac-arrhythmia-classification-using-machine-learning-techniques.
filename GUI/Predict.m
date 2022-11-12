function [accuracy,class,score,Cantidad] = Predict(features_ecg,full_name_classification_model)
load(full_name_classification_model);
arritmia_signal=features_ecg;

[class,score]=predict(classification_Model,arritmia_signal);
accuracies=[];
% Calcular el error de prediccion
for a=1:length(score)
    accuracies(a,:)=max(score(a,:));
end
accuracy=mean(accuracies);

% Detectar cuantas clases de arritmias hay en la señal
list_class=[1,2,3,4,5];
clase=5;
num_class=0;
Cantidad=zeros(1,5);

for x=1:length(list_class)
    for y=1:length(class)
        if(list_class(x)==class(y))
            num_class=num_class+1;  
            Cantidad(x)=num_class;
        end
    end
    num_class=0;
end

% Mostrar Datos
%disp(strcat("Cantidad de latidos del registro ",string(patient_list)))
disp(strcat("N = ",string(Cantidad(1))))
disp(strcat("S = ",string(Cantidad(2))))
disp(strcat("V = ",string(Cantidad(3))))
disp(strcat("F = ",string(Cantidad(4))))
disp(strcat("U = ",string(Cantidad(5))))
disp(strcat("Accuracy = ",string(accuracy)))
end

