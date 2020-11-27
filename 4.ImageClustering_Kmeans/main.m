clear; close all;

k = 5;
%%
image = rgb2gray(imread('parrot.jfif'));
imshow(my_kmeans(image,k));

%% 2
image = (imread('street.jfif'));
subplot(221);
imshow(image);

% RGB 축으로 표현
[row,col,dim] = size(image);
image2 = double(reshape(image,[row*col,dim]));
subplot(222);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [image2(:,1)/255 image2(:,2)/255 image2(:,3)/255]);
xlabel('R'); ylabel('G'); zlabel('B')

% kmeans 시행
output = my_kmeans3d(image, k);
subplot(223);
imshow(output);

% kmeans RGB축 표현
[row,col,dim] = size(output);
output2 = double(reshape(output,[row*col,dim]));
subplot(224);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [(output2(:,1))/255 (output2(:,2))/255 (output2(:,3))/255]);
xlabel('R'); ylabel('G'); zlabel('B')

%% 3
image = (imread('parrot.jfif'));
figure;
subplot(221);
imshow(image);

% RGB 축으로 표현
[row,col,dim] = size(image);
image2 = double(reshape(image,[row*col,dim]));
subplot(222);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [image2(:,1)/255 image2(:,2)/255 image2(:,3)/255]);
xlabel('R'); ylabel('G'); zlabel('B')

% kmeans 시행
output = my_kmeans5d(image, k, 1);  %거리 가중치는 기본값 1, 클수록 거리를 많이 따짐
subplot(223);
imshow(output);

% kmeans RGB축 표현
[row,col,dim] = size(output);
output2 = double(reshape(output,[row*col,dim]));
subplot(224);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [output2(:,1)/255 output2(:,2)/255 output2(:,3)/255]);
xlabel('R'); ylabel('G'); zlabel('B')

%% 4
image = (imread('street.jfif'));
figure;
subplot(221);
imshow(image);


% kmeans 시행
yuvimage = rgb2yuv(double(image));
yuvoutput = my_kmeansYUV(yuvimage, k);
output = yuv2rgb(double(yuvoutput));
output = uint8(output);
subplot(223);
imshow(output);

% % YUV 축으로 표현
% [row,col,dim] = size(image);
% yuvimage2 = reshape(yuvimage,[row*col,dim]);
% R = yuvimage2(:,1) + (1.13983*yuvimage2(:,3));
% G = yuvimage2(:,1) - (0.39465*yuvimage2(:,2)) - (0.5806*yuvimage2(:,3));
% B = yuvimage2(:,1) + (2.03211*yuvimage2(:,2));
% subplot(222);
% scatter3(yuvimage2(:,1),yuvimage2(:,2),yuvimage2(:,3), 2.5, ...
%     [double(R(:))/255 G(:)/255 B(:)/255]);
% xlabel('Y'); ylabel('U'); zlabel('V')
% 
% % kmeans YUV 축으로 표현
% [row,col,dim] = size(image);
% yuvoutput2 = reshape(yuvoutput,[row*col,dim]);
% R = yuvoutput2(:,1) + (1.13983*yuvoutput2(:,3));
% G = yuvoutput2(:,1) - (0.39465*yuvoutput2(:,2)) - (0.5806*yuvoutput2(:,3));
% B = yuvoutput2(:,1) + (2.03211*yuvoutput2(:,2));
% subplot(224);
% scatter3(yuvimage2(:,1),yuvimage2(:,2),yuvimage2(:,3), 2.5, ...
%     [double(R(:))/255 double(G(:))/255 double(B(:))/255]);
% xlabel('Y'); ylabel('U'); zlabel('V')

% RGB 축으로 표현
[row,col,dim] = size(image);
image2 = double(reshape(image,[row*col,dim]));
subplot(222);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [image2(:,1)/255 image2(:,2)/255 image2(:,3)/255]);
xlabel('R'); ylabel('G'); zlabel('B')

% kmeans RGB축 표현
[row,col,dim] = size(output);
output3 = double(reshape(output,[row*col,dim]));
subplot(224);
scatter3(image2(:,1),image2(:,2),image2(:,3), 2.5, ...
    [output3(:,1)/255 output3(:,2)/255 output3(:,3)/255]);
xlabel('R'); ylabel('G'); zlabel('B')