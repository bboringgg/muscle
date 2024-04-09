function [inten]=GetPA_spectra(Image,num_pixel,type_Image,n_w)
switch type_Image
    case '3d'
      PA=Image;
      imagesc(PA(:,:,1)),colormap(gray);
      p=getrect;
      p=round(p);

       for i=1:n_w
          A=reshape(PA(p(2):p(2)+p(4),p(1):p(1)+p(3),i),[(p(4)+1)*(p(3)+1),1]);
          A_sort=sort(A,'descend');
          inten(i) = mean(A_sort(1:num_pixel));
       end
       
    case '4d'
       [~,~,L,~]=size(Image);
        PA=Image;%squeeze(mean(Image(:,:,4:end,:),3));
        p=getrect;
        p=round(p);
        for i=1:n_w
            for m=1:L
               inten(m,i) = mean(mean(PA(p(2):p(2)+p(4),p(1):p(1)+p(3),m,i)));
            end
        end
end