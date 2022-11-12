% Variables for loading .mat features
remove_Savitzky_Golay =true;
compute_DWT = true;

% Choosing the variable to train and evaluate the classifier (true or false)
Train_ClasificationKNN= false;
Train_ClasificationNN= false;
Train_ClasificationTREE= true;



%% 1 We load the characteristics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_dataset ='../File Models/';
full_path = [path_dataset,'features'];


if(remove_Savitzky_Golay)
    full_name_dataset = [full_path, '_remove_Savitzky_Golay'];
end
if(compute_DWT)
    full_name_dataset = [full_name_dataset, '_extraction_DWT'];
end

full_name_dataset = [full_name_dataset, '.mat'];

disp(['Training algorithm ', full_name_dataset]);
load(full_name_dataset);
inputTable =features_ecg;
predictors = inputTable(:, 1:24);
response = inputTable(:,25);
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

%% Train a classifiers
% This code specifies all the classifier options and trains the classifier.

% KNN
if(Train_ClasificationKNN)
    classification_Model = fitcknn(...
    predictors, ...
    response, ...
    'Distance', 'Mahalanobis', ...
    'Exponent', [], ...
    'NumNeighbors', 4, ...
    'DistanceWeight', 'SquaredInverse', ...
    'Standardize', false, ...
    'ClassNames', [1; 2; 3; 4; 5]);
end

% NeuralNetwork
if(Train_ClasificationNN)
    classification_Model = fitcnet(...
    predictors, ...
    response, ...
    'LayerSizes', 80, ...
    'Activations', 'relu', ...
    'Lambda', 0, ...
    'IterationLimit', 1000, ...
    'Standardize', true, ...
    'ClassNames', [1; 2; 3; 4; 5]);
end

% Decision Tree
if(Train_ClasificationTREE)
    classification_Model = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'deviance', ...
    'MaxNumSplits', 794, ...
    'Surrogate', 'off', ...
    'ClassNames', [1; 2; 3; 4; 5]);
end

%% Performance Evaluation
% Perform cross-validation
partitionedModel = crossval(classification_Model, 'KFold', 10);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
losses = kfoldLoss(partitionedModel,'Mode','individual'); % classification losses
acc_model=[];
for i=1:size(losses,1)
    acc_model=[acc_model; (1-losses(i))];
end
figure(1)
boxchart(acc_model)
ylabel('Accuracy');
xlabel('Classifiers');
ylim([0.965,0.99])
grid on

figure(2)
confussion_matrix = confusionmat(response,validationPredictions);
confusionchart(confussion_matrix)

% Evaluation metrics
idx = (response()==1);
p = length(response(idx));
n = length(response(~idx));
N = p+n;

tp = sum(response(idx)==validationPredictions(idx));
tn = sum(response(~idx)==validationPredictions(~idx));
fp = n-tn;
fn = p-tp;

tp_rate = tp/p;
tn_rate = tn/n;

accuracy = (tp+tn)/N
sensitivity = tp_rate
specificity = tn_rate
precision = tp/(tp+fp)
recall = sensitivity
f_measure = 2*((precision*recall)/(precision + recall))

%% Export the training feature set model as .mat files
full_name = [path_dataset, 'classification_Model'];

if(Train_ClasificationKNN)
    full_name = [full_name, '_KNN'];
end
if(Train_ClasificationNN)
    full_name = [full_name, '_NN'];
end
if(Train_ClasificationTREE)
    full_name = [full_name, '_TREE'];
end
full_name = [full_name, '.mat'];
full_name
save(full_name,'classification_Model');
