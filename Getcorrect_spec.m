function correct=Getcorrect_spec(Image,num_pixel,type_correct,S,spectra_cuso4)
 switch type_correct
    case 'cuso4'
      PA=Image;
      imagesc(PA(:,:,1)),colormap(gray);
      p=getrect;
      p=round(p);

       for i=1:26
          A=reshape(PA(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
          A_sort=sort(A,'descend');
          inten(i) = mean(A_sort(1:num_pixel));
       end
       correct=inten./spectra_cuso4';
       
     case 'artery'
        PA=Image;
        imagesc(PA(:,:,1)),colormap(gray);
        p=getrect;
        p=round(p);

        for i=1:26
          A=reshape(PA(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
          A_sort=sort(A,'descend');
          inten(i) = mean(A_sort(1:num_pixel));
        end
         correct=inten./S(:,1)';

end