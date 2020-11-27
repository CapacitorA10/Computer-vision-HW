function output = AddUniformNoise(image, sigma)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    [row, col]= size(image);
    
    u_noise = (rand([row,col]) - 0.5) * sigma;
    output = uint8(double(image) + u_noise);
end
