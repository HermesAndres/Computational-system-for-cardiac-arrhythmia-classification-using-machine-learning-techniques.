% variable for signal filtering
remove_Savitzky_Golay =true;
max_RR = 1;
% Segment size (200 samples)
window_l = 99;
window_t = 100;
signals_used = [1, 0]

%% 0 read data set
path_dataset = 'Database_MITBIH/';
fs = 360;
jump_lines = 1;


num_recs = 0;
records = [];
num_annotations = 0;
annotation_files = [];

files = dir(path_dataset);
files([files.isdir]) = [];
for f = 1:length(files)
    filename = files(f).name;
    if( strcmp(filename(length(filename)-3:length(filename)),  '.csv') )
        num_recs = num_recs+1;
        records{num_recs} = [path_dataset, files(f).name];
    else
        num_annotations = num_annotations +1;
        annotation_files{num_annotations} = [path_dataset,  files(f).name];
    end
end

%% Read Data

inst = 0;
filenames = []; %
patients = [];
classes{length(records)} = [];
signals{2, length(records)} = [];
R_poses{length(records)} = [];
Original_R_poses{length(records)} = [];
fiducial_points{length(records)} = [];
selected_R{length(records)} = [];
HH_intervals{length(records)} = [];
% window_size samples before and after R peak
list_classes = {'N', 'L', 'R', 'e', 'j', 'A', 'a', 'J', 'S', 'V', 'E', 'F', 'P', '/', 'f', 'Q'};

raw_signals{2, length(records)} = [];

size_RR_max = 20;

for r = 1:length(records)
    r
    filename = records(r);
    full_signals = csvread(filename{1}, jump_lines);    % omita la primera línea y luego lea los archivos .csv
    signal{2} = [];
    % Este conjunto de datos contiene dos muestras para el mismo registro
    
    patient =  str2num(filename{1}(length(filename{1})-6:length(filename{1})-4));
    
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
    
    % We read Annotations
    filename_annotations = annotation_files(r);
    filenames = [filenames filename];
    patients = [patients patient];
    
    fileID = fopen(filename_annotations{1}, 'r');
    % Saltar la primera línea
    % Time   Sample #  Type  Sub Chan  Num	Aux
    tline = fgets(fileID);
    annotations = textscan(fileID, '%s');
    annotations = annotations{1};
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PRE-PROCESSING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for s=1:2
        if(remove_Savitzky_Golay)
            % Remove linea base
            cut_off = 1/(fs/2);
            order = 3;
            [b,a] = butter(order, cut_off, 'high');
            signal{s} = filtfilt(b, a, signal{s});
            
            %filter Savitzky_Golay
            signal{s}= sgolayfilt(signal{s},5,21);
        end      
    end
    
    %% We located the R Peaks from the annotations
    for i = 1:length(annotations)
        if((findstr(annotations{i}, ':') > 0))
            pos = str2num(annotations{i+1}); % Convierta una matriz de caracteres o una cadena en una matriz numéric
            
            % Los puntos fiduciales provistos ocurren en el instante 
            % del extremo local principal de un complejo QRS (es decir, el tiempo
            % del máximo de la onda R o del mínimo de la onda S). estos fiduciarios
            % Los puntos porcentuales se obtuvieron primero automáticamente y luego se corrigieron manualmente.
            % rect. latido a latido (Chazal)
            
            % Establecer pos en el pico máximo verdadero en la ventana [-5,5]
            unchanged_pos = pos;
            if(max_RR && (pos > size_RR_max && pos < (length(signal{1}) - size_RR_max)))
                if max_RR == 1
                    [max_value, max_pos] = max(signal{1}(pos-size_RR_max:pos + size_RR_max));
                elseif max_RR == 2
                    [max_value, max_pos] = min(signal{1}(pos-size_RR_max:pos + size_RR_max));
                end
                pos = (pos-size_RR_max) + max_pos;
            end
            
            %% Segmentation window 200 samples
            peak_type = 0;
            pos = pos-1;
            % determinamos que la clase de la anotacion corresponda a la de
            % la list_classes
            if(sum(strcmp(annotations{i+2}, list_classes)))
                if(pos > window_l && pos < (length(signal{1}) - window_t))
                    % segmentamos
                    signals{1, r} = [signals{1, r} signal{1}(pos-window_l:pos+ window_t)];
                    signals{2, r} = [signals{2, r} signal{2}(pos-window_l:pos+ window_t)];
                    % asignamos las clases de la señal
                    classes{r} = [classes{r} annotations(i+2)];
                    selected_R{r} = [selected_R{r} 1];
                else
                    selected_R{r} = [selected_R{r} 0];
                end
            else
                selected_R{r} = [selected_R{r} 0];
            end
            
            R_poses{r} = [R_poses{r} pos];
            Original_R_poses{r} = [Original_R_poses{r}, unchanged_pos];
        end
    end
    
%% Graphics 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficamos Fitrado de Señaless
% figure;
% name_signal= filename{1}(length(filename{1})-6:length(filename{1})-4);
% subplot(2,1,1);
% plot(raw_signals{1});
% ylabel('Amplitud (mv)');
% xlabel('Muestras');
% xlim([0,1000])
% title(strcat('Señal de ECG ruidosa'));
%grid on
%hold on
% 
% subplot(2,1,2);
% plot(signal{1});
% ylabel('Amplitud (mv)');
% xlabel('Muestras');
% xlim([0,1000])
% title(strcat('Señal de ECG filtrada'));
% grid on
% strExport = sprintf('%s-Señal ECG Filtrada%d-%s',name_signal );
% print(strExport,'-dpng');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficamos signal and R-peaks
% name_signal= filename{1}(length(filename{1})-6:length(filename{1})-4);
% figure;
% plot(signal{1});
% hold on;
% scatter(R_poses{r}, signal{1}(R_poses{r}), 'r')
% ylabel('Amplitud (mv)');
% xlabel('Muestras');
% xlim([0,1000])
% title(strcat('Señal R-peaks '));
% strExport = sprintf('%s-Señal R-peaks %d-%s',name_signal );
% print(strExport,'-dpng');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graficamos Segmento de Señaless
% signals{1, r}=(signals{1, r})/200;
% name_signal= filename{1}(length(filename{1})-6:length(filename{1})-4); 
% figure; 
% plot(signals{1, r});
% ylabel('Amplitud (mv)');
% xlabel('Muestras');
% title(strcat('Segmento de Señal de ECG '));
% grid on
% strExport = sprintf('%s-Señal Segmento %d-%s',name_signal );
% print(strExport,'-dpng');
%  
end

%% Export as .mat files
output_path = '../File Models/';

db.filenames = filenames;
db.patients = patients;
db.signals = signals;
db.classes = classes;
db.selected_R = selected_R;

db.raw_signals = raw_signals;

db.R_poses = R_poses;
db.window_l = window_l;
db.window_t = window_t;

full_name = [output_path, 'data_w_', num2str(window_l), '_', num2str(window_t)];

if(max_RR == 1)
    full_name = [full_name, '_max_RR'];
end
if(max_RR == 2)
    full_name = [full_name, '_min_RR'];
end
if(remove_Savitzky_Golay)
    full_name = [full_name, '_remove_Savitzky_Golay'];
end

full_name
save(full_name, 'db');