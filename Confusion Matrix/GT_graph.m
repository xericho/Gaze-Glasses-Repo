function GT_graph(student_gt, leanne_gt, vid_length)

    figure
    set(gcf, 'Position', [0 200 1400 190])      % [x y width height] 
    
    for i = 1:size(student_gt,1)
        rectangle('Position',[student_gt(i,1) 0 (student_gt(i,2)-student_gt(i,1)) .5], 'FaceColor','g','EdgeColor','k','LineWidth',1) 
    end
    for i = 1:size(leanne_gt,1)
        rectangle('Position',[leanne_gt(i,1) .5 (leanne_gt(i,2)-leanne_gt(i,1)) .5], 'FaceColor','r','EdgeColor','k','LineWidth',1) 
    end
    
    y = ylabel({'Leanne GT';' ';' ';' ';'Student GT';});
    % Rotate ylabel so it's horizontal
    set(get(gca,'ylabel'),'rotation',0)
    % Reposition ylabel so it can be read easily
    set(y, 'Units', 'Normalized', 'Position', [-0.04, 0.1, .5]);    % [x y text size]
    xlabel('Frame number');
    xlim([0 vid_length]);
    % Get rid of y axis     
    set(gca,'YTickLabel',[]); 
end

