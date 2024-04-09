function [data, wavelength] = trans_data_all(Fir)

fid = fopen(Fir,'rb');
[data,data_size] = fread(fid,inf,'int16');
channel = 128; 

sinogram_R = zeros(4096,channel);

index=128;
for i=1:4096
    for j=2:2:channel   
          sinogram_R(i,j-1) = data(index+1);
          sinogram_R(i,j) = data(index+2);
          index=index+2;
    end
end
wavelength = data(5);
data = sinogram_R;
fclose(fid);
end
