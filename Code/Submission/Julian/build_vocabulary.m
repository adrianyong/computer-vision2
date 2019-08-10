% Based on James Hays, Brown University

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function vocab = build_vocabulary( image_paths, vocab_size, step_size )
% The inputs are images, a N x 1 cell array of image paths and the size of 
% the vocabulary.

% The output 'vocab' should be vocab_size x 128. Each row is a cluster
% centroid / visual word.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be thrown away here
  (but possibly used for extra credit in get_bags_of_sifts if you're making
  a "spatial pyramid").
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

[centers, assignments] = vl_kmeans(X, K)
 http://www.vlfeat.org/matlab/vl_kmeans.html
  X is a d x M matrix of sampled SIFT features, where M is the number of
   features sampled. M should be pretty large! Make sure matrix is of type
   single to be safe. E.g. single(matrix).
  K is the number of clusters desired (vocab_size)
  centers is a d x K matrix of cluster centroids. This is your vocabulary.
   You can disregard 'assignments'.

  Matlab has a build in kmeans function, see 'help kmeans', but it is
  slower.
%}

% Load images from the training set. To save computation time, you don't
% necessarily need to sample from all images, although it would be better
% to do so. You can randomly sample the descriptors from each image to save
% memory and speed up the clustering. Or you can simply call vl_dsift with
% a large step size here, but a smaller step size in make_hist.m. 

% For each loaded image, get some SIFT features. You don't have to get as
% many SIFT features as you will in get_bags_of_sift.m, because you're only
% trying to get a representative sample here.

% Once you have tens of thousands of SIFT features from many training
% images, cluster them with kmeans. The resulting centroids are now your
% visual word vocabulary.

SIFT_features_all = [];
step_size = 75;
for i = 1:length(image_paths)
    
    fprintf("Building dictionary for image %d/%d\n",i,length(image_paths));
    
    %read in the greyscale image
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
        [locations, SIFT_features] = vl_dsift(im, 'Step', step_size); %sift the image with the step size
        SIFT_features_all = [SIFT_features_all SIFT_features]; %add the sift features into the all of the features array

    end
    
end

%make the vocab using kmeans
 vocab = vl_kmeans(single(SIFT_features_all), vocab_size);
 
end






