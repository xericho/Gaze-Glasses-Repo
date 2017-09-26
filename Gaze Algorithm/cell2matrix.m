% Used in new_gt_extract.m

function matrix = cell2matrix(cell)

    matrix = zeros(size(cell));
    for row = 1:size(cell,1)
        for col = 1:size(cell,2)
             matrix(row,col) = str2double(cell(row,col));
        end
    end
end