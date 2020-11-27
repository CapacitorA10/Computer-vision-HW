function RGB=yuv2rgb(YUV)
Y = YUV(:,:,1);
U = YUV(:,:,2);
V = YUV(:,:,3);

R = Y + (1.13983*V);
G = Y - (0.39465*U) - (0.5806*V);
B = Y + (2.03211*U);
RGB(:,:,1) = R;
RGB(:,:,2) = G;
RGB(:,:,3) = B;
end