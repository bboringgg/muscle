function [sinogram_data,pd_data]=import_sinogram_pd(filepath_sinogram,n_w)

dir_PA = uigetdir(filepath_sinogram);
str=strcat('*','.dat','*');
dir_list=dir(fullfile(dir_PA,str));
L=length(dir_list);

n=L/n_w;
pd_data=zeros(floor(n),n_w);
for i=1:n
   for j=1:n_w
      file_path=strcat(dir_PA,'/',dir_list(n_w*(i-1)+j).name);
      sinogram_data(:,:,i,j) = trans_data_all(file_path);
      ener=[];
      for k=4093:1:4096
        ener=[ener;squeeze(sinogram_data(k,:,i,j))];
        pd_data(i,j)=max(ener(1:100));
      end
     
   end
end

end