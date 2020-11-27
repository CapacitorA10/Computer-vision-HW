function output = AddGaussianNoise(image, sigma)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    image = double(image);
    [row, col]= size(image);

    g_noise = randn([row,col]) * sigma;
    output = uint8(double(image) + g_noise);
end
