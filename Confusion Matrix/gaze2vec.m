function [gt_vec, test_vec, overlap, union] = gaze2vec(gt, test, length)
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
    % Resize figure
    set(gcf, 'Position', [0 200 1000 190])      % [x y width height]  
    
    for i = 1:size(gt,1)
        rectangle('Position',[gt(i,1) 1 (gt(i,2)-gt(i,1)) .5], 'FaceColor','g','EdgeColor','k','LineWidth',1) 
    end
    for i = 1:size(test,1)
        rectangle('Position',[test(i,1) .5 (test(i,2)-test(i,1)) .5], 'FaceColor','b','EdgeColor','k','LineWidth',1) 
    end
    [first last logic] = SplitVec(overlap,[],'first','last','firstelem');
    for i=1:size(logic,1)
        if logic(i)==1
            rectangle('Position',[first(i) 0 last(i)-first(i) .5],'FaceColor','r','EdgeColor','k','LineWidth',1)
        end
    end
    % Create 3 rows of text
    y = ylabel({'  GT';' ';'Algorithm';' ';'Overlap'});
    % Rotate ylabel so it's horizontal
    set(get(gca,'ylabel'),'rotation',0)
    % Reposition ylabel so it can be read easily
    set(y, 'Units', 'Normalized', 'Position', [-0.05, 0.1, .5]);    % [x y text size]
    xlabel('Frame number');
    xlim([0 length]);
    % Get rid of y axis 
    set(gca,'YTickLabel',[]);       
    
    
    % Plot legend without relations to graph
%     h = zeros(3, 1);                % dummy variable
%     h(1) = plot(NaN,NaN,'og');
%     h(2) = plot(NaN,NaN,'ob');
%     h(3) = plot(NaN,NaN,'or');
%     legend(h, 'Ground truth','Algorithm','Overlap');
end