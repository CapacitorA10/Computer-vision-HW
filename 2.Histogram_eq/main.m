clc; clear; close all;
%% image load
image = imread('city.jpg');
if size(image, 3) == 3
    image = rgb2gray(image);
end
[row, col] = size(image);

%% 2-1
histo = CalcHist(image);
bar(histo);

%% 2-2, 2-3
equalized = HistEqlize(histo, image);
histo2 = CalcHist(equalized);

equalizedOWN = myOWNeq(histo, image, 3);
histoOWN = CalcHist(equalizedOWN);

subplot(231); 
imshow(image); title("input");
subplot(234);
bar(histo);

subplot(232); 
imshow(equalized); title("histogram equalization");
subplot(235);
bar(histo2);

subplot(233); 
imshow(equalizedOWN); title("Beber's Law used");
subplot(236);
bar(histoOWN);