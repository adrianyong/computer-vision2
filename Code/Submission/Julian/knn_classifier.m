function [ vec ] = knn_classifier(train_feats, train_labels, test_feats)

vec = [];
k = 7;
diff = 0;

[height,width] = size(test_feats);

for h = 1:height %test image, go through each test image
    all_diffs = [];
    for i = 1:1500 %train image, this goes through each train image
         for j = 1:width
                diff = diff + abs(test_feats(h, j)-train_feats(i, j)); %calculates difference 
         end
         all_diffs = [all_diffs;diff];
         diff = 0;
    end
    
    smallest = 1/0;
    index = 0;
    
    nn_index = 0;
    k_smallest_indices = [];
    
    for n = 1:k     %finds the k smallest differences in all_diffs
        [smallest, index] = min(all_diffs);
         all_diffs(index) = 1/0;
         k_smallest_indices = [k_smallest_indices, index];
    end
    
    f = [];
    max_mode = 0;
    
    for x = 1:length(k_smallest_indices) 
        
            freq_val = floor(k_smallest_indices(x)/100);
            
            f = [f, freq_val+1];
            max_mode = mode(f);
            
            if max_mode == 16
                max_mode = 15;
            end
    end
    
    f = sort(f);
    nn_index = (max_mode*100);
    
    lab = train_labels(nn_index, 1); % correspondong label is retrieved in train_labels
    vec = [vec;lab];
    
end

%vec = rot90(vec);

end

