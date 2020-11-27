function [x,y] = hog(image, cell, plotOn)
if size(image, 3) == 3
    image = rgb2gray(image);
end
image = double(image);
[row, col]= size(image);

radb = floor(cell/2);

%% gradients by sobel mask
horisontal = [-1, 0,1 ; -2, 0, 2; -1, 0 ,1];
vertical = [-1 -2 -1 ;0 0 0; 1 2 1];


% for i = 1 + 1 : col - 1
%     for j = 1 + 1 : row - 1
%         tempx = image(j-1:j+1, i-1:i+1) .* horisontal;
%         tempy = image(j-1:j+1, i-1:i+1) .* vertical;
%         dx(j, i) = sum(tempx(:));
%         dy(j, i) = sum(tempy(:));
%     end
% end

dx = conv2(image, horisontal, 'same'); %컨볼루션 너무 느려서 잠시 사용(임시)
dy = conv2(image, vertical, 'same');  
g = (dx.^2 + dy.^2).^0.5;
theta = atand(dy ./ dx);
theta(isnan(theta)) = 0;
theta = theta + 90;

%% 셀 단위로 벡터 계산 후 투영까지
if plotOn
    imshow(uint8(image)); hold on;
end
for i = 1 + radb : cell : col - radb +1
    for j = 1 + radb : cell : row - radb +1
        
        hist(1:9) = 0;
        for o = i - radb : i + radb -1
            for p = j - radb : j + radb -1
                if theta(p,o) >= 0 && theta(p,o) < 20
                    hist(1) = hist(1) + g(p,o);
                    
                elseif theta(p,o) >= 20 && theta(p,o) < 40
                    hist(2) = hist(2) + g(p,o);
                    
                elseif theta(p,o) >= 40 && theta(p,o) < 60
                    hist(3) = hist(3) + g(p,o);
                    
                elseif theta(p,o) >= 60 && theta(p,o) < 80
                    hist(4) = hist(4) + g(p,o);
                    
                elseif theta(p,o) >= 80 && theta(p,o) < 100
                    hist(5) = hist(5) + g(p,o);
                    
                elseif theta(p,o) >= 100 && theta(p,o) < 120
                    hist(6) = hist(6) + g(p,o);
                 
                elseif theta(p,o) >= 120 && theta(p,o) < 140
                    hist(7) = hist(7) + g(p,o);
                
                elseif theta(p,o) >= 140 && theta(p,o) < 160
                    hist(8) = hist(8) + g(p,o);
                    
                elseif theta(p,o) >= 160 && theta(p,o) <= 180
                    hist(9) = hist(9) + g(p,o);
                end
            end
        end
        
        hist = (hist * (cell*0.6)) / sum(sum(hist));                                  % 히스토그램 내의 벡터크기 적절한 크기로 조정
                
        hist1x = hist(9)*cosd(10);
        hist1y = hist(9)*sind(10);
        x(1,:) = [i- hist1x, i+ hist1x];                                        % hist9 : 170도를 10도 방향으로 그림
        y(1,:) = [j+ hist1y , j- hist1y];
        
        
        hist2x = hist(8)*cosd(30);                                          % hist8 : 150도를 30도 방향으로 그림
        hist2y = hist(8)*sind(30);
        x(2,:) = [i - hist2x, i + hist2x];
        y(2,:) = [j + hist2y, j - hist2y];
        
        
        hist3x = hist(7)*cosd(50);                                          % hist7 : 130도를 50도 방향으로 그림
        hist3y = hist(7)*sind(50);
        x(3,:) = [i - hist3x, i + hist3x];
        y(3,:) = [j + hist3y, j - hist3y];
        
        
        hist4x = hist(6)*cosd(70);
        hist4y = hist(6)*sind(70);
        x(4,:) = [i - hist4x, i + hist4x];
        y(4,:) = [j + hist4y, j - hist4y];

        
        hist5x = hist(5)*cosd(90);
        hist5y = hist(5)*sind(90);
        x(5,:) = [i - hist5x, i + hist5x];
        y(5,:) = [j + hist5y, j - hist5y];

            
        hist6x = hist(4)*cosd(110);
        hist6y = hist(4)*sind(110);
        x(6,:) = [i - hist6x, i + hist6x];
        y(6,:) = [j + hist6y, j - hist6y];

        
        hist7x = hist(3)*cosd(130);
        hist7y = hist(3)*sind(130);
        x(7,:) = [i - hist7x, i + hist7x];
        y(7,:) = [j + hist7y, j - hist7y];

        
        hist8x = hist(2)*cosd(150);
        hist8y = hist(2)*sind(150);
        x(8,:) = [i - hist8x, i + hist8x];
        y(8,:) = [j + hist8y, j - hist8y];

        
        hist9x = hist(1)*cosd(170);
        hist9y = hist(1)*sind(170);
        x(9,:) = [i - hist9x, i + hist9x];
        y(9,:) = [j + hist9y, j - hist9y];
        if plotOn
            plot(x(1,:),y(1,:), 'red', 'LineWidth',2);
            plot(x(2,:),y(2,:), 'red', 'LineWidth',2);
            plot(x(3,:),y(3,:),'red', 'LineWidth',2);
            plot(x(4,:),y(4,:),'red', 'LineWidth',2);
            plot(x(5,:),y(5,:),'red', 'LineWidth',2);
            plot(x(6,:),y(6,:),'red', 'LineWidth',2);
            plot(x(7,:),y(7,:),'red', 'LineWidth',2);
            plot(x(8,:),y(8,:),'red', 'LineWidth',2);
            plot(x(9,:),y(9,:),'red', 'LineWidth',2);
        end
        
    end
end
end

