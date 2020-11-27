function bayer_pattern = RGBtoBayer(image)
    imageR = image(:,:,1);
    imageG = image(:,:,2);
    imageB = image(:,:,3);
    subsmp_imageR = meanPooling(imageR);
    subsmp_imageG = meanPooling(imageG);
    subsmp_imageB = meanPooling(imageB);
    bayer_pattern = zeros(size(image,[1,2]));
    [row,col] = size(bayer_pattern);
    
    % RED 성분 대입
    k = 1;
    for j = 1 : 2 : row
        l = 1;
        for i = 1 : 2 : col
            bayer_pattern(j,i) = subsmp_imageR(k,l);
            l = l + 1;
        end
        k = k + 1;
    end

    % BLUE 성분 대입
    k = 1;
    for j = 2 : 2 : row
        l = 1;
        for i = 2 : 2 : col
            bayer_pattern(j,i) = subsmp_imageB(k,l);
            l = l + 1;
        end
        k = k + 1;
    end

    % GREEN 성분 대입
    k = 1;
    for j = 1 : 2 : row
        l = 1;
        for i = 2 : 2 : col
            bayer_pattern(j,i) = subsmp_imageG(k,l);
            l = l + 1;
        end
        k = k + 1;
    end
    
    k = 1;
    for j = 2 : 2 : row
        l = 1;
        for i = 1 : 2 : col
            bayer_pattern(j,i) = subsmp_imageG(k,l);
            l = l + 1;
        end
        k = k + 1;
    end
end

