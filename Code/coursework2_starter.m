% Jan 2016, Michal Mackiewicz, UEA
% This code has been adapted from the code 
% prepared by James Hays, Brown University

%params

lambda = 0.000001;
vocab_step = 75; %best 75
feature_step = 5;
vocab_size = 200; %best 200
level = 1;
timeTaken = 0;
mode = 'm'; %auto mode "a" or manual "m"


%delete params.csv;
%delete accuracies.csv;

if(mode == 'a')
    
    for i = 1:1 %total parameters changing
        for j = 1:6 %number of changes to iterator
            
            %%EXECUTE TEST HERE%%

            %% Step 0: Set up parameters, vlfeat, category list, and image paths.

            %FEATURE = 'tiny image';
            FEATURE = 'bag of sift';
            %FEATURE = 'colour histogram';
            %FEATURE = 'fisher';
            %FEATURE = 'spatial pyramid';

            CLASSIFIER = 'nearest neighbor';
            %CLASSIFIER = 'support vector machine';
            % Set up paths to VLFeat functions. 
            % See http://www.vlfeat.org/matlab/matlab.html for VLFeat Matlab documentation
            % This should work on 32 and 64 bit versions of Windows, MacOS, and Linux
            %run('vlfeat/toolbox/vl_setup')
            
            
            data_path = '../Data/';

            %This is the list of categories / directories to use. The categories are
            %somewhat sorted by similarity so that the confusion matrix looks more
            %structured (indoor and then urban and then rural).
            categories = {'Kitchen', 'Store', 'Bedroom', 'LivingRoom', 'House', ...
                   'Industrial', 'Stadium', 'Underwater', 'TallBuilding', 'Street', ...
                   'Highway', 'Field', 'Coast', 'Mountain', 'Forest'};

            %This list of shortened category names is used later for visualization.
            abbr_categories = {'Kit', 'Sto', 'Bed', 'Liv', 'Hou', 'Ind', 'Sta', ...
                'Und', 'Bld', 'Str', 'HW', 'Fld', 'Cst', 'Mnt', 'For'};

            %number of training examples per category to use. Max is 100. For
            %simplicity, we assume this is the number of test cases per category, as
            %well.
            num_train_per_cat = 100; 

            %This function returns cell arrays containing the file path for each train
            %and test image, as well as cell arrays with the label of each train and
            %test image. By default all four of these arrays will be 1500x1 where each
            %entry is a char array (or string).
            fprintf('Getting paths and labels for all train and test data\n')
            [train_image_paths, test_image_paths, train_labels, test_labels] = ...
                get_image_paths(data_path, categories, num_train_per_cat);
            %   train_image_paths  1500x1   cell      
            %   test_image_paths   1500x1   cell           
            %   train_labels       1500x1   cell         
            %   test_labels        1500x1   cell          

            %% Step 1: Represent each image with the appropriate feature
            % Each function to construct features should return an N x d matrix, where
            % N is the number of paths passed to the function and d is the 
            % dimensionality of each image representation. See the starter code for
            % each function for more details.

            fprintf('Using %s representation for images\n', FEATURE)
            tic
            switch lower(FEATURE)    
                case 'tiny image'
                    %You need to reimplement get_tiny_images. Allow function to take
                    %parameters e.g. feature size.

                    % image_paths is an N x 1 cell array of strings where each string is an
                    %  image path on the file system.
                    % image_feats is an N x d matrix of resized and then vectorized tiny
                    %  images. E.g. if the images are resized to 16x16, d would equal 256.

                    % To build a tiny image feature, simply resize the original image to a very
                    % small square resolution, e.g. 16x16. You can either resize the images to
                    % square while ignoring their aspect ratio or you can crop the center
                    % square portion out of each image. Making the tiny images zero mean and
                    % unit length (normalizing them) will increase performance modestly.

                    train_image_feats = get_tiny_images(train_image_paths);
                    test_image_feats  = get_tiny_images(test_image_paths);
                case 'colour histogram'
                    %You should allow get_colour_histograms to take parameters e.g.
                    %quantisation, colour space etc.
                    train_image_feats = get_colour_histograms(train_image_paths);
                    test_image_feats  = get_colour_histograms(test_image_paths);
                 case 'bag of sift'
                    % YOU CODE build_vocabulary.m
                    if ~exist('vocab.mat', 'file')
                        fprintf('No existing dictionary found. Computing one from training images\n')
                        %%vocab_size = 50; % you need to test the influence of this parameter
                        vocab = build_vocabulary(train_image_paths, vocab_size, vocab_step); %Also allow for different sift parameters
                        save('vocab.mat', 'vocab')
                    end

                    % YOU CODE get_bags_of_sifts.m
                    if ~exist('image_feats.mat', 'file')
                        train_image_feats = get_bags_of_sifts(train_image_paths, feature_step); %Allow for different sift parameters
                        test_image_feats  = get_bags_of_sifts(test_image_paths, feature_step); 
                        save('image_feats.mat', 'train_image_feats', 'test_image_feats');
                    end
                   case 'fisher'
                    % YOU CODE build_vocabulary.m
                    if ~exist('fisher_vocab.mat', 'file')
                        fprintf('No existing dictionary found. Computing one from training images\n')
                        vocab_size = 200; %you need to test the influence of this parameter
                        [means, covariances, priors] = build_vocabulary_fisher(train_image_paths, vocab_size); %Also allow for different sift parameters
                        save('fisher_vocab.mat')
                    end

                    % YOU CODE fisher_encode.m
                    if ~exist('image_feats_fisher.mat', 'file')
                        train_image_feats = fisher_encode(train_image_paths); %Allow for different sift parameters
                        test_image_feats  = fisher_encode(test_image_paths); 
                        save('image_feats_fisher.mat', 'train_image_feats', 'test_image_feats')
                    end
                  case 'spatial pyramid'
                      % YOU CODE build_vocabulary.m
                    if ~exist('vocab.mat', 'file')
                        fprintf('No existing dictionary found. Computing one from training images\n')
                        %%vocab_size = 50; % you need to test the influence of this parameter
                        vocab = build_vocabulary(train_image_paths, vocab_size, vocab_step); %Also allow for different sift parameters
                        save('vocab.mat', 'vocab')
                    end

                    % YOU CODE get_bags_of_sifts.m
                    if ~exist('image_feats.mat', 'file')
                        train_image_feats = get_spatial_pyramids(train_image_paths,feature_step, level); %Allow for different sift parameters
                        test_image_feats  = get_spatial_pyramids(test_image_paths,feature_step, level); 
                        save('image_feats.mat', 'train_image_feats', 'test_image_feats')
                    end                      
                   
            end
            timeTaken = toc;
            %% Step 2: Classify each test image by training and using the appropriate classifier
            % Each function to classify test features will return an N x 1 cell array,
            % where N is the number of test cases and each entry is a string indicating
            % the predicted category for each test image. Each entry in
            % 'predicted_categories' must be one of the 15 strings in 'categories',
            % 'train_labels', and 'test_labels'. See the starter code for each function
            % for more details.

            fprintf('Using %s classifier to predict test set categories\n', CLASSIFIER)

            switch lower(CLASSIFIER)    
                case 'nearest neighbor'
                    predicted_categories = knn_classifier(train_image_feats, train_labels, test_image_feats);
                case 'support vector machine'
                    predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats, lambda);
            end
            params = [lambda,vocab_step,feature_step,vocab_size,level,timeTaken];
            dlmwrite('params.csv',params,'-append');

            %% Step 3: Build a confusion matrix and score the recognition system
            % You do not need to code anything in this section. 

            % This function will recreate results_webpage/index.html and various image
            % thumbnails each time it is called. View the webpage to help interpret
            % your classifier performance. Where is it making mistakes? Are the
            % confusions reasonable?
            create_results_webpage( train_image_paths, ...
                                    test_image_paths, ...
                                    train_labels, ...
                                    test_labels, ...
                                    categories, ...
                                    abbr_categories, ...
                                    predicted_categories)   

            delete image_feats.mat;
            
            params = [lambda,vocab_step,feature_step,vocab_size,level,timeTaken];
            
            dlmwrite('params.csv',params,'-append');
            timeTaken = 0;
            %level = level + 1;
            
            %if(i==1)
            %    lambda=lambda/10;
            %end
             %if(i==1)
             %    delete vocab.mat;
             %    vocab_step = vocab_step + 25;
             %end
             %if(i==1)
             %    feature_step = feature_step + 5;
             %end
             if(i==1)
                 vocab_size = vocab_size + 50;
             end
             if(j==10)	
                 delete vocab.mat;
                 lambda = 0.000001;
                 vocab_step = 25;
                 feature_step = 5;
                 vocab_size = 25;
             end
        end
    end

elseif(mode == 'm')
    
    %delete vocab.mat;
    
    %% Step 0: Set up parameters, vlfeat, category list, and image paths.

            %FEATURE = 'tiny image';
            %FEATURE = 'bag of sift';
            %FEATURE = 'colour histogram';
            FEATURE = 'fisher';
            %FEATURE = 'spatial pyramid';

            CLASSIFIER = 'nearest neighbor';
            %CLASSIFIER = 'support vector machine';

            
            
                       
            data_path = '../Data/';

            categories = {'Kitchen', 'Store', 'Bedroom', 'LivingRoom', 'House', ...
                   'Industrial', 'Stadium', 'Underwater', 'TallBuilding', 'Street', ...
                   'Highway', 'Field', 'Coast', 'Mountain', 'Forest'};

            %This list of shortened category names is used later for visualization.
            abbr_categories = {'Kit', 'Sto', 'Bed', 'Liv', 'Hou', 'Ind', 'Sta', ...
                'Und', 'Bld', 'Str', 'HW', 'Fld', 'Cst', 'Mnt', 'For'};

            num_train_per_cat = 100; 

            fprintf('Getting paths and labels for all train and test data\n')
            [train_image_paths, test_image_paths, train_labels, test_labels] = ...
                get_image_paths(data_path, categories, num_train_per_cat);

            fprintf('Using %s representation for images\n', FEATURE)
            tic;
            switch lower(FEATURE)    
                case 'tiny image'
                    train_image_feats = get_tiny_images(train_image_paths);
                    test_image_feats  = get_tiny_images(test_image_paths);
                case 'colour histogram'
                    %You should allow get_colour_histograms to take parameters e.g.
                    %quantisation, colour space etc.
                    train_image_feats = get_colour_histograms(train_image_paths);
                    test_image_feats  = get_colour_histograms(test_image_paths);
                 case 'bag of sift'
                    % YOU CODE build_vocabulary.m
                    if ~exist('vocab.mat', 'file')
                        fprintf('No existing dictionary found. Computing one from training images\n')
                        %%vocab_size = 50; % you need to test the influence of this parameter
                        vocab = build_vocabulary(train_image_paths, vocab_size, vocab_step); %Also allow for different sift parameters
                        save('vocab.mat', 'vocab')
                    end

                    % YOU CODE get_bags_of_sifts.m
                    if ~exist('image_feats.mat', 'file')
                        train_image_feats = get_bags_of_sifts(train_image_paths, feature_step); %Allow for different sift parameters
                        test_image_feats  = get_bags_of_sifts(test_image_paths, feature_step); 
                        save('image_feats.mat', 'train_image_feats', 'test_image_feats');
                    end
                  case 'fisher'
                    % YOU CODE build_vocabulary_fisher.m
                    if ~exist('fisher_vocab.mat', 'file')
                        fprintf('No existing dictionary found. Computing one from training images\n')
                        vocab_size = 200; %you need to test the influence of this parameter
                        [means, covariances, priors] = build_vocabulary_fisher(train_image_paths, vocab_size); %Also allow for different sift parameters
                        save('fisher_vocab.mat')
                    end

                    % YOU CODE fisher.m
                    if ~exist('image_feats_fisher.mat', 'file')
                        train_image_feats = fisher_encode(train_image_paths); %Allow for different sift parameters
                        test_image_feats  = fisher_encode(test_image_paths); 
                        save('image_feats_fisher.mat', 'train_image_feats', 'test_image_feats')
                    end
                  case 'spatial pyramid'
                      % YOU CODE spatial pyramids method
                        if ~exist('vocab.mat', 'file')
                            fprintf('No existing dictionary found. Computing one from training images\n')
                            %%vocab_size = 50; % you need to test the influence of this parameter
                            vocab = build_vocabulary(train_image_paths, vocab_size, vocab_step); %Also allow for different sift parameters
                            save('vocab.mat', 'vocab')
                        end
                        if ~exist('image_feats_spatial.mat', 'file')
                            train_image_feats = get_spatial_pyramids(train_image_paths,feature_step, level); %Allow for different sift parameters
                            test_image_feats  = get_spatial_pyramids(test_image_paths,feature_step, level); 
                            save('image_feats_spatial.mat', 'train_image_feats','test_image_feats');
                        end
            end
            timeTaken = toc;
            
            
            fprintf('Using %s classifier to predict test set categories\n', CLASSIFIER)
            timeTaken = toc;
            switch lower(CLASSIFIER)
                case 'nearest neighbor'
                    predicted_categories = knn_classifier(train_image_feats, train_labels, test_image_feats);
                case 'support vector machine'
                    predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats, lambda);
            end
            
            
            params = [lambda,vocab_step,feature_step,vocab_size,level,timeTaken];
            dlmwrite('params.csv',params,'-append');
            create_results_webpage( train_image_paths, ...
                                    test_image_paths, ...
                                    train_labels, ...
                                    test_labels, ...
                                    categories, ...
                                    abbr_categories, ...
                                    predicted_categories)   

            params = [lambda,vocab_step,feature_step,vocab_size,level,timeTaken];
            
            dlmwrite('paramsSP.csv',params,'-append');
            timeTaken = 0;
end

