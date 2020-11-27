clc; clear; close all;
facedir = dir('Faces/**/*.pgm');
j = 0;
for i = 1 : 10 : 400
    faceFolder = dir(facedir(i).folder);  % �� ����ִ� ���丮 ã��
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
person_vct = reshape(person,[],10,j);     %���� ��� 1��������

train_vct = person_vct(:,1:8,:);
test_vct = person_vct(:,9:10,:);        %train������, test ������ �з�
mean_people = sum(train_vct,2:3)/(8*size(train_vct,3));   %����� �����

nomalized_tr = squeeze(mean(train_vct,2) - mean_people); %�� ����� ǥ���� ��ճ� �� �븻������
nomalized_te = test_vct - mean_people;
covar = cov(nomalized_tr');
[Evct, Eval] = eig(covar);
% �������� ���� ��

%% eigen face ���ϱ�
U = Evct(:, end - 20 : end);      % �л� ���� n��
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

%% �߷� �� �߸��� ���� ���
U = Evct(:, end-40+1 : end)';      % �л� ���� 100���� �������� ����
PCAdata = (U * nomalized_tr)';     % �������Ϳ� �� ������� PCA����
for j = 1 : 40
        test_person = nomalized_te(:,1,j);
        output = (U * test_person)';
        for i = 1 : 40
            distance(i)=norm(PCAdata(i,:) - output);   % pca������ �翵 �����Ϳ� �׽�Ʈ �翵 �����Ϳ��� ��Ŭ���� �Ÿ� ���
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
fprintf("Top 3 data: %d %d %d ���Դϴ�. \n Distance: %.2f %.2f %.2f \n", data(1:3), sorted(1:3)/10)


%% ���� �� ��� �����ϱ�
clear distance;
for k = 1 : 100
    U = Evct(:, end-k+1 : end)';      % �л� ���� 100���� �������� ����
    PCAdata = (U * nomalized_tr)';     % �������Ϳ� �� ������� PCA����
    accu = 0;
    for j = 1 : 40
        for l = 1 : 2
            test_person = nomalized_te(:,l,j);
            output = (U*test_person)';
            for i = 1 : 40
                distance(i) = norm(PCAdata(i,:) - output);   % pca������ �翵 �����Ϳ� �׽�Ʈ �翵 �����Ϳ��� ��Ŭ���� �Ÿ� ���
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


