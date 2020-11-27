clc; clear; close all;
threshold = 0.3
image1_rgb = imread('cat2.jpg');
image1 = rgb2gray(image1_rgb);
image1 = rot90(image1,3);
image1_rgb = rot90(image1_rgb,3);
image2_rgb = imread('cat1.jpg');
image2 = rgb2gray(image2_rgb);
now_best = 0;

p1 = detectSURFFeatures(image1);
p2 = detectSURFFeatures(image2);
[feature1, pnt1] = extractFeatures(image1, p1);
[feature2, pnt2] = extractFeatures(image2, p2);

%% feature 이용해 최근접점 찾기
p1L = pnt1.Location;
p2L = pnt2.Location;
[least_dots,info] = dsearchn(feature1, feature2);      %최근접점 index
least_dots = least_dots.* (info < threshold);               %임계치 이상으로 가까운 애들만
least_dots1 = least_dots(find(least_dots));            %1번에 대한 인덱스
least_dots2 = find(least_dots);                        %2번에 대한 인덱스
imgSum = [image1_rgb image2_rgb;];
loc2_512(:,1) = p2L(:,1)+size(image1,1);
loc2_512(:,2) = p2L(:,2);         %이미지 이어 붙이기 완료
p1_near = p1L(least_dots1,:);
p2_near = loc2_512(least_dots2,:);          %이어 붙인 이후의 point들

imshow(imgSum); hold on;
scatter(p1L(:,1), p1L(:,2), 'b*');
scatter(loc2_512(:,1), loc2_512(:,2), 'c*');              %특징점 scatter로 나타내기
nearist_x = [p1L(least_dots1,1), loc2_512(least_dots2,1)]; % plot을 위한 x좌표 모음
nearist_y = [p1L(least_dots1,2), loc2_512(least_dots2,2)]; % y좌표 모음

for i = 1 : size(least_dots2,1)
    % 매칭 lines 플롯
    plot(nearist_x(i,:), nearist_y(i,:), 'g');
end

%% RANSAC Start
for k = 1 : 200
    rand_index = randi(size(p1_near,1),[4,1]);
    p1L_sampl = p1_near(rand_index,:);
    p2L_sampl = p2_near(rand_index,:);
    %% LMSe Start
    A = [];
    for i=1:size(p1L_sampl,1)
        A_row_x = [p1L_sampl(i,1) p1L_sampl(i,2) 1 0 0 0 -p2L_sampl(i,1)*p1L_sampl(i,1) -p2L_sampl(i,1)*p1L_sampl(i,2)];
        A_row_y = [0 0 0 p1L_sampl(i,1) p1L_sampl(i,2) 1 -p2L_sampl(i,2)*p1L_sampl(i,1) -p2L_sampl(i,2)*p1L_sampl(i,2)];
        A = [A;A_row_x;A_row_y];
    end
    B = reshape(p2L_sampl',2*size(p2L_sampl,1),[]);
    Te = inv(A'*A)*A'*B;
    T = reshape([Te;1],3,3)';   %변환행렬 T 도출완료 %3개의 샘플 데이터로 T를 만듬. 이제 inliner를 detect
    
    % 주어진 T를 가지고 점변환 시도
    A2 = [p1_near ones(size(p1_near,1),1)];
    Transformed = T * A2';
    Transformed = Transformed./Transformed(3,:);
    Transformed = Transformed(1:2,:)';
    
    % inliner 검출
    dis = sum((p2_near - Transformed).^2,2);
    inliers_this = find(dis< 9);          %거리가 가까운 성분(inliner)만 추출
    inlier_num = size(dis(inliers_this),1); %inliner갯수
    if inlier_num>now_best %inliner의 수가 가장 많은 T구함
        now_best = inlier_num;
        inliers = inliers_this;
        bestDis = dis;
        %% 인라이너 토대로 다시 T도출 = RANSAC
        A = []; B = [];
        p1L_in = p1_near(inliers_this,:);
        p2L_in = p2_near(inliers_this,:);
        for i=1:size(inliers_this,1)
            A_row_x = [p1L_in(i,1) p1L_in(i,2) 1 0 0 0 -p2L_in(i,1)*p1L_in(i,1) -p2L_in(i,1)*p1L_in(i,2)];
            A_row_y = [0 0 0 p1L_in(i,1) p1L_in(i,2) 1 -p2L_in(i,2)*p1L_in(i,1) -p2L_in(i,2)*p1L_in(i,2)];
            A = [A;A_row_x;A_row_y];
        end
        B = reshape(p2L_in',2*size(p2L_in,1),[]);
        Te = inv(A'*A)*A'*B;
        BestT = reshape([Te;1],3,3)';   %변환행렬 T 도출완료 %3개의 샘플 데이터로 T를 만듬. 이제 inliner를 detect
    end
end

%% T 가지고 점변환
figure; subplot(121)
imshow(image2_rgb); hold on;
A2 = [p1_near ones(size(p1_near,1),1)];
Transformed = BestT * A2';
Transformed = Transformed./Transformed(3,:);
Transformed = Transformed(1:2,:)';
for i = 1 : size(p1_near, 1)
    scatter(Transformed(i,1), Transformed(i,2), 'c*');     % 점변환 표현
end

%% T를 가지고 이미지변환
clear A2 Tranformed
subplot(122)
img = zeros(2048,2048,3);
for i = -1024 : 1024
    for j = -1024 : 1024
        Atemp = [j i];
        A2 = [Atemp ones(size(Atemp,1),1)];
        Transformed = BestT * A2';
        Transformed = Transformed./Transformed(3,:);
        Transformed = round(Transformed(1:2,:)');
        if ~(max(Transformed) > size(image1,1)) && min(Transformed) > 0
            img(j+1025,i+1025,:) = image1_rgb(Transformed(1,1), Transformed(1,2),:);
        end
    end
end
imshow(uint8(img))