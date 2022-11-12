function varargout = Analisis(varargin)
% ANALISIS MATLAB code for Analisis.fig
%      ANALISIS, by itself, creates a new ANALISIS or raises the existing
%      singleton*.
%
%      H = ANALISIS returns the handle to a new ANALISIS or the handle to
%      the existing singleton*.
%
%      ANALISIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALISIS.M with the given input arguments.
%
%      ANALISIS('Property','Value',...) creates a new ANALISIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analisis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analisis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analisis

% Last Modified by GUIDE v2.5 09-Nov-2022 19:31:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analisis_OpeningFcn, ...
                   'gui_OutputFcn',  @Analisis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Analisis is made visible.
function Analisis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analisis (see VARARGIN)
centerfig;
global file;
set(handles.text1,'String',['Archivo seleccionado: ', file]);
set(handles.panel1,'visible','off');
set(handles.panel2,'visible','off');
% Choose default command line output for Analisis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analisis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analisis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in B_Regresar.
function B_Regresar_Callback(hObject, eventdata, handles)
close(Analisis);
pause(0.3);
Inicio;




% --- Executes on button press in B_Analizar.
function B_Analizar_Callback(hObject, eventdata, handles)
set(handles.B_Analizar,'String',"Analizando...");
pause(0.01)

% Variables to load
remove_Savitzky_Golay =true;
compute_DWT=true;
max_RR = 1;
window_l = 99;
window_t = 100;
fs = 360;
global records;

% Clasifier
Train_ClasificationKNN= true;
Train_ClasificationNN= false;
Train_ClasificationTREE= false;

% load training file
path_dataset ='../File Models/';
full_path = [path_dataset,'classification_Model'];

if(Train_ClasificationKNN)
    full_name_classification_model = [full_path, '_KNN'];
end
if(Train_ClasificationNN)
    full_name_classification_model = [full_path, '_NN'];
end
if(Train_ClasificationTREE)
    full_name_classification_model = [full_path, '_TREE'];
end
full_name_classification_model = [full_name_classification_model, '.mat'];



%% Load signal

[signal,raw_signals]=load_data(records);

%% Signal preprocessing
[signal,signal_1] = preprocesamiento(remove_Savitzky_Golay,fs,signal);

%% Location of Picos R
[qrs_i_raw,qrs_amp_raw,locs,NOISL_buf1,SIGL_buf1,THRS_buf1] = R_peaks(signal{1},signal_1{1},fs);

%% Segmentation
[signals,R_poses] = segmentation(qrs_i_raw,signal{1},window_l,window_t);

%% Extraction of characteristics
[features_ecg] = Feature_extraction (signals,compute_DWT);

%% Predicting the arrhythmia signal with the training model
[accuracy,class,score,Cantidad] = Predict(features_ecg,full_name_classification_model);

%% Extract the detected segments of each class
[class_N,class_S,class_V,class_F,class_U,segments_class] = Mostrar_arritmias(class,signals);

%% Plottings
set(handles.panel1,'visible','on');
Plottings(qrs_i_raw,qrs_amp_raw,signal{1},raw_signals{1},signals{1},locs,NOISL_buf1,SIGL_buf1,THRS_buf1,segments_class);

%% Show data
set(handles.panel2,'visible','on');
N = strcat("Latido No Ectopico       (N) = ",string(Cantidad(1)));
S = strcat("Latido Supraventricular (S) = ",string(Cantidad(2)));
V = strcat("Latido Ventricular         (V) = ",string(Cantidad(3)));
F = strcat("Latido de Fusión           (F) = ",string(Cantidad(4)));
U = strcat("Latido Desconocidos    (U) = ",string(Cantidad(5)));
accuracy= round(accuracy*100,2);
Datos = [N;S;V;F;U];
set(handles.L_1,'String',Datos);
set(handles.text5,'String',length(class));
set(handles.text8,'String',string(accuracy +"%"));
set(handles.B_Analizar,'visible','off');
%set(handles.B_Analizar,'String',"Analizar");



             


% --- Executes during object creation, after setting all properties.
function L_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
