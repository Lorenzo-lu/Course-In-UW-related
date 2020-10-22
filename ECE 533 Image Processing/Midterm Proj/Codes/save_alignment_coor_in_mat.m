function save_alignment_coor_in_mat(filename, fields)
    % author : Yizhou Lu
    % date: 2020-10-18

% use cpselect to determine the following coordinates for alignment and
% save by .mat file

coor1 = [1713 945; 1625 1070; 1984 1218; 3271 420; 257 2366];
coor1 = converter(coor1);
coor2 = [1719 987; 1631 1112; 1989 1260; 3277 463; 262 2408];
coor2 = converter(coor2);
coor3 = [1761 945; 1672 1070; 2030 1218; 3318 420; 304 2366];
coor3 = converter(coor3);
coor4 = [1761 990; 1673 1115; 2031 1264; 3318 465; 305 2410];
coor4 = converter(coor4);
coor5 = [1764 1035; 1676 1159; 2034 1308; 3321 509; 308 2455];
coor5 = converter(coor5);

coor = cat(3, coor1, coor2, coor3, coor4, coor5);

LightFrame_coor = struct();
for k = 1:length(fields)
    name_cell = fields(k);
    name = name_cell{1};
    LightFrame_coor.(name) = coor(:,:,k);
end

save(filename, '-struct', 'LightFrame_coor');

function coor = converter(coor)
    coor(:,[1,2]) = coor(:,[2,1]); % swap the columns to get (r,c) instead of (x,y)
    coor = coor';
end
end