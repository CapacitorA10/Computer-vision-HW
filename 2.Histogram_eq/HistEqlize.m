function output = HistEqlize(histo, image)
    [row, col] = size(image);
    c = cumsum(histo)*255;
    output = uint8(zeros(row,col));
    for i = 1 : col
        for j = 1 : row
            output(j,i) = c(image(j,i)+1);
        end
    end
end