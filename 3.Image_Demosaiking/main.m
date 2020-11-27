clc; clear; close all;
%% 3-1
image = double(imread('babbon.bmp'));
bayer_image = RGBtoBayer(image);
figure;
imshow(uint8(bayer_image)); title("Bayer image");

%% 3-2
% demosaic_image = double(demosaic(uint8(bayer_image), 'rggb'));
demosaic_image = my_demosaic(bayer_image);
figure;
imshow(uint8(demosaic_image)); title("bilinear interpolation");

%% 3-3
psnr1 = my_psnr(image, demosaic_image)

%% 3-4
mean_originalR = mean(mean(image(:,:,1)));
mean_originalG = mean(mean(image(:,:,2)));
mean_originalB = mean(mean(image(:,:,3)));
mean_interpolatedR = mean(mean(demosaic_image(:,:,1)));
mean_interpolatedG = mean(mean(demosaic_image(:,:,2)));
mean_interpolatedB = mean(mean(demosaic_image(:,:,3)));

var_originalR = var(var(image(:,:,1)));
var_originalG = var(var(image(:,:,2)));
var_originalB = var(var(image(:,:,3)));
var_interpolatedR = var(var(demosaic_image(:,:,1)));
var_interpolatedG = var(var(demosaic_image(:,:,2)));
var_interpolatedB = var(var(demosaic_image(:,:,3)));

figure;
subplot(231); bar(CalcHist(image(:,:,1))); title("original red");
subplot(232); bar(CalcHist(image(:,:,2))); title("original green");
subplot(233); bar(CalcHist(image(:,:,3))); title("original blue");
subplot(234); bar(CalcHist(demosaic_image(:,:,1))); title("interploated red");
subplot(235); bar(CalcHist(demosaic_image(:,:,2))); title("interploated green");
subplot(236); bar(CalcHist(demosaic_image(:,:,3))); title("interploated blue");

%% 3-5
demosaic_improved = my_demosaic2(bayer_image, 1);
figure;
imshow(uint8(demosaic_improved));  title("improved interpolation");
psnr2 = my_psnr(image, demosaic_improved)
