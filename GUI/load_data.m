function [signal,raw_signals,patient] = load_data(records)
%% Read Data
   jump_lines=1;
   raw_signals{2} = [];
   full_signals = csvread(records,jump_lines);
   signal{2} = [];
   
   % Este conjunto de datos contiene dos muestras para el mismo registro
   
   patient =  str2num(records(length(records)-6:length(records)-4));
   
   if patient == 114 %change MLII V5
       signal{1} = full_signals(:, 3); % Modified Lead II (L II) (Derivacion II)
       signal{2} = full_signals(:, 2); % V1, V2, V5....
       
       raw_signals{1} = full_signals(:, 3);
       raw_signals{2} = full_signals(:, 2);
   else
       signal{1} = full_signals(:, 2); % Modified Lead II (L II) (Derivacion II)
       signal{2} = full_signals(:, 3); % V5 NOTE: is not always V5, is V1, V2 and V5....
       
       raw_signals{1} = full_signals(:, 2);
       raw_signals{2} = full_signals(:, 3);
       
   end

end

