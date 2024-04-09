function [spectra_HbO2,spectra_Hb,spectra_cuso4] = spectra(filepath_02, filepath_cuso4)

ab1=xlsread(filepath_02);
ab2=xlsread(filepath_cuso4);
% spectra_HbO2=absorption([16,11,6],2);
% spectra_Hb=absorption([16,11,6],1);
spectra_HbO2=ab1(1:26,8);
spectra_Hb=ab1(1:26,7);
% spectra_MbO2=ab1(1:26,9);
% spectra_Mb=ab1(1:26,10);
% spectra_black=ab2(1:26,4);
spectra_cuso4=ab2(:,3);

end