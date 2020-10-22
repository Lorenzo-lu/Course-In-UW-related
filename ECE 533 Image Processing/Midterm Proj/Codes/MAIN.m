    % author : Yizhou Lu
    % date: 2020-10-18
clc
clear
close all;
%% Data Preparation:
%**************************************************************************    
%read data in my computer: if you want to read fits in your own computer,
%please edit the "Nebular_data()"
[MasterFrames, LightFrames] = Nebular_data(); 


% >> if already have SNR improved image, leave HaveImage = 1; else, change it to 0;
HaveImage = 0;
filename = ['Aligned image.fits'];
if ~HaveImage
    
    % To call the matrices in a struct:
    % For example: MasterFrames.('Dark'); LightFrames.('img_0');
    %**************************************************************************
    Bits = 16;
    MasterFrames = im_normalize(MasterFrames, Bits);
    LightFrames = im_normalize(LightFrames, Bits);
    LightFrames = remove_hot_pixel(LightFrames, MasterFrames.('Dark'));
    LightFrames = remove_flat(LightFrames, MasterFrames.('Flat'));
    fields = fieldnames(LightFrames);
    % 
    % img1 = LightFrames.('img_1');
    % img0 = LightFrames.('img_0');
    % cpselect(round(img1), round(img0));

    %**************************************************************************
    % %initialize the coordiaates in (row,col) for further alignment
    filename_for_align = 'LightFrame_alignment.mat';

    HaveData = 1;

    if ~HaveData
        fprintf('Generating row and column coordinates for alignment!');
        save_alignment_coor_in_mat(filename_for_align, fieldnames(LightFrames));
    end
    %**************************************************************************
    Light_coor_struct = (load(filename_for_align)); 
    tic;
    img = im_alignment(LightFrames, Light_coor_struct);
    toc;

    fitswrite(img, filename);
end

img = fitsread(filename);
figure()
imshow(histeq(img));