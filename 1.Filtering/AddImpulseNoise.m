function output = AddImpulseNoise(image, threshold)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    image = double(image);
    [row, col]= size(image);
    output = image;
    
    i_noise = rand([row,col]);
    for i = 1 : col
        for j = 1 : row
            if i_noise(j,i) > threshold
                output(j,i) = 255;
            elseif i_noise(j,i) < 1-threshold
                output(j,i) = 0;
            end
        end
    end
    output = uint8(output);
end