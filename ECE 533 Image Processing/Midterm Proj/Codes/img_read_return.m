function [img] = img_read_return(pathname, filename, func)
    % author : Yizhou Lu
    % data: 2020-10-17
% parameters explanation:
% the target is in the pathname with a corresponding filename
% func is used to capture the data; for example, func = @imread, @fitsread,
% etc
current_path = pwd;
cd(pathname);
img = func(filename);
cd(current_path);
end