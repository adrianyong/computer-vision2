% Based on James Hays, Brown University

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function [means, covariances, priors] = build_vocabulary_fisher( image_paths, vocab_size )
SIFT_features_all = [];
step_size = 75;
for i = 1:length(image_paths)
    
    fprintf("Building dictionary for image %d/%d\n",i,length(image_paths));
    
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
    
    
    [locations, SIFT_features] = vl_dsift(im, 'Step', step_size); 
    SIFT_features_all = [SIFT_features_all SIFT_features];
    
    end
end

%use GMM for vocab
 [means, covariances, priors] = vl_gmm(single(SIFT_features_all), vocab_size);
 
end






