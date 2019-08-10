function [ vec ] = get_colour_histograms(database_dirs)
vec = [];

files = database_dirs;

for i = 1:length(files)

    test_file = fullfile(files{i});
    test_im = imread(test_file); %test image
    test_imCon = rgb2ycbcr(test_im); %convert rgb to ycbcr
    chist_test = color_histogram(test_im);
    value = chist_test;
    vec = [vec;value];

end

end

