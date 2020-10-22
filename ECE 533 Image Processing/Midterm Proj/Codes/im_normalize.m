function [struct_imgs] = im_normalize(struct_imgs, bits)
    % author : Yizhou Lu
    % date: 2020-10-17
    
    gray_scale = 2^bits;
    fields = fieldnames(struct_imgs);
    for field_i = 1:length(fields)
        name_cell = fields(field_i);
        name = name_cell{1};
        img = struct_imgs.(name) / gray_scale;
        struct_imgs.(name) = img;
    end
end