clc; clear; close all;

threshold = 0.002;
resize = 1;
QryImage = imread('eat.png');
TgtImage = imread('map1.png');
TgtImage = double(imresize(TgtImage, size(TgtImage(:,:,1))*resize));


if size(QryImage, 3) == 3
    QryImage = rgb2gray(QryImage);
end
if size(TgtImage, 3) == 3
    TgtImage2 = double(rgb2gray(uint8(TgtImage)));
end
QryImage_resize = double(imresize(QryImage, [32,32]));


cell = 8;
[Qx, Qy] = hog(QryImage_resize, cell, true);    % 랩미팅때만든 호그, 투영까지

%% target image gradient
[row, col] = size(TgtImage2);
figure;
imshow(TgtImage/255); hold on;
temp = 0;
for i = 1 : 2 : row-31              % stride 지정
    for j = 1 : 2 : col-31
        dvided_tgt = TgtImage2(i:i+31, j:j+31);
%% hog2를 쓰면 개선판, hog를 쓰면 기존판.
        [Tx,Ty] = hog2(dvided_tgt, cell, 11000, false);  
        distance = sum(sum((Qx - Tx)).^2 + sum((Qy - Ty)).^2);
        
        if distance < threshold
            disp(distance);
            plot([j,j+32,j+32,j,j],[i,i,i+32,i+32,i],'Color','r', 'LineWidth', 2);
            temp = temp + 1;
        end
        
    end
end
