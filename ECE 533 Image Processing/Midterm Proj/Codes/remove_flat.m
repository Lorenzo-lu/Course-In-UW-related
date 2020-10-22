function  [struct_imgs] = remove_flat(struct_imgs, flat_master)
    % author : Yizhou Lu
    % date: 2020-10-18
    mean_flat_master = mean(flat_master(:));
    ratio_map = flat_master ./ mean_flat_master;
    
    fields = fieldnames(struct_imgs);
    for field_i = 1:length(fields)
        name_cell = fields(field_i);
        name = name_cell{1};
        img = struct_imgs.(name);
        img = img.* ratio_map;
        
        img = img .* (img > 0);
        img = (img-1) .* (img < 1) + 1;        
        struct_imgs.(name) = img;
    end

end