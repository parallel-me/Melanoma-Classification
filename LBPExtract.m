%performs PCA and returns 15 features based on Local Binary Patterns
function textureFeatures = LBPExtract(imds,maskDs)
imgs = readall(imds); % read in all images
masks = readall(maskDs);
k = 10;

for i=1:length(imgs)
 disp(sprintf('%2d - %s', i, imds.Files{i}));
 imgs{i} = rgb2gray(ROImasking(imgs{i},masks{i}));
 allhists(i,:) = lbphist(imresize(imgs{i},0.25))';
end


[pcs,score] = pca(allhists.');

textureFeatures = pcs(:,1:15);


function hist = lbphist(image)
% calculate LBP histogram of image
weight_matrix = [16 8 4; 32 0 2; 64 128 1];
image_lbp = zeros(size(image,1)-2, size(image,2)-2);
for iter=2:size(image,1)-1
    for j=2:size(image,2)-1
        block = image(iter-1:iter+1,j-1:j+1); % our 3x3 block
        thisInd = find(block>=block(2,2)); % threshold by centre pixel and identify 1s
    lbpcode = sum(weight_matrix(thisInd)); % turn bitpattern into byte(histogram bin)
    image_lbp(iter-1,j-1) = lbpcode;
    end
end
hist = imhist(uint8(image_lbp), 256); % calculate the LBP histogram
hist = hist / sum(hist); % normalise histogram
end

end