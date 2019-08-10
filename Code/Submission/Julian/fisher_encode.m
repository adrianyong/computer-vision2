% Implementated according to the starter code prepared by James Hays, Brown University
% Michal Mackiewicz, UEA, March 2015

function image_feats = fisher_encode(image_paths)
load('fisher_vocab.mat')
vocab_size = size(means, 2);
step_size = 5;
% [locations, SIFT_features] = vl_dsift(img);
% D = vl_alldist2(X,Y); 
image_feats= zeros(size(image_paths,1), 2*vocab_size*128);



for i = 1:length(image_paths)
    fprintf("Using Fisher to process image %d/%d\n",i,length(image_paths));
    %for each image in the image path, convert to gray and sift
    img_file = fullfile(image_paths{i});
    img = imread(img_file);
    %img = single(rgb2gray(img));
    
    img_r = img(:,:,1);
    img_g = img(:,:,2);
    img_b = img(:,:,3);
    
    for j = 1:3
                if(j==1)
                    im = single(img_r);
                end
                if(j==2)
                    im = single(img_g);
                end
                if(j==3)
                   im = single(img_b);
                end
    
    [locations, SIFT_features] = vl_dsift(im,'Step', step_size); %sift
    image_feats(i,:) = vl_fisher(single(SIFT_features),means, covariances, priors, 'Improved');
    end
   end
    
end







%     distance = vl_alldist2(vocab,single(SIFT_features));
%     [~,I] = min(distance,[], 1);
%     for j = 1:length(I)
%         image_feats(i,I(j)) = image_feats(i, I(j)) + 1; 
