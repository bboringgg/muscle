function correct=two_vessel_method(inten_vessel1,inten_vessel2,pred_spectra)
   for i=1:length(pred_spectra)
       pred_vessel1=pred_spectra(:,i);
       RMS1=sqrt((1/21)*sum((pred_vessel1-inten_vessel1).^2));
       correct=inten_vessel1./pred_vessel1';
       pred_vessel2=inten_vessel1./correct;
       RMS2=sqrt((1/21)*sum((pred_vessel2-inten_vessel2).^2));
       loss(i)=RMS1+RMS2;
       if loss(i)<loss(i-1)
           break
       end

end