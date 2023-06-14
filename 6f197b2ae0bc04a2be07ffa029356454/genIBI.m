
%数据间隔5ms
rri_max = 220;%220 * 5 = 1100ms
rri_min = 100;%100 * 5 = 500ms
Filename = 'dataOutputFromEVM.bin';  %文件名 用户需要按照自己的文件名修改
fid = fopen(Filename,'r');
H = fread(fid, 'int16');
len = length(H);
H = interp1(1:10:(10 * len), H, 1:(10 * len), 'spline');
x = [];
for i = 2:length(H)
    if ((H(i) >= 0) && (H(i - 1) < 0))
        x = [x i];
    end
end
t = [];
i = 1;
while (i < length(x))
    diffx = x(i + 1) - x(i);
    if (diffx > rri_max)
        i = i + 1;
        continue;
    end
    if (diffx >= rri_min)
        t = [t diffx];
        i = i + 1;
    else
        if (i + 2 <= length(x))
            diffx = x(i + 2) - x(i);
            if (diffx <= rri_max)
                t = [t diffx];
                i = i + 2;
            else
                i = i + 1;
            end
        end
    end
end
t = 0.005 * t;
fid = fopen('E:\yandiansai\breathheart\SampleData5.ibi', 'w');
fprintf(fid, '%f\n', t');
fclose(fid);

