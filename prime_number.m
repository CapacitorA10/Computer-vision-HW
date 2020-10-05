% x보다 작은 소수를 출력(i)하는 프로그램


x = 100;

for i = 1 : x
    k = 0;
    for j = 1 : i
        if rem(i,j) == 0
            k = k + 1;
        end
    end
    if k == 2
        i
    end
end
