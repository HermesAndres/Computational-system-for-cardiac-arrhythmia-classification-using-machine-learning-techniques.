# ECG Diagnostic Support System
> :warning: This is a continuation of [another project](https://github.com/mondejar/ecg-classification), developed for the Final Project on cardiac arrhythmia classification. 

This work presents a system to support the diagnosis of normal and pathological pulses in ECG recordings, capable of analyzing the characteristics of QRS complexes that greatly help to classify cardiac arrhythmias. In addition, this research uses the Massachusetts Institute of Technology-BIH cardiac arrhythmia database, which has 48 records of different arrhythmias. Likewise, supervised machine learning algorithms and appropriate feature selection are implemented to generate a low computational cost computer system, which allows processing, characterization, classification and visualization of the results. Given its relevance in the clinical setting, its performance is validated using performance measures recommended by the literature.


## Authors
Hermes Andrés Ayala Cucas (hayala@umariana.edu.co)

Edison Alexander Mora Piscal (edimora@umariana.edu.co)

Dagoberto Mayorca Torres (dmayorca@umariana.edu.co)

## Software used
MATLAB R2021a

## Database used
MIT-BIH Arrhythmia Database - PhysioBank ATM: (https://physionet.org/content/mitdb/1.0.0/)

The dataset selected for this study corresponds to the MIT-BIH cardiac arrhythmia database. The database contains two-channel ambulatory ECG records from 47 individuals analyzed by the BIH Arrhythmia Laboratory between 1975 and 1979. Forty-eight half-hour recordings were collected using analog Holter equipment with a sampling rate of 360 Hz and 11-bit resolution over a range of 10 mV. The database includes about 110.000 records, with five classes of arrhythmias: Nonectopic beats (N), Fusion beats (F), Supraventricular ectopic beats (S), Ventricular ectopic beats (V), and Unknown beats (U). Cardiologists performed the classification and annotation of the recordings of each heartbeat. 


## List and specification of files
1. Folder (File Models)
 
In this folder you will find four files with extension (.mat). The files with the name (classification_model_classifier) are the training models generated by our machine learning classifiers. The file with the name (features_remove_Savitzky_Golay_extraction_DWT) is the set of features extracted from all ECG records previously labeled with each arrhythmia class.

2) Folder (Generate_Learning_model)

In this folder you will find the files responsible for generating all the models found in the folder (File Models). On the one hand, you will find a folder containing all the records of the MIT-BIH arrhythmia database with extension (.csv) together with their annotations (.txt).
On the other hand, you will find three files (.m), of which the file (Load_Preprocess_Segment_Dataset) is responsible for loading all the database records as well as preprocessing and segmenting the signals. The file (ExtractFeatures_Dataset) is in charge of extracting all the features from the signal segments and finally the file (Training_Evaluation_Classifiers) is in charge of training the feature set using classifiers such as KNN, neural networks and decision trees. In the same way, it is also in charge of evaluating which classifier offers the best performance by applying some metrics recommended by the literature.

3) Folder (GUI)

This folder contains the codes responsible for generating the display interface for the detection and classification of cardiac arrhythmias. 

## Steps (How to run)

The following three steps of the implemented methodology are optional, however, if you want to know how the methodological process was to determine the best training model to perform the detection and classification of cardiac arrhythmias follow the steps in section 1. Otherwise, just start executing the steps in section 2, where the graphical interface will be executed.

### Section 1 (Methodology)
1) Loading, preprocessing and segmentation of ECG signals

As a first step, go to the folder (Generate_Learning_model). Once inside the folder, run the code (Load_Preprocess_Segment_Dataset.m). This code will load all the ECG signal records found in the folder (Database_MITBIH). Subsequently, the code will preprocess the ECG signals using digital filters (Butterworth - Savistky Golay) and finally generate the signal segments with a length of 200 samples. Once the code is finished, it will generate a file named (data_w_99_100_max_RR_remove_Savitzky_Golay.mat) which will be saved in the folder (File Models).
This generated file contains several models including the original ECG signals, filtering, R peak positions and segments of all signals that will be used in the following code.

2) Extract features from ECG signals

In the second step, run the code (ExtractFeatures_Dataset). This code first loads the file (data_w_99_100_max_RR_remove_Savitzky_Golay.mat) located in the folder (File Models). Subsequently, it performs the feature extraction of the signal segments using the discrete Wavelet transform (DWT). Finally, once the features are generated, the code will save a file named (features_remove_Savitzky_Golay_extraction_DWT.mat) in the (File Models) folder that will be used to train the feature set in the following code.

3) Training characteristics and performance evaluation 

In this third step, run the code (Training_Evaluation_Classifiers.m). This code, in particular, is responsible for loading the file with the features (features_remove_Savitzky_Golay_extraction_DWT.mat) that were generated in the previous code. Subsequently, depending on the classifier to be used (KNN, NN or TREE) it will perform the training of the features and evaluate which classifier offers the best performance. Finally, depending on which classifier offers the best performance it will save a file named (classification_Model_nameclasifier.mat) in the folder (Files Models).
In this particular case, in this work the three classifiers were evaluated and the one with the best performance was the model with the KNN classifier. However, the other two models can be tested and improved.

Once the whole methodological process has been executed to observe which training model offers the best performance, we proceed to test and run the graphical interface.

### Section 2 (Interface)

1) Go to the folder (GUI) where you will find several function codes (.m) that perform the process of data reading, preprocessing, peak detection, segmentation, prediction, data visualization and other codes that perform the same methodological process of section 1. 
2) To start the interface, execute the function code (Inicio.m), this code will open a window in which the ECG diagnostic system is started, the file with extension (csv) to be analyzed must be selected by clicking on the "Select record" button.
3) Once the file has been selected, the next step is to start the analysis process by clicking on the "Analyze" button.
4) Subsequently, after analysis, it displays the classification results of the selected recording. The diagrams of the modeling process are shown in the left part; they include the original ECG signal, the filtered signal, the R-peak detection and the signal segmentation. The right part of the window shows the diagnostic results provided by our system; these results include the total number of detected beats and the number of beats classified according to AAMI standards. In addition, the prediction accuracy in the diagnosis of cardiac arrhythmias is shown presenting the reliability in the recognition and detection of this type of pathologies. 
5) Finally, to select and analyze a new record, repeat the process by pressing the "Back" button.

## Software references: Beat Detection
 [*Pan Tompkins*] https://la.mathworks.com/matlabcentral/fileexchange/101078-qrs-detection-using-pan-tompkins-algorithm-from-ecg-signal?s_tid=FX_rc1_behav
 

