function [img] = im_alignment(struct_img, struct_coor)
    % author : Yizhou Lu
    % date: 2020-10-18
    
    fields = fieldnames(struct_img);
    raw_name_cell = fields(1);
    raw_name = raw_name_cell{1};
    img0 = struct_img.(raw_name);
    coor0 = struct_coor.(raw_name); %% choose the image 0 as the base
    coor0 = FindCenter_array(coor0, round(img0)); %% using binary image
    img = img0;
    
    %% test transformer function:
%     Transformer = [0.9996   -0.0006   90.8147;
%     0.0013    1.0002   48.2472;
%    -0.0000   -0.0000    1.0000];
%     
%     round(getTransformed(Transformer, [1;2]))
    %%
%     f = waitbar(0, 'Be patient, BeneFactor...');
%     hPatch = findobj(f,'Type','Patch');
%     set(hPatch,'FaceColor',[1 0 1], 'EdgeColor',[1 0 1]);
    
    for k = 2:length(fields)
        %fprintf('%d / %d\n', k, length(fields));
        %YZ_process_bar((k-1) /(length(fields)-1));
        name_cell = fields(k);
        name = name_cell{1};
        img1 = struct_img.(name);
        coor1 = struct_coor.(name);
        
        Transformer = getTransformer(coor1, coor0); % transform from image 0 to image 1
        img = Transform_and_Crop(Transformer, img, img1);
    end
    img = img / length(fields);   
    
%% return the set of centers by recursion using FindCenter()
    function [new_coor] = FindCenter_array(old_coor, img)
        new_coor = zeros(size(old_coor)); 
        
        for t = 1:length(old_coor)
            r = old_coor(1,t);
            c = old_coor(2,t);
            center = FindCenter(r,c,img);
            new_coor(:,t) = center;            
        end  
    
%% function for finding the center of a cluster of white pixels
        function [center] = FindCenter(r,c, img)
            global bin_img;
            bin_img = (img);
            global coor;
            coor = [];
            isolate_islands(r,c,size(bin_img)); 
            center = mean(coor,1);

            function isolate_islands(r,c, dim)  
                if r > 0 && r <= dim(1)
                    if c > 0 && c<=dim(2)
                        coor(end+1,:) = [r c];
                        if bin_img(r,c) == 1
                            %coor(end+1,:) = [r c];
                            bin_img(r,c) = 0;
                            isolate_islands(r+1,c, dim);
                            isolate_islands(r-1,c, dim);
                            isolate_islands(r,c+1, dim);
                            isolate_islands(r,c-1, dim);
                        end
                    end
                end            
            end
        end
    end

%% forward and backward transform
    function [transformer] = getTransformer(coor0, coor1) % coor0 is target
        coor0 = Add_one(coor0);
        coor1 = Add_one(coor1);
        transformer = coor0 * pinv(coor1);
    end

    function [new_coor] = getTransformed(transformer, coor) % forward transform
        coor = Add_one(coor);
        new_coor = transformer*coor;
        new_coor = new_coor(1:2,:);
    end

    function [new_tensor] = TransformImgCood(transformer, img)
        %%% find the corrsponding coordinates of the raw image by grid
        dims = size(img);
        [old_grid_x, old_grid_y] = meshgrid([1:dims(1)],[1:dims(2)]);
        old_tensor = cat(3, old_grid_x(:), old_grid_y(:));
        old_coor = permute(old_tensor,[3,1,2]); %% convert to 2xn matrix
        new_coor = getTransformed(transformer, old_coor);
        new_tensor = permute(new_coor, [2,3,1]); %% convert back to tensor
        new_gridx = reshape(new_tensor(:,:,1), dims);
        new_gridy = reshape(new_tensor(:,:,2), dims);  
        new_tensor = cat(3, new_gridx, new_gridy);
    end
    
    function [new_img] = Transform_and_Crop(transformer, img0, img1)
        dims = size(img0);
        new_img = zeros(dims);
        
        for kr = 1:dims(1)
            YZ_process_bar((kr) /(dims(1)));
%             waitbar(kr/dims(1),f, ['Be Patient, BeneFactor...', num2str(kr/dims(1)*100, '%.2f'), '%']);
            for kc = 1:dims(2)
                coor = [kr; kc];
                coor_new = round(getTransformed(transformer, coor));
                kr_n = coor_new(1);
                kc_n = coor_new(2);
                try                    
                    new_img(kr, kc) = (img0(kr,kc) + img1(kr_n, kc_n));                    
                catch 
                    %new_img(kr, kc) = img0(kr,kc);
                end                
            end
        end

    end
        

    function [coor] = Add_one(coor) %% add ones as the third row!
        coor = [coor; ones(1,length(coor(1,:)))];
    end

    

end