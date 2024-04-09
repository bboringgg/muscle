function [SmO2,Hb,HbO2] = LinearUnmixing(PA, mask, spectra_HbO2, spectra_Hb,correct,spec_range)
        
         A = [spectra_Hb(1:spec_range),spectra_HbO2(1:spec_range)];
         index = find(mask~=0);
         PA_2D = reshape(PA,[size(PA,1)*size(PA,2),size(PA,3)]);
         PA_spectrum = PA_2D(index,1:21)';%+negative(1:13)';
         
         Hb_HbO2 = inv(A'*A)*A'*(PA_spectrum./correct(1:21)');
         
         SO2_2D = Hb_HbO2(2,:)./(sum(Hb_HbO2,1));
         SmO2 = zeros(size(PA,1), size(PA,2));
         SmO2(index) = SO2_2D;
         %imagesc(SO2);
         Hb=zeros(size(PA,1), size(PA,2));
         Hb(index)=Hb_HbO2(1,:);
         %imagesc(Hb);
         HbO2=zeros(size(PA,1), size(PA,2));
         HbO2(index)=Hb_HbO2(2,:);
%          imagesc(HbO2);
%          imagesc(SO2);
     
          
end