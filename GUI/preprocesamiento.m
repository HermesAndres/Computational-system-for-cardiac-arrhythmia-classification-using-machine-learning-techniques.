function [signal,signal_1] = preprocesamiento(remove_Savitzky_Golay,fs,signal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRE-PROCESAMIENTO
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
        signal_1{s}= signal{s};
    end 
end

end

