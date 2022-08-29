%Region of Interest Masking using supplied masks.

function result = ROImasking(im,mask)

%create masks in all three channels for RGB 
mask(:,:,2) = mask;
mask(:,:,3) = mask(:,:,1);

ROI = im;

%Logical indexing augments the image pixels to zero outside the mask region

ROI(mask == 0) = 0;

result = ROI;

end