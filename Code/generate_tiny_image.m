function [ tiny_im ] = generate_tiny_image(img)

img = double(img);
imquant = img/255;
imquant = round(imquant*(16-1))+1;

tiny_im = zeros(16,16,3);

[height,width,color] = size(imquant);

h = floor(height/16);
w = floor(width/16);

%hrat = floor(height/16);
%wrat = floor(width/16);

imquant = imresize(imquant, [16, 16]);
tiny_im = floor(imquant);

tiny_im = reshape(tiny_im,1,(16^2)*3);

end