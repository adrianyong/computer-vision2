function [ vec ] = tiny_image(database_dirs)

vec = [];
files = database_dirs;

for i = 1:length(files)

    test_file = fullfile(files{i});
    test_im = imread(test_file);
    tiny_im = generate_tiny_image(test_im);
    value = tiny_im;
    vec = [vec;value];

end

%vec = rot90(vec);

end