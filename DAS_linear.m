function result_matrix =DAS_linear(Sinogram,delay,vs,NX,NY)
size_x=1e-4;%pixel size along the x axis
size_y=1e-4;%pixel size along the y axis
x_coor=((0:(NX-1))-(NX-1)/2).*size_x;
y_coor=((0:(NY-1))-(NY-1)/2).*size_y;
[X_coor,Y_coor]=meshgrid(x_coor,y_coor);
pixel_2D_coordinate=[X_coor(:).';Y_coor(:).'];
% clear x_coor y_coor X_coor Y_coor;

%detectors
pitch = 0.3*1e-3;
n_element = 128;
detector_coordinate = [(-2.2e-2*ones(1,n_element));(((0:(n_element-1))-(n_element-1)/2).*pitch)];   
f_num = 1/2;
fs=40e6;
fixedDelay = delay;

delay_idx = fixedDelay/fs;

% figure(1),plot(pixel_2D_coordinate(1,:),pixel_2D_coordinate(2,:),'.');hold on;plot(detector_coordinate(1,:),detector_coordinate(2,:),'r.');hold off;title('pixels and detectors');axis equal;

%ultrasound para
%ultrasound velocity
delta_t=1/(40*1e6);
%delta_t =frequency;%
%calculation
delay_timepoint=zeros(length(pixel_2D_coordinate),length(detector_coordinate));

for ii=1:length(detector_coordinate)
    temp=pixel_2D_coordinate-detector_coordinate(:,ii)*ones(1,length(pixel_2D_coordinate));
    temp=((sqrt(sum(temp.^2,1))/vs-delay_idx)/delta_t)+1;
    delay_timepoint(:,ii)=temp.';
end
pressure_detect = Sinogram;
result=zeros(NX*NY,1);
for jj=1:(NX*NY)
          aperture_size_half=floor((pixel_2D_coordinate(1,jj)-detector_coordinate(1,1))/(2*f_num)/pitch);
          if(aperture_size_half==0)
              aperture_size_half=1;
          end
          aperture_size = -aperture_size_half:1:aperture_size_half;%pixel_2D_coordinate 第一行是像素点纵坐标
          [~,cntr] = min(abs(pixel_2D_coordinate(2,jj)-detector_coordinate(2,:)));%pixel_2D_coordinate 第二行是像素点横坐标
          apr = cntr + aperture_size; % full aperture index
          apr=apr(apr>0);
          apr=apr(apr<=n_element);
          for ii = apr   
          time_point=delay_timepoint(jj,ii);   
          sub_sample = time_point-floor(time_point);
          if(floor(time_point)>0)
              result(jj)=result(jj)+(1-sub_sample)*pressure_detect(ii,floor(time_point))+sub_sample*pressure_detect(ii,(floor(time_point)+1));
          else
              result(jj)=result(jj)+sub_sample*pressure_detect(ii,(floor(time_point)+1));
          end  
      
          end
          
          result(jj)=result(jj)/length(apr);
end
clear temp;

result_matrix=zeros(NY,NX);
for ii=1:(NX*NY)
    tempcoor=pixel_2D_coordinate(:,ii);
    result_matrix(round((NY+1)-(tempcoor(2)/size_y+(NY-1)/2+1)),round(tempcoor(1)/size_x+(NX-1)/2+1))=result(ii);
end

result_matrix =result_matrix';
% for i = 1:NY
%    result_matrix(i,:) =  result_matrix(i,:) *exp(i/100);
% end
% % figure,imagesc(result_matrix),colormap gray;
%result_matrix1 = fliplr(result_matrix);
% % figure,imagesc(result_matrix1),colormap gray;xlabel('scanline');ylabel('depth(pixel)');title('DAS-original');colorbar;
% % figure,imagesc(abs(hilbert(result_matrix1(:,:)))),colormap gray;
%result_matrix = result_matrix1;
end
