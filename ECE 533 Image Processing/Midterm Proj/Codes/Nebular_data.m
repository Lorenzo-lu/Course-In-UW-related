function [Master_obj, Light_obj] = Nebular_data()
% Author: Yizhou Lu
% date: 10/17/2020
% 
%

% clc;
% clear;
% close all;
%% Import images;

%**************************************************************************
% master frame
pathname_Masters = ['C:\Yizhou_coding\Coursework\2020-3 Fall\ECE 533',...
    ' image processing\Projects\MidTerm\Rosette_Nebula_Data\Rosette_Nebula_Data'];
filename_MasterDark = ['600s_n20_1x1_MASTERDARK_2018_9.fits'];
filename_MasterBias = ['MASTERBIAS_2018_9.fits'];
filename_MasterFlat = ['MASTERFLAT_Ha_Rosette_04052020.fits'];
%**************************************************************************

%**************************************************************************
% data set Light frames
pathname_Light = ['C:\Yizhou_coding\Coursework\2020-3 Fall',...
    '\ECE 533 image processing\Projects\MidTerm\Rosette_Nebula_Data', ...
    '\Rosette_Nebula_Data\Rosette_Nebula_Light_Frames'];
filename_Light = ['Rosette_600s_n20_filt3_Ha_2.fits'];
%**************************************************************************

%**************************************************************************
% read masters and save into a struct
% call by struct.(key)
Master_filenames = {filename_MasterDark, (filename_MasterBias), ...
    filename_MasterFlat};

Master_names = {'Dark', 'Bias', 'Flat'};
Master_obj = (struct());
for k = 1:length(Master_names)
    this_name = Master_names{k};
    
    Master_obj.(this_name) = img_read_return(pathname_Masters, ...
        (Master_filenames{k}), @fitsread);
end
%**************************************************************************

%--------------------------------------------------------------------------
% This is for looping in a struct (refer if necessary)

% fields = fieldnames(Master_obj);
% for i = 1:length(fields)
%     k = (fields(i));
%     key = k{1};
%     Master_obj.(key) = img_read_return(pathname_Masters, (Master_filenames{i}), @fitsread);
% end
%--------------------------------------------------------------------------

%**************************************************************************
% read light frames
Light_obj = struct();
toChange = length(filename_Light) - 5;
for k = 0:4
    this_filename = filename_Light;
    this_filename(toChange) = int2str(k);
    index = ['img_',int2str(k)];
    Light_obj.(index) = img_read_return(pathname_Light, ...
        this_filename, @fitsread);
end
end