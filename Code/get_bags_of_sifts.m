% Implementated according to the starter code prepared by James Hays, Brown University
% Michal Mackiewicz, UEA, March 2015

function image_feats = get_bags_of_sifts(image_paths, step_size)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.
%}

load('vocab.mat')
%step_size = 5;
% [locations, SIFT_features] = vl_dsift(img);
% D = vl_alldist2(X,Y); 
image_feats= zeros(size(image_paths,1),size(vocab,2));

for i = 1:length(image_paths)
    fprintf("Using Bag of SIFTs to process image %d/%d\n",i,length(image_paths));
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
    distance = vl_alldist2(vocab,single(SIFT_features)); %calculates the distance between the vocab and the image sift feature
    [~,I] = min(distance,[], 1); %returns the minimum elements of the array
    for j = 1:length(I) 
        image_feats(i,I(j)) = image_feats(i, I(j)) + 1; 
    end
    image_feats(i,:) = image_feats(i,:) / sum(image_feats(i,:)); %normalise the hist
    end
end