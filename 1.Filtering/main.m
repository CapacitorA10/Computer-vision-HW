clc; clear; close all;
%% image load
image = imread('lena.png');
if size(image, 3) == 3
    image = rgb2gray(image);
end
%% 1-1
% impulse noise
i_noised = AddImpulseNoise(image, 0.95);
subplot(131);
imshow(i_noised);
title("impulse noised");
% gaussian noise
g_noised = AddGaussianNoise(image, 15);
subplot(132)
imshow(uint8(g_noised));
title("gaussian noised");
% uniform noise
u_noised = AddUniformNoise(image, 40);
subplot(133)
imshow(uint8(u_noised));
title("uniform noised");

%% 1-2
%filtering
g_filtered = GaussianFilt(g_noised, 1.25, 5);       % Gaussian filter
b_filtered = BilateralFilt(g_noised, 2, 30, 5);  % Bilateral filter
m_filtered = MedianFilt(i_noised, 3);           %median filter
figure;
subplot(131)
imshow(g_filtered); title("Gaussian filter");
subplot(132)
imshow(b_filtered); title("Bilateral filter");
subplot(133)
imshow(m_filtered); title("Median filter");


%% 1-3
psnr_in = my_psnr(image, i_noised);
psnr_gn = my_psnr(image, g_noised);
psnr_un = my_psnr(image, u_noised);

psnr_gf = my_psnr(image(4:509, 4:509), g_filtered(4:509, 4:509));
psnr_bf = my_psnr(image(4:509, 4:509), b_filtered(4:509, 4:509));
psnr_mf = my_psnr(image(4:509, 4:509), m_filtered(4:509, 4:509));
fprintf("PSNR : Impulse noise(%.2f), Gaussian noise(%.2f), Uniform noise(%.2f)\n", ...
    psnr_in, psnr_gn, psnr_un);
fprintf("Gaussian filtered(%.2f), Bilateral filtered(%.2f), Median filtered(%.2f)\n", ...
    psnr_gf, psnr_bf, psnr_mf);
    
