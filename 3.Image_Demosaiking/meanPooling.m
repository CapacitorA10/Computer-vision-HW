function output = meanPooling(image)
    
   [row,col] = size(image);
   output = zeros([row/2, col/2]);
   image = double(image);
   k = 1;
    for j = 1 : 2 : row-1
        l = 1;
        for i = 1 : 2 : col-1
            temp = image(j,i) + image(j+1,i) + image(j,i+1) + image(j+1,i+1);
            output(k,l) = temp/4;
            l = l + 1;
        end
        k = k + 1;
    end
end
