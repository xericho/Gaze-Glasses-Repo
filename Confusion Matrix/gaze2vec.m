function [gt_vec, test_vec, overlap, union] = gaze2vec(gt, test)
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
    
    % Plot gaze
    figure
    for i = 1:size(gt,1)
        rectangle('Position',[gt(i,1) 3 (gt(i,2)-gt(i,1)) 1], 'FaceColor',[0.75 1 1 ],'EdgeColor','b','LineWidth',2) 
    end
    for i = 1:size(test,1)
        rectangle('Position',[test(i,1) 2 (test(i,2)-test(i,1)) 1], 'FaceColor',[0.75 1 1 ],'EdgeColor','b','LineWidth',2) 
    end
    [first last logic] = SplitVec(overlap,[],'first','last','firstelem');
    for i=1:size(logic,1)
        if logic(i)==1
            rectangle('Position',[first(i) 1 last(i)-first(i) 1],'FaceColor',[0.25 1 1],'EdgeColor','b','LineWidth',2)
        end
    end
    ylabel('overlap                   test                       GT');
    xlabel('Frame number');
end