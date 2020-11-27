clc; clear; close all;
threshold = 0.2
image1_rgb = imread('4.jpg');
image1 = rgb2gray(image1_rgb);
image1 = rot90(image1,3);
image1_rgb = rot90(image1_rgb,3);
image2_rgb = imread('5.jpg');
image2 = rgb2gray(image2_rgb);


p1 = detectSURFFeatures(image1);
p2 = detectSURFFeatures(image2);
[feature1, pnt1] = extractFeatures(image1, p1);
[feature2, pnt2] = extractFeatures(image2, p2);

%% feature 이용해 최근접점 찾기

[least_dots,info] = dsearchn(feature1, feature2);      %최근접점 index
least_dots = least_dots.* (info < threshold);               %임계치 이상으로 가까운 애들만
least_dots1 = least_dots(find(least_dots));            %1번에 대한 인덱스
least_dots2 = find(least_dots);                        %2번에 대한 인덱스
imgSum = [image1_rgb image2_rgb;]; 
loc2_512(:,1) = pnt2.Location(:,1)+size(image1,1);
loc2_512(:,2) = pnt2.Location(:,2);         %이미지 이어 붙이기 완료
nearist1 = pnt1.Location(least_dots1,:);
nearist2 = pnt2.Location(least_dots2,:);          %이어 붙인 이후의 point들

imshow(imgSum); hold on;
scatter(pnt1.Location(:,1), pnt1.Location(:,2), 'b*');
scatter(loc2_512(:,1), loc2_512(:,2), 'c*');              %특징점 scatter로 나타내기
nearist_x = [pnt1.Location(least_dots1,1), loc2_512(least_dots2,1)]; % plot을 위한 x좌표 모음
nearist_y = [pnt1.Location(least_dots1,2), loc2_512(least_dots2,2)]; % y좌표 모음

for i = 1 : size(least_dots2,1)
    % 매칭 lines 플롯
    plot(nearist_x(i,:), nearist_y(i,:), 'g');
end

%% LMSe Start 
a1 = zeros(2*size(nearist1,1), 2); a2 = zeros(size(a1));
a1(1:2:end) = nearist1;
a2(2:2:end) = nearist1;
onezero = zeros(size(a1,1),1); zeroone = zeros(size(onezero));
onezero(1:2:end) = 1;
zeroone(2:2:end) = 1;
A(:, 1:2) = a1;
A(:, 3) = onezero;
A(:, 4:5) = a2;
A(:, 6) = zeroone;
j = 1;
for i = 1 : size(nearist1, 1)
    A(j, 7:8) = -[nearist1(i,1) .* nearist2(i,1); nearist1(i,2) .* nearist2(i,1)]; % ux uy
    A(j+1, 7:8) = -[nearist1(i,1) .* nearist2(i,2); nearist1(i,2) .* nearist2(i,2)]; % vx vy
    j = j + 2;
end
clear a1 a2 onezero zeroone
B=reshape(pnt2.Location(least_dots2(:),:)',2*size(pnt2.Location(least_dots2(:),:),1),[]);
Te = inv(A'*A)*A'*B;
% Te = A\B;
T = reshape([Te;1],3,3)';   %변환행렬 T 도출완료

%% T 가지고 점변환
figure; subplot(122)
imshow(image2_rgb); hold on;
A2 = [nearist1 ones(size(nearist1,1),1)];
Transformed = T * A2';
Transformed = Transformed./Transformed(3,:);
Transformed = Transformed(1:2,:)';
for i = 1 : size(nearist1, 1)
    scatter(Transformed(i,1), Transformed(i,2), 50, 'm', 'filled');     % 점변환 표현
end
subplot(121); imshow(image1_rgb); hold on;
for i = 1 : size(nearist1, 1)
    scatter(nearist1(i,1), nearist1(i,2), 50, 'r', 'filled');     % 점변환 표현
end


%% T를 가지고 이미지변환
clear A2 Tranformed
figure
img = zeros(2048,2048,3);
for i = -1024 : 1024
    for j = -1024 : 1024
        Atemp = [j i];
        A2 = [Atemp ones(size(Atemp,1),1)];
        Transformed = T * A2';
        Transformed = Transformed./Transformed(3,:);
        Transformed = round(Transformed(1:2,:)');
        if ~(max(Transformed) > size(image1,1)) && min(Transformed) > 0
            img(j+1025,i+1025,:) = image1_rgb(Transformed(1,1), Transformed(1,2),:);
        end
    end
end
imshow(uint8(img))
