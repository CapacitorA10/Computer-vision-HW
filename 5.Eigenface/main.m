clc; clear; close all;
facedir = dir('Faces/**/*.pgm');
j = 0;
for i = 1 : 10 : 400
    faceFolder = dir(facedir(i).folder);  % 얼굴 들어있는 디렉토리 찾기
    n = length(faceFolder);
    temp = 1;
    for k = 3 : n
        fileName = strcat(facedir(i).folder,'\',faceFolder(k).name);
        face(:,:,temp) = double(imread(fileName));
        temp = temp + 1;
    end
    j = j + 1;
    person(:,:,:,j) = face;
end
person_vct = reshape(person,[],10,j);     %얼굴을 모두 1차원으로

train_vct = person_vct(:,1:8,:);
test_vct = person_vct(:,9:10,:);        %train데이터, test 데이터 분류
mean_people = sum(train_vct,2:3)/(8*size(train_vct,3));   %모든사람 얼굴평균

nomalized_tr = squeeze(mean(train_vct,2) - mean_people); %각 사람별 표정을 평균낸 후 노말라이즈
nomalized_te = test_vct - mean_people;
covar = cov(nomalized_tr');
[Evct, Eval] = eig(covar);
% 고유벡터 추출 끝

%% eigen face 구하기
U = Evct(:, end - 20 : end);      % 분산 상위 n개
sample = person_vct(:,9,8);
yt = U' * sample;
invU = pinv(U);
xt = invU' * yt;
x = reshape(xt, 112,92);
figure;
subplot(121)
imshow(reshape(sample, 112,92)/255)
subplot(122)
imshow(x/255);

%% 추론 및 잘못된 정답 출력
U = Evct(:, end-40+1 : end)';      % 분산 상위 100개의 고유벡터 추출
PCAdata = (U * nomalized_tr)';     % 고유벡터에 각 사람별로 PCA시행
for j = 1 : 40
        test_person = nomalized_te(:,1,j);
        output = (U * test_person)';
        for i = 1 : 40
            distance(i)=norm(PCAdata(i,:) - output);   % pca시행한 사영 데이터에 테스트 사영 데이터와의 유클리드 거리 계산
        end
        [q, n] = find(distance == min(distance));
        if ~(n == j)
            figure(j)
            subplot(121);
            err = reshape(test_vct(:,1,j), 112,92);
            imshow(err/255);
            
            subplot(122);
            yt = U * test_vct(:,1,j);
            invU = pinv(U);
            xt = invU * yt;
            x = reshape(xt, 112,92);
            imshow(x/255);
        end
end

[sorted, data] = sort(distance);
fprintf("Top 3 data: %d %d %d 순입니다. \n Distance: %.2f %.2f %.2f \n", data(1:3), sorted(1:3)/10)


%% 벡터 수 대로 예측하기
clear distance;
for k = 1 : 100
    U = Evct(:, end-k+1 : end)';      % 분산 상위 100개의 고유벡터 추출
    PCAdata = (U * nomalized_tr)';     % 고유벡터에 각 사람별로 PCA시행
    accu = 0;
    for j = 1 : 40
        for l = 1 : 2
            test_person = nomalized_te(:,l,j);
            output = (U*test_person)';
            for i = 1 : 40
                distance(i) = norm(PCAdata(i,:) - output);   % pca시행한 사영 데이터에 테스트 사영 데이터와의 유클리드 거리 계산
            end
            [q, n] = find(distance == min(distance));
            if n == j
                accu = accu + 1;
            end
        end
    end
    accuracy(k) = accu * 1.25;
end
figure;
plot(accuracy);
axis([0, k, 0, 100]);
xlabel('Num of Eigen Vectors'); ylabel('accu')


