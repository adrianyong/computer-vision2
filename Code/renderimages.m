function renderimages(i, n)

interval = 255/n;

min = 0;

%while((min+interval) < 256)
%    figure;
%    imshow(i, [min, min+interval]);
%    min = min + interval;
%end

iq = uint8(floor((double(i)/255)*n));

imagesc(iq);

end