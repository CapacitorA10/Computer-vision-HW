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

%% feature �̿��� �ֱ����� ã��
p1L = pnt1.Location;
p2L = pnt2.Location;
[least_dots,info] = dsearchn(feature1, feature2);      %�ֱ����� index
least_dots = least_dots.* (info < threshold);               %�Ӱ�ġ �̻����� ����� �ֵ鸸
least_dots1 = least_dots(find(least_dots));            %1���� ���� �ε���
least_dots2 = find(least_dots);                        %2���� ���� �ε���
imgSum = [image1_rgb image2_rgb;];
loc2_512(:,1) = p2L(:,1)+size(image1,1);
loc2_512(:,2) = p2L(:,2);         %�̹��� �̾� ���̱� �Ϸ�
p1_near = p1L(least_dots1,:);
p2_near = loc2_512(least_dots2,:);          %�̾� ���� ������ point��

imshow(imgSum); hold on;
scatter(p1L(:,1), p1L(:,2), 'b*');
scatter(loc2_512(:,1), loc2_512(:,2), 'c*');              %Ư¡�� scatter�� ��Ÿ����
nearist_x = [p1L(least_dots1,1), loc2_512(least_dots2,1)]; % plot�� ���� x��ǥ ����
nearist_y = [p1L(least_dots1,2), loc2_512(least_dots2,2)]; % y��ǥ ����

for i = 1 : size(least_dots2,1)
    % ��Ī lines �÷�
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
    T = reshape([Te;1],3,3)';   %��ȯ��� T ����Ϸ� %3���� ���� �����ͷ� T�� ����. ���� inliner�� detect
    
    % �־��� T�� ������ ����ȯ �õ�
    A2 = [p1_near ones(size(p1_near,1),1)];
    Transformed = T * A2';
    Transformed = Transformed./Transformed(3,:);
    Transformed = Transformed(1:2,:)';
    
    % inliner ����
    dis = sum((p2_near - Transformed).^2,2);
    inliers_this = find(dis< 9);          %�Ÿ��� ����� ����(inliner)�� ����
    inlier_num = size(dis(inliers_this),1); %inliner����
    if inlier_num>now_best %inliner�� ���� ���� ���� T����
        now_best = inlier_num;
        inliers = inliers_this;
        bestDis = dis;
        %% �ζ��̳� ���� �ٽ� T���� = RANSAC
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
        BestT = reshape([Te;1],3,3)';   %��ȯ��� T ����Ϸ� %3���� ���� �����ͷ� T�� ����. ���� inliner�� detect
    end
end

%% T ������ ����ȯ
figure; subplot(121)
imshow(image2_rgb); hold on;
A2 = [p1_near ones(size(p1_near,1),1)];
Transformed = BestT * A2';
Transformed = Transformed./Transformed(3,:);
Transformed = Transformed(1:2,:)';
for i = 1 : size(p1_near, 1)
    scatter(Transformed(i,1), Transformed(i,2), 'c*');     % ����ȯ ǥ��
end

%% T�� ������ �̹�����ȯ
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