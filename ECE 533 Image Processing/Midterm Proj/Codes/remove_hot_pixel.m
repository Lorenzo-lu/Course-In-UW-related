function [struct_imgs] = remove_hot_pixel(struct_imgs, dark_master)
    % author : Yizhou Lu
    % date: 2020-10-18
    %% find the coordinates of the hot pixels
    mean_dark_master = mean(dark_master(:));
    [hot_r, hot_c] = find(dark_master > mean_dark_master);
    
    fields = fieldnames(struct_imgs);
    for field_i = 1:length(fields)
        name_cell = fields(field_i);
        name = name_cell{1};
        img = struct_imgs.(name);
        img = neighbor_average(img, hot_r, hot_c);
%         img = estimate_exposure_time(img, dark_master, hot_r, hot_c);
        struct_imgs.(name) = img;
    end
    
    function [img] = neighbor_average(img, hot_r, hot_c)
        for k = 1:length(hot_r)
            r = hot_r(k);
            c = hot_c(k);
            val = 0;
            counts = 0;
            step = [-1, 0, 1];
            
            for p = 1:3
                for q = 1:3
                    if (p == 2 && q == 2)
                        continue;
                    end
                    
                    try
                        val = val + img(r + step(p), c + step(q));
                        counts = counts + 1;
                    catch                        
                    end
                end
            end
            val = val / counts;
            img(r,c) = val;  
                
        end        
    end

    function [img] = estimate_exposure_time(img, dark_master, hot_r, hot_c)
        sum_dark = sum(dark_master([hot_r, hot_c]));
        sum_img = sum(img([hot_r, hot_c]));
        t = sum_img / sum_dark;
        img = img - t * dark_master;  
%         img = img .* (img > 0);
%         img = (img-1) .* (img < 1) + 1; 
    end

end