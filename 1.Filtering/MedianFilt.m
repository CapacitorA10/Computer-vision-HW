function output = MedianFilt(image, filtSize)
    image = double(image);
    [row, col]= size(image);
    output = zeros(row, col);
    rad = floor(filtSize/2);
    
    %% filtering
    for i = 1 + rad : col - rad
        for j = 1 + rad : row - rad
            median = image(j-rad:j+rad, i-rad:i+rad);
            median = reshape(median, 1, filtSize^2);
            %bubble sort
            for k = length(median) : -1 : 2
                for n = 1 : k - 1
                    while median(n) > median(n+1)
                        median([n, n+1]) = median([n+1, n]);
                    end
                end
            end
            % 중간값 대입
            output(j,i) = median(5);
        end
    end
    output = uint8(output);
end

    
    