function [signals,R_poses] = segmentation(qrs_i_raw,signal,window_l,window_t)
R_poses = [];
selected_R = [];
signals{1} = [];
for i=1:length(qrs_i_raw)
    pos=qrs_i_raw(i);
    
    %% Segmentacion ventana 256
    peak_type = 0;
    % pos = pos-1;
    % determinamos que la clase de la anotacion corresponda a la de
    % la list_classes
    
    if(pos > window_l && pos < (length(signal) - window_t))
        % segmentamos
        signals{1} = [signals{1} signal(pos-window_l:pos+ window_t)];
        
        % asignamos las clases de la señal
        
        selected_R = [selected_R 1];
    else
        selected_R = [selected_R 0];
    end
    
    
    
    R_poses = [R_poses pos];
    
    
end
end

