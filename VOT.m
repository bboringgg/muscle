function [trend_700,trend_760,trend_800,trend_820,trend_850]=VOT(filepath1,filepath2)

  %% load data
  load (filepath1)
  [~,~,L1,~]=size(Image);
  for k=1:L1
      I_700(:,:,k,:)=Image(:,:,k,2);
      I_760(:,:,k,:)=Image(:,:,k,2);
      I_800(:,:,k,:)=Image(:,:,k,2);
      I_820(:,:,k,:)=Image(:,:,k,2);
      I_850(:,:,k,:)=Image(:,:,k,2);
  end
  load (filepath2)
  [~,~,L2,~]=size(Image);
  for k=1:L2
    I_700(:,:,L1+k,:)=Image(:,:,k,2);
    I_760(:,:,L1+k,:)=Image(:,:,k,2);
    I_800(:,:,L1+k,:)=Image(:,:,k,2);
    I_820(:,:,L1+k,:)=Image(:,:,k,2);
    I_850(:,:,L1+k,:)=Image(:,:,k,2);
  end

  [~,~,X]=size(I_700);
  imagesc(I_700(:,:,100)),colormap(gray);
  p=getrect;
  p=round(p);

  for i=1:X
    A1=reshape(I_700(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
    A1_sort=sort(A1,'descend');
    trend_700(i) = mean(A1_sort(1:10));
    A2=reshape(I_760(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
    A2_sort=sort(A2,'descend');
    trend_760(i) = mean(A2_sort(1:10));
    A3=reshape(I_800(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
    A3_sort=sort(A3,'descend');
    trend_800(i) = mean(A3_sort(1:10));
    A4=reshape(I_820(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
    A4_sort=sort(A4,'descend');
    trend_820(i) = mean(A4_sort(1:10));
    A5=reshape(I_850(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
    A5_sort=sort(A5,'descend');
    trend_850(i) = mean(A5_sort(1:10));
  end

end