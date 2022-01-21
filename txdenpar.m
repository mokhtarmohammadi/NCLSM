function  denoised=txdenpar(Y,blcksize ,searchSize,overlap,lam1,lam2,iter, delta,is2d,threshold1,threshold2)
Y=fft(Y);
Y1=real(Y);
Y2=imag(Y);
Est1=Y1;
for i = 1:iter
    Est1 = Est1 + delta * (Y1 - Est1);
    Est1 = lowRank3D(Est1,blcksize,overlap,threshold1,searchSize,is2d,lam1);
end
Est2=Y2;
for i = 1:5
    Est2 = Est2 + delta * (Y2 - Est2);
    Est2 = lowRank3D(Est2,blcksize,overlap,threshold2,searchSize,is2d,lam2);
end
denoised=real(ifft(complex(Est1,Est2)));
end
