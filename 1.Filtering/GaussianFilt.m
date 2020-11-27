function output = GaussianFilt(image, sigma, filtSize)
    image = double(image);
    [row, col]= size(image);
    output = zeros(row, col);
    rad = floor(filtSize/2);
    
    %% gaussian kernel
    [a, b] = meshgrid(-rad:rad, -rad:rad);
    kernel = (1/(2*pi*(sigma.^2)))*exp(-1 * (a.^2 + b.^2)./ (2*sigma*sigma) );
    kernel = kernel / sum(kernel(:));
    
    %% convolution
    for i = 1 + rad : col - rad
        for j = 1 + rad : row - rad
            temp = image(j-rad:j+rad, i-rad:i+rad) .* kernel;
            output(j, i) = sum(temp(:));
        end
    end
    output = uint8(output);
end
