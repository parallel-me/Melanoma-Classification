function [colorFeatures,allhists pcs] = colorExtract(imds,maskDs)
imgs = readall(imds); % read in all images
masks = readall(maskDs);

for i=1:length(imgs)
 disp(sprintf('%2d - %s', i, imds.Files{i}));
 imgs{i} = ROImasking(imgs{i},masks{i});
 
 %Histogram equalized and 8x8x8 colour histogram matrix is obtained for the
 %image.
 ch = colourhist(imresize(ROImasking(rgb2histeqrgb(imgs{i}),masks{i}),0.25));

 allhists(i,:) = ch(:);
end
[pcs,score] = pca(allhists.');
colorFeatures = pcs(:,1:80);


function [image_eq] = rgb2histeqrgb(image_RGB)
% Colour normalisation through histogram equalisation
nLevels = 255;
for stride=1:size(image_RGB, 3)
    image_eq(:,:,stride) = histeq(image_RGB(:,:,stride), nLevels);
end

end

function hist = colourhist(image)
% generate 8x8x8 RGB colour histogram from image
 noBins = 8; % 8 bins (along each dimension)
 binWidth = 256 / noBins; % width of each bin
 hist = zeros(noBins, noBins, noBins); % empty histogram to start with

 [n m d] = size(image);
 data = reshape(image, n*m, d);
 ind = floor(double(data) / binWidth) + 1; % calculate into which bin
    for iter=1:length(ind)
        hist(ind(iter,1), ind(iter,2), ind(iter,3)) = hist(ind(iter,1), ind(iter,2), ind(iter,3))+ 1; % increment bin
    end

    hist(1) = 0;
    hist = hist / sum(sum(sum(hist))); % normalise histogram
end
end
