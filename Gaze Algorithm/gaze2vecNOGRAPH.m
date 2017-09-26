function [gt_vec, test_vec, overlap, union] = gaze2vecNOGRAPH(gt, test, length)
    % Convert gaze to an array of 1s and 0s
    max_size = max(max(gt(:),max(test(:))));
    gt_vec = zeros(max_size,1);
    test_vec = zeros(max_size,1);
    union = zeros(max_size,1);

    for i=1:size(gt,1)
        gt_vec(gt(i,1):gt(i,2)) = 1;
    end

    for i=1:size(test,1)
        test_vec(test(i,1):test(i,2)) = 1;
    end

    % calc overlap
    overlap = gt_vec.*test_vec;

    % calc union
    for i = 1:size(gt_vec,1)
        if gt_vec(i) || test_vec(i)
            union(i) = 1; 
        end
    end
    
end