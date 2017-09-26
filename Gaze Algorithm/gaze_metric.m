clear all
close all
clc
% load('gaze_example.mat')
load('gaze_gt.mat');
load('gaze_result.mat');
%%
gt=frame_gaze_gt;
test=frame_gaze_filtered;
max_size=max(max(gt(:),max(test(:))));
gt_ini=zeros(max_size,1);
test_ini=zeros(max_size,1);

for i=1:size(gt,1)
    gt_ini(gt(i,1):gt(i,2))=1;
end
for i=1:size(test,1)
    test_ini(test(i,1):test(i,2))=1;
end

overlap=gt_ini.*test_ini;
%%
fn=0;
fp=0;
figure
hold on
for gt_index=1:size(gt,1)
    gt_start=gt(gt_index,1);
    gt_stop=gt(gt_index,2);
    rectangle('Position',[gt_start 3 (gt_stop-gt_start) 1],'FaceColor',[0.75 1 1 ],'EdgeColor','b','LineWidth',2)
    
    if sum(overlap(gt_start:gt_stop))==0;
        fn=fn+1;
    end
    
    for test_index=1:size(test,1)
        if sum(overlap(test(test_index,1):test(test_index,2)))==0
            fp=fp+1;
        end
    rectangle('Position',[test(test_index,1) 2 (test(test_index,2)-test(test_index,1)) 1],'FaceColor',[1 0.75 1],'EdgeColor','b','LineWidth',2)
    end
        
        
%     gt_start=60;
    for test_index=1:size(test,1)       %find start
        if sum(overlap(test(test_index,1):test(test_index,2)))>=5   %minimal overlap
            if test(test_index,2)>=gt_start
%                 count_start=test(a,b);
                count_start=test(test_index,1);
                break
            end
        end
    end
    
    for test_index=size(test,1):-1:1    %find end
        if sum(overlap(test(test_index,1):test(test_index,2)))>=5
            if test(test_index,1)<gt_stop
                count_stop=test(test_index,2);
                break
            end
        end
    end
    if ~exist('count_stop','var')
        continue
    end
        score(gt_index)=sum(overlap(count_start:count_stop))/(count_stop-count_start);  %total over total length
        if gt_start>count_start
            front_over=gt_start-count_start;  
        else
            front_over=0;
        end
        if gt_stop<count_stop
            back_over=count_stop-gt_stop;
        else
            back_over=0;
        end
      overshoot(gt_index)=front_over+back_over;
%     overshoot(gt_index)=((count_stop-count_start)-(gt_stop-gt_start))/(gt_stop-gt_start);
    accuracy(gt_index)=sum(overlap(gt_start:gt_stop))/(gt_stop-gt_start);
    
end

[length first last logic]=SplitVec(overlap,[],'length','first','last','firstelem')
for i=1:size(logic,1)
    if logic(i)==1
        rectangle('Position',[first(i) 1 last(i)-first(i) 1],'FaceColor',[0.25 1 1],'EdgeColor','b','LineWidth',2)
    end
end
ylabel('overlap         test            GT');
