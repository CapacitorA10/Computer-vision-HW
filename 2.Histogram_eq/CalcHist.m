function histo = CalcHist(image)
    image = uint8(image);
    [row, col] = size(image);
    histo = zeros(1,256);
    for i = 1 : col
        for j = 1 : row
            k = image(j,i)+1;
            histo(k) = histo(k) + 1;
        end
    end
    histo = histo / (row*col);
end
