function output = my_psnr(image1, image2)
    image1 = double(image1);
    image2 = double(image2);
    MAX = 255;
    [row, col]= size(image1);
    MSE = sum(sum((image1 - image2).^2)) / (row * col);
    
    output = (20 * log10(MAX)) - (10 * log10(MSE));
    output = mean(output);
end
