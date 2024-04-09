%% Summary of my code v1.0
% Author:EVE_SHI
% Date:2024.4.8

%% Import sinogram
filepath_sinogram='I:\实验数据\冠脉项目\0402\';  %upper folder,.dat start at 700nm
n_w=26;%choose the number of wavelength

[sinogram_data,pd_data]=import_sinogram_pd(filepath_sinogram,n_w);

%% Just test the vs
delay=-15; 
vs=1520;
NX=600;
NY=600;
Image_test= -DAS_linear_64(sinogram_data(:,1:64,10,10)',delay,vs,NX,NY);
imagesc(Image_test);

%% Reconstruction of mean PA image, use DAS method

Sinogram =  squeeze(mean(sinogram_data(:,:,4:end,:),3));
totalIterations = n_w;
NX=600;
NY=600;

type='linear64'; %'half_ring','linear128','linear64'
h = waitbar(0, '正在运行...');
switch type
    case 'half_ring'
        delay=-580; 
        vs=1520;
        for i=1:totalIterations
           Image(:,:,i) = -DAS_hring(Sinogram(:,:,i),delay,vs,NX,NY);
           waitbar(i/totalIterations, h);
        end
    case 'linear128'
        delay=-15; 
        vs=1520;
        for i=1:totalIterations
           Image(:,:,i) = -DAS_linear(Sinogram(:,:,i)',delay,vs,NX,NY);
           waitbar(i/totalIterations, h);
        end
    case 'linear64'
        delay=-15; 
        vs=1520;
        for i=1:totalIterations
           Image(:,:,i) = -DAS_linear_64(Sinogram(:,1:64,i)',delay,vs,NX,NY);
           waitbar(i/totalIterations, h);
        end
end 
imagesc(Image(:,:,10));        
 
% save('cuso4.mat','Image','pd_data');% you can save Image and pd_data

%% Deal with the PA spectra (Image 3d)
load I:\骨筋膜\代码\0402数据\ce1.mat
type_Image='3d';
num_pixel=50;
n_w=26;
inten=GetPA_spectra(Image,num_pixel,type_Image,n_w);%get the rect of ROI
plot(inten);%show PA spectra;3d->1d;4d->2d

%% Import basic data
filepath_02='I:\muscle oxygen saturation\肌氧.csv';
filepath_cuso4='I:\muscle oxygen saturation\cuso4andblack.xlsx';

[spectra_HbO2,spectra_Hb,spectra_cuso4] = spectra(filepath_02, filepath_cuso4);

SO2=0:0.1:1;
C_hb=1-SO2;
S=SO2.*spectra_Hb+C_hb.*spectra_HbO2;%different curve of different so2

%% Get the correct spectra
load I:\骨筋膜\代码\0402数据\cuso4.mat %cuso4 or artery,Image size is 3d
type_correct='cuso4';
num_pixel=50;
correct=Getcorrect_spec(Image,num_pixel,type_correct,S,spectra_cuso4);
plot(correct);

%correct=[96.7431522988677,115.606398631710,108.248747326216,93.3588434371335,95.8301697350175,93.4562526652717,79.0366302691972,82.4650512829919,74.8252732440178,74.4972539171575,76.3328762160615,71.6347841652018,72.6372220174538,76.4905447242438,74.6829121035291,78.8944444991907,79.5293560560636,82.2554157591283,80.8198782627122,62.2725539266937,81.4327709586037,87.3008287224818,83.4357903800153,90.7479129835121,90.0926195205992,97.7577952863455];
%cuso4 from 0402

%% calculate the SmO2
load I:\骨筋膜\代码\0402数据\ce1.mat
PA=squeeze(mean(Image(:,:,4:end,:),3));% if your Image size is 4d
%PA=Image;% if your Image size is 3d
[m,n,~]=size(Image);
mask=zeros(m,n);
Im=Image(:,:,10);
imagesc(Im),colormap(gray);
p=getrect;
p=round(p);
mask(p(2):p(2)+p(4),p(1):p(1)+p(3))=1;%choose ROI include muscle

spec_range=21;%wavelength from 700nm to 900nm

[SmO2,Hb,HbO2] = LinearUnmixing(PA, mask, spectra_HbO2, spectra_Hb,correct,spec_range);

% SmO2(SmO2>1)=1;
% SmO2(SmO2<0)=0;
% imagesc(SmO2);

SmO2_RGB(:,:,1)=HbO2;
SmO2_RGB(:,:,2)=Hb;
SmO2_RGB(:,:,3)=zeros(m,n);
imagesc(SmO2_RGB);

mean_value=mean(mean(SmO2(p(2):p(2)+p(4),p(1):p(1)+p(3))));
disp(mean_value);% mean SmO2 of ROI

%% Other function
%% VOT experiment,very slow,need to be optimized

filepath1='I:\骨筋膜\代码\0221数据\tu_10min_1.mat';
filepath2='I:\骨筋膜\代码\0221数据\tu_10min_2.mat';

load 'I:\骨筋膜\代码\0222数据\tu3_10min5_1.mat';
PA=mean(Image(:,:,40:80,:),3);
type_Image='3d';
num_pixel=10;
n_w=5;
inten=GetPA_spectra(PA,num_pixel,type_Image,n_w);%get the rect of ROI
plot(inten);%show PA spectra;3d->1d;4d->2d
correct_v=inten./spectra_HbO2([1,7,11,13,16])';

%correct_v=[700886.707021410,461280.553467005,343699.482884138,338847.780939499,194238.503803169];
%0222 artery

[trend_700,trend_760,trend_800,trend_820,trend_850]=VOT(filepath1,filepath2,correct_v);

plot(trend_700/correct_v(1));
hold on
plot(trend_760/correct_v(2));
hold on
plot(trend_820/correct_v(4));
legend('700nm','760nm','820nm');set(gcf, 'Color', [1 1 1]);

%% caculate the componet

A=[1 0.1616;0.8630 0.3266;0.3867 0.5105];% choose
Y=inv(A'*A)*A';
Hb_HbO2 = Y*[I_dong_700/correct_v(1);(I_dong_760/correct_v(2));(I_dong_820/correct_v(4))];
plot(Hb_HbO2(1,4:end));
hold on
plot(Hb_HbO2(2,4:end));set(gcf, 'Color', [1 1 1]);
legend('Hb','HbO2')

SO2=Hb_HbO2(2,:)./(Hb_HbO2(2,:)+Hb_HbO2(1,:));
SO2(SO2>1)=1;
SO2(SO2<0)=0;

plot(SO2(4:end));set(gcf, 'Color', [1 1 1]);

%% Try to get the correct spectra by two vessels

load 'I:\muscle oxygen saturation\test data\cai_ji_or.mat';
PA=squeeze(mean(Image(:,:,4:end,:),3));
type_Image='3d';
num_pixel=30;
n_w=21;
inten_vessel1=GetPA_spectra(PA,num_pixel,type_Image,n_w);%get the rect of ROI
plot(inten_vessel1);%show PA spectra;3d->1d;4d->2d

inten_vessel2=GetPA_spectra(PA,num_pixel,type_Image,n_w);%get the rect of ROI
plot(inten_vessel2);%show PA spectra;3d->1d;4d->2d

%% method of bisection and sgd

nums=0:0.01:1;
C_hb=1-nums;
pred_spectra=nums.*spectra_Hb(1:21)+C_hb.*spectra_HbO2(1:21);%different curve of different so2

correct=two_vessel_method(inten_vessel1,inten_vessel2,pred_spectra);
