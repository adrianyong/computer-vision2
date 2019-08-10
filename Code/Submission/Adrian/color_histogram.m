function [chist] = color_histogram(img)

%img = rgb2hsv(img);
img = double(img);
imquant = img/255;
imquant = round(imquant*(4-1))+1;

chist = zeros(4, 4, 4);

[height,width,color] = size(imquant);

   for i = 1:height
       for j = 1:width
           rpixel = imquant(i,j,1);
           gpixel = imquant(i,j,2);
           bpixel = imquant(i,j,3);
           
          % total = total + rpixel + gpixel + bpixel;
           
           chist(rpixel,gpixel,bpixel) = chist(rpixel,gpixel,bpixel) + 1;
       end 
   end

   chist = reshape(chist,1,64);
   
   
end