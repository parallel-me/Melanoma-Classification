clear, clc;
% load AsymBorder;
% load LBPExtract;

load groundtruthMel.mat;
maskDir = uigetdir(pwd,'Choose Masks Directory');

lesionsDir = uigetdir(pwd,'Choose Lesions Directory');
masks = imageDatastore(strcat(maskDir,'\*.png'));
lesions = imageDatastore(strcat(lesionsDir,'\*.jpg')); % create image datastore
dir = pwd;


[colorFeatures,allhists pcs] = colorExtract(lesions,masks);
textureFeatures = LBPExtract(lesions,masks);
TDSFeatures = AsymBorder(masks);

%combining features to featuremap
featureMap = [TDSFeatures textureFeatures colorFeatures];
Y = string(groundTruth(:,2));
svm = fitcsvm(featureMap,Y);
cvsvm = crossval(svm);
pred = kfoldPredict(cvsvm);
co = confusionmat(pred,Y);
% 
specificity = co(2,2)/(co(2,2)+co(1,2));
sensitivity = co(1,1)/(co(1,1)+co(2,1));
Evals = msgbox(sprintf('Specificity is %f \n Sensitivity is %f',specificity,sensitivity));


figure;
confusionchart(co);