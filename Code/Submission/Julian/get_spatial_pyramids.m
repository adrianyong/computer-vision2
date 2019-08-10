function spatial_pyramid_feats = get_spatial_pyramids(image_paths,step_size,level)

%level = 2; %change this parameter
%step_size = 5;

%commented sections are for RGB

load('vocab.mat')
spatial_pyramid_feats = [];

for i = 1:length(image_paths)
    
    fprintf("Using spatial pyramids to process image %d/%d\n",i,length(image_paths));
    
	img_file = fullfile(image_paths{i});
    img = imread(img_file);
	img = rgb2gray(img);
    
    vec = zeros(1,size(vocab,2));
    vec2 = [];
    
	[width, height, d] = size(img);
    
    
    %img_r = img(:,:,1);
    %img_g = img(:,:,2);
    %img_b = img(:,:,3);
    
	it = 2^level; %number of rows to compute

    shift_right = width/it;
    shift_bottom = height/it;

    %for y = 1:3
        for j = 1:it
            for k = 1:it

                img_left = shift_right*(k-1);
                img_top = shift_bottom*(j-1);

%                 if(y==1)
%                     im = single(img_r);
%                     %figure;
%                 end
%                 if(y==2)
%                     im = single(img_g);
%                     %figure;
%                 end
                %if(y==3)
                %   im = single(img_b);
                   %figure;
                %end
                
                small_img = single(imcrop(img,[img_left img_top shift_right shift_bottom]));
                
                %colhist = color_histogram(small_img);
                [locations, SIFT_features] = vl_dsift(small_img,'Step', step_size); %sift
                distance = vl_alldist2(vocab,single(SIFT_features));
                [~,I] = min(distance,[], 1);
                for x = 1:length(I)
                    vec(1, I(x)) = vec(1, I(x)) + 1; 
                end

                %vec = [vec,SIFT_features]; %%CALCULATE HISTOGRAM HERE
                vec(1,:) = vec(1,:) / sum(vec(1,:)); %normalise the hist
                %img_hists{((j-1)*4)+k} = small_img_hist; %adds the nth histogram to img_hists

                vec2 = [vec2 vec];

            end
        end
    %end

    spatial_pyramid_feats = [spatial_pyramid_feats ; vec2];
    
%end



%spatial_pyramid_feats = transpose(spatial_pyramid_feats);
%spatial_pyramid_feats = vertcat(spatial_pyramid_feats{:});

end