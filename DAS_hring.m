function result_matrix =DAS_hring(Sinogram,delay,vs,NX,NY)

Is_Half=1;
fs = 40e6;                            % sampling frequency 
pa_dataD=Sinogram;
[Nsample, Nstep] = size(pa_dataD);   % Nstep : number of steps, Nsample : number of samples per step   

R = 0.055;	

%------image reconstruction parameters --------
V_M =vs; %acoustic velocity in background medium
angle_step1 = -3.14159265359/2;             % the angle of the first step (in degree)
% image size
pixel_size=1e-4;

x_size = NX*pixel_size;                    
y_size = NY*pixel_size;   

resolution_factor =1e-3/pixel_size;          
% dx=dy=1.0 mm/resolution_factor
center_x = 0;
center_y = 0;

fixedDelay = delay;

delay_idx = ones(1,Nstep)*fixedDelay/fs;
angle_per_step = 2*pi/(Nstep*2);   % angle per step3

%parameters of image

Npixel_x = round(x_size*resolution_factor*1e3);
Npixel_y = round(y_size*resolution_factor*1e3);

x_range = ((1:Npixel_x)-(Npixel_x)/2)*x_size/(Npixel_x)+center_x;  % x axis
y_range = ((Npixel_y:-1:1)-(Npixel_y)/2)*y_size/(Npixel_y)+center_y;    % y axis
x_img = ones(Npixel_y,1)*x_range;
y_img = y_range.'*ones(1,Npixel_x);

% receiver position
detector_angle = (0:Nstep-1)*angle_per_step;
x_receive = cos(detector_angle)*R;  %探测器的空间位置
y_receive = sin(detector_angle)*R;

tic;
pa_img = zeros(Npixel_y, Npixel_x); % image buffer

total_angle_weight = 0.0; %total acquisition angle
for iStep = 1:Nstep
    iStep
    pa_data_tmp = pa_dataD(:,iStep);

    %% delay and sum: use the direct pa signal    
    r0=sqrt(x_receive(iStep)^2+y_receive(iStep)^2);
    dx=x_img-x_receive(iStep);
    dy=y_img-y_receive(iStep);
    rr0=sqrt(dx.^2+dy.^2); % distance to the detector   
    angle_weight=abs((x_receive(iStep)*dx+y_receive(iStep)*dy)/r0./rr0)./rr0.^2;%向量叉乘
    total_angle_weight = total_angle_weight + angle_weight;

    idx=rr0/V_M -delay_idx(iStep);%时间
    idx = round(idx*fs);
    idx(idx > size(pa_dataD,1)) = size(pa_dataD,1);
    idx(idx < 1) = 1;
    if(~Is_Half)
        %pa_img = pa_img + pa_data_tmp(idx).*angle_weight;  
         pa_img = pa_img + pa_data_tmp(idx); 
    else
        %pa_img = pa_img + pa_data_tmp(idx).*(rr0<=(1.05*R)).*angle_weight; 
        pa_img = pa_img + pa_data_tmp(idx).*(rr0<=(1.05*R)); 
    end  

end
%figure,imagesc(pa_img),colormap gray,colorbar;

result_matrix = pa_img;
end
