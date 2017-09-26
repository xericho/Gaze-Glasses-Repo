% Used with 'AVG_results_all_vids.m' script to get the avg for all the vids

function [gt_vec, test_vec, overlap, union] = gaze2vec_ALL(gt, test, gt_vec, test_vec, overlap, union)
    % Convert gaze to an array of 1s and 0s
    max_size = max(max(gt(:),max(test(:))));
    local_gt_vec = zeros(max_size,1);
    local_test_vec = zeros(max_size,1);
    local_union = zeros(max_size,1);

    for i=1:size(gt,1)
        local_gt_vec(gt(i,1):gt(i,2)) = 1;
    end

    for i=1:size(test,1)
        local_test_vec(test(i,1):test(i,2)) = 1;
    end

    % calc overlap
    local_overlap = local_gt_vec.*local_test_vec;

    % calc union
    for i = 1:size(local_gt_vec,1)
        if local_gt_vec(i) || local_test_vec(i)
            local_union(i) = 1; 
        end
    end
    
    gt_vec = [gt_vec; local_gt_vec];
    test_vec = [test_vec; local_test_vec];
    overlap = [overlap; local_overlap];
    union = [union; local_union];
    
end