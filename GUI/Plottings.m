function Plottings(qrs_i_raw,qrs_amp_raw,signal,raw_signals,signals,locs,NOISL_buf1,SIGL_buf1,THRS_buf1,segments_class)
%% ======================= Plottings ================================= %%

az(1)=subplot(411);
plot(raw_signals/200);
ylabel('Amplitud (mv)');
xlabel('Muestras');
title('Señal de ECG Original');
axis tight;
grid on;
grid minor;
xlim([0,2000])

az(2)=subplot(412);
plot(signal/200);
title('Preprocesamiento de la señal de ECG');
ylabel('Amplitud (mv)');
xlabel('Muestras');
axis tight;
grid on;
grid minor;
xlim([0,2000])

az(3)=subplot(413);
plot(signal/200);
ylabel('Amplitud (mv)');
xlabel('Muestras');
title('Pico R de la señal de ECG');
axis tight;
hold on,scatter(qrs_i_raw,qrs_amp_raw/200,'m');
hold on,plot(locs,NOISL_buf1/200,'LineWidth',2,'Linestyle','--','color','k');
hold on,plot(locs,SIGL_buf1/200,'LineWidth',2,'Linestyle','-.','color','r');
hold on,plot(locs,THRS_buf1/200,'LineWidth',2,'Linestyle','-.','color','g');
xlim([0,2000])
grid on;
grid minor;
hold off;

az(4)=subplot(414);
signals=(signals)/200;
plot(signals);
ylabel('Amplitud (mv)');
xlabel('Muestras');
title(strcat('Segmento de Señal de ECG'));
grid on;
grid minor;

%% Ploteamos latidos de cada clase
lon=0;
Name_class=[];
list_class=[1,2,3,4,5];
tipo_class=['N','S','V','F','U'];
for(s=1:5)
    if isempty(segments_class{s}) 
    else
       lon=lon+1; 
       segments_class_1{lon}=segments_class{s};
       Name_class=[Name_class s];
    end
end

for(r=1:5)
    for(f=1:lon)
    if(list_class(r)==Name_class(f))
        Arritmia{f}=tipo_class(r);
    end
    end
end


% for(i=1:lon)
%     if isempty(segments_class_1{i})
%     else
%         P=subplot(1,lon,i);
%         plot(segments_class_1{i}/200);
%         ylabel('Amplitud (mv)');
%         xlabel('Muestras');
%         title(strcat("Latidos de Clase tipo  ",Arritmia{i}));
%         grid on;
%         grid minor;
%     end
% end
end


