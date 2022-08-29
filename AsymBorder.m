% when passed the Directory of masked images, extracts Asymmetry and
% BorderIrregularity

function features = AsymBorder(imds)
    imgs = readall(imds); 

    for i=1:length(imgs)
        disp(sprintf('%2d - %s', i, imds.Files{i}));
  
    inputImage = padarray(imgs{i},[10 10],0,'both');
    inputImage = imresize(inputImage, 0.25);
   
    % Get the dimensions of the image.  
    % numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
    [rows, columns, numberOfColorChannels] = size(inputImage);
    
    %padding and resizing
    bin = padarray(imgs{i},[10 10],0,'both');
    bin = imresize(bin, 0.25);

    binarymask = logical(bin);
    subplot(2, 2, 2);
    imshow(binarymask);
    axis on;
    title('Centres of Binary Image');
    drawnow;
    
    % Label the image
    labeledImage = bwlabel(binarymask);
    % Make the measurements
    props = regionprops(labeledImage, 'Centroid', 'Orientation', 'Area', 'Circularity');
    xCentroid(i,:) = props.Centroid(1);
    yCentroid(i,:) = props.Centroid(2);
    Area(i,:) = props.Area;

    % Find the centre point of the image.
    centreX = columns/2;
    centreY = rows/2;
    
    hold on;

    line([centreX, centreX], [1, rows], 'Color', 'b', 'LineWidth', 2);
    line([1, columns], [centreY, centreY], 'Color', 'y', 'LineWidth', 2);
    plot(xCentroid(i,:), yCentroid(i,:), 'r+', 'MarkerSize', 30);
    plot(xCentroid(i,:), yCentroid(i,:), 'ro', 'MarkerSize', 30);
    
    % Translation
    changeX = centreX - xCentroid(i,:);
    changeY = centreY - yCentroid(i,:);
    binarymask = imtranslate(binarymask,  [changeX, changeY]);
    
    % Subplot the translated mask
    subplot(2, 2, 3);
    imshow(binarymask);
    axis on;
    title('Binary Mask Translated to Centre');
    hold on;
    
    line([centreX, centreX], [1, rows], 'Color', 'b', 'LineWidth', 2);
    line([1, columns], [centreY, centreY], 'Color', 'y', 'LineWidth', 2);
    drawnow;
    
    % Rotate the image
    angle = -props.Orientation
    rotated = imrotate(binarymask, angle, 'crop');
    
    % Display the rotated image.
    subplot(2, 2, 4);
    imshow(rotated);
    axis on;
    caption = sprintf('Rotated %f Degrees', angle);
    title(caption);
    hold on;
    
    line([centreX, centreX], [1, rows], 'Color', 'b', 'LineWidth', 2);
    line([1, columns], [centreY, centreY], 'Color', 'y', 'LineWidth', 2);
    drawnow;
    
    topArea = sum(sum(binarymask(1:rows/2,:)));
    bottomArea= sum(sum(binarymask(rows/2+1:end,:)));
    areaDifference(i,:) = abs(topArea - bottomArea);
    
    asymmetryIndex(i,1) = areaDifference(i,:)/Area(i,:);
    borderProp(i,1) = props.Circularity;
    features(i,1) = asymmetryIndex(i,1);
    features(i,2) = borderProp(i,:);
    
    end
end
