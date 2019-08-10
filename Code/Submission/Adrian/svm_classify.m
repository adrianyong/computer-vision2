% Based on James Hays, Brown University

%This function will train a linear SVM for every category (i.e. one vs all)
%and then use the learned linear classifiers to predict the category of
%every test image. Every test feature will be evaluated with all 15 SVMs
%and the most confident SVM will "win". Confidence, or distance from the
%margin, is W*X + B where '*' is the inner product or dot product and W and
%B are the learned hyperplane parameters.

function predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats, lambda)

categories = unique(train_labels); 
num_categories = length(categories);
%matching_indices = strcmp(string, cell_array_of_strings);

% train_feats_tranpose = train_image_feats';
% test_feats_transpose = test_image_feats';
lambda = 0.00001;

test_imsize = size(test_image_feats,1);
%zeroed arrays

% ws = zeros(num_categories, dim);
% bs = zeros(num_categories, 1);

%confidence_score = ones(test_imsize,1).* -1; %change the labels to 1s for 1 vs all purposes
for c = 1:num_categories
    fprintf("Using SVM category %d/%d\n",c,num_categories);

    %labels = (strcmp(categories{c}, train_labels)) - 1;  
    labels = ones(test_imsize,1).* -1;
    matching_indicies = strcmp(categories{c}, train_labels);
    labels(matching_indicies) = 1;

    [w, b] = vl_svmtrain(train_image_feats', labels, lambda, 'MaxNumIterations', 50/lambda,'Epsilon', 1e-2, 'BiasMultiplier', 2, 'Loss', 'HINGE2');
    
    
    %get test results
    test_result(c, :) = w' * test_image_feats' + b;
end

[~, indicies] = max(test_result); %find the maximum amount of matches
 predicted_categories = categories(indicies); 

end
    




