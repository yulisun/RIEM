if strcmp(dataset,'#1-Italy') == 1 % Heterogeneous CD of SAR VS. Optical
    image_t1 = imread('Italy_1.bmp');
    image_t2 = imread('Italy_2.bmp');
    gt = imread('Italy_gt.bmp');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'#2-TexasALI') == 1 % Heterogeneous CD of multispectral VS. multispectral
    load('Cross-sensor-Bastrop-data.mat')
    image_t1 = t1_L5(:,:,[4 3 2]);
    image_t2 = t2_ALI(:,:,[7 5 4]);
    gt = double(ROI_1);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'#3-Img7') == 1 % Heterogeneous CD of multispectral VS. multispectral
    image_t1 = imread('Img7-Bc.tif');
    image_t2 = imread('Img7-Ac.tif');
    gt = imread('Img7-C.tif');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    image_t1 = image_t1(1:4:end,1:4:end,:);
    image_t2 = image_t2(1:4:end,1:4:end,:);
    gt = gt(1:4:end,1:4:end,:);
elseif strcmp(dataset,'#4-Img17') == 1 % 
    image_t1 = imread('Img17-Bc.tif');
    image_t2 = imread('Img17-A.tif');
    gt = imread('Img17-C.tif');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'#5-California') == 1 % Heterogeneous CD of SAR VS. Optical
    load('UiT_HCD_California_2017.mat')
    image_t2 = logt2_clipped;
    image_t1 = t1_L8_clipped(:,:,[4 3 2]);
    gt = ROI;
    opt.type_t1 = 'optical';% the SAR image has been Log transformed
    opt.type_t2 = 'optical';    
elseif strcmp(dataset,'#5-California-sampled') == 1 % Heterogeneous CD of SAR VS. Optical
    load('California.mat')
    image_t1 = image_t1;
    image_t2 = image_t2;
    image_t2_temp = image_t1;
    image_t1 = image_t2(:,:,[4 3 2]);
    image_t2 = image_t2_temp;
    opt.type_t1 = 'optical';% the SAR image has been Log transformed
    opt.type_t2 = 'optical';    
elseif strcmp(dataset,'#6-YellowRiver') == 1 % Heterogeneous CD of SAR VS. Optical
    image_t1 = imread('YellowRiver_1.jpg');
    image_t2 = imread('YellowRiver_2.jpg');
    gt = imread('YellowRiver_gt.bmp');
    opt.type_t1 = 'sar';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'#7-Img5') == 1 % 
    image_t1 = imread('Img5-Bc.tif');
    image_t2 = imread('Img5-A.tif');
    gt = imread('Img5-C.tif');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'sar';
    image_t1 = image_t1(1:5:end,1:5:end,:);
    image_t2 = image_t2(1:5:end,1:5:end,:);
    gt = gt(1:5:end,1:5:end,:);        
elseif strcmp(dataset,'#8-TexasL8') == 1 % Heterogeneous CD of multispectral VS. multispectral
    load('Cross-sensor-Bastrop-data.mat')
    image_t1 = t1_L5;
    image_t2 = t2_L8;
    gt = double(ROI_2);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'#9-Shuguang') == 1 % Heterogeneous CD of SAR VS. Optical
    image_t1 = imread('shuguang_1.bmp');
    image_t2 = imread('shuguang_2.bmp');
    gt = imread('shuguang_gt.bmp');
    opt.type_t1 = 'sar';
    opt.type_t2 = 'optical';
end
Ref_gt = double(gt(:,:,1));
% plot images
if strcmp(dataset,'#2-TexasALI') == 1
    figure;
    subplot(131);imshow(2*image_t1);title('imaget1')
    subplot(132);imshow(6*image_t2);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#8-TexasL8') == 1
    figure;
    subplot(131);imshow(2*image_t1(:,:,[4 3 2]));title('imaget1')
    subplot(132);imshow(2*image_t2(:,:,[7 5 4]));title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
elseif strcmp(dataset,'#5-California-sample') == 1
    figure;
    subplot(131);imshow(image_t1);title('imaget1')
    subplot(132);imshow(image_t2+1);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
else
    figure;
    subplot(131);imshow(image_t1);title('imaget1')
    subplot(132);imshow(image_t2);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
end
%%
image_t1 = double(image_t1);
image_t2 = double(image_t2);
image_t1 = image_normlized(image_t1,opt.type_t1);
image_t2 = image_normlized(image_t2,opt.type_t2);
Ref_gt = Ref_gt/max(Ref_gt(:));
h = fspecial('average',5);
image_t1 = imfilter(image_t1, h,'symmetric');
image_t2 = imfilter(image_t2, h,'symmetric');