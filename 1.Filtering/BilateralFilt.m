function output = BilateralFilt(image, sigma_s, sigma_r, filtSize)
    image = double(image);
    [row, col]= size(image);
    output = zeros(row, col);
    rad = floor(filtSize/2);
    
    %% make kernel
    [a, b] = meshgrid(-rad:rad, -rad:rad);
    kernel = (1/(2*pi*(sigma_s.^2)))*exp(-1 * (a.^2 + b.^2)./ (2*sigma_s*sigma_s) );
    kernel = kernel / sum(kernel(:));
  
    %% bilateral filtering
    for i = 1 + rad : col - rad
        for j = 1 + rad : row - rad
            region = image(j-rad:j+rad, i-rad:i+rad) - image(j, i);
            t = exp(-(region .* region) ./ (2 * sigma_r * sigma_r));
            bilat = t .* kernel;
            bilat = bilat / sum(bilat(:));
            temp = image(j-rad:j+rad, i-rad:i+rad) .*bilat;
            output(j, i) = sum(temp(:));
        end
    end
    output = uint8(output);
end