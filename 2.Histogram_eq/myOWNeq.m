function output = myOWNeq(histo, image, gamma)
    [row, col] = size(image);
    c = cumsum(histo)*255;
    c = c.^gamma;
    maxc = max(c);
    ratio =  255/maxc;
    c = c.*ratio;
    output = uint8(zeros(row,col));
    for i = 1 : col
        for j = 1 : row
            output(j,i) = c(image(j,i)+1);
        end
    end
end