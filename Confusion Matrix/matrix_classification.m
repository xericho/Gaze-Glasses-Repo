clear all
clc
%make sure that object_num is imported 
%load the ground truth
load('vid0_gt.mat');
load('test.mat');
%%%%%%%%%%%%%%%%%%%%%
%  1.TN   %   2.FP %
%%%%%%%%%%%%%%%%%%%%%
%  3.FN   %   4.TP %
%%%%%%%%%%%%%%%%%%%%%
%% Code with fucntion
[brain_matrix, brain_tpfp, brain_filtered] = extract_classification_matrix(brain_truth, brain_test);
[dice_matrix, dice_tpfp, dice_filtered] = extract_classification_matrix(dice_truth, dice_test);
[frame_matrix, frame_tpfp, frame_filtered] = extract_classification_matrix(frame_truth, frame_test);
[hedgehog_matrix, hedgehog_tpfp, hedgehog_filtered] = extract_classification_matrix(hedgehog_truth, hedgehog_test);
[shark_matrix, shark_tpfp, shark_filtered] = extract_classification_matrix(shark_truth, shark_test);
[top_matrix, top_tpfp, top_filtered] = extract_classification_matrix(top_truth, top_test);

%%
if exist('brain_test','var') %if there is a test file(some detection)
    for i=1:size(brain_truth,1)
        if isnan(brain_truth(i,1)) %Ground Truth Negative
            if isnan(brain_test(i,1))   %Negative detection
                brain_result(i)=1;                %TN
            else                        %Positive Detection
                brain_result(i)=2;               %FP
            end
        else                        %ground Truth Positive
            if edge_case(brain_truth(i,:))==1 %check edge case
                brain_result(i)=6;
            else
                if isnan(brain_test(i,1))   %Negative Detection
                    brain_result(i)=3;                %FN
                else                        %Positive Detection
                    if bboxOverlapRatio(brain_truth(i,:),brain_test(i,:))>=0.5 %75 overlap needed
                        brain_result(i)=4;            %TP
                    else
                      brain_result(i)=5;
                    end 
                end
            end
        end
    end
    brain_matrix(1,1)=sum(brain_result(:)==1);
    brain_matrix(1,2)=sum(brain_result(:)==2);
    brain_matrix(2,1)=sum(brain_result(:)==3);
    brain_matrix(2,2)=sum(brain_result(:)==4);
    brain_filtered=sum(brain_result(i)==5);
    brain_matrix
    brain_fpr=brain_matrix(1,2)/(brain_matrix(1,2)+brain_matrix(1,1));
    brain_tpr=brain_matrix(2,2)/(brain_matrix(2,2)+brain_matrix(2,1));
    [brain_fpr;brain_tpr]
%     brain_filtered
    
else
    brain_matrix=zeros(2,2);
    brain_matrix(2,1)=sum(~isnan(brain_truth(:,1)))
end

%%
if exist('dice_test','var') %if there is a test file(some detection)
    for i=1:size(dice_truth,1)
        if isnan(dice_truth(i,1)) %Ground Truth Negative
            if isnan(dice_test(i,1))   %- detection
                dice_result(i)=1;                %TN
            else                        %Neg Detection
                dice_result(i)=2;               %FP
            end
        else                      %ground Truth Positive
            if edge_case(dice_truth(i,:))==1
                dice_result(i)=6;
                else
                if isnan(dice_test(i,1))   %Negative Detection
                    dice_result(i)=3;                %FN
                else                        %Positive Detection
                   if bboxOverlapRatio(dice_truth(i,:),dice_test(i,:))>=0.5 %75 overlap needed
                        dice_result(i)=4;            %TP
                    else
                      dice_result(i)=5;
                    end 
                end
            end
        end
    end
    dice_matrix(1,1)=sum(dice_result(:)==1);
    dice_matrix(1,2)=sum(dice_result(:)==2);
    dice_matrix(2,1)=sum(dice_result(:)==3);
    dice_matrix(2,2)=sum(dice_result(:)==4);
    dice_filtered=sum(dice_result(i)==5);
    dice_matrix
    dice_fpr=dice_matrix(1,2)/(dice_matrix(1,2)+dice_matrix(1,1));
    dice_tpr=dice_matrix(2,2)/(dice_matrix(2,2)+dice_matrix(2,1));
    [dice_fpr;dice_tpr]
%     dice_filtered
  
else
    dice_matrix=zeros(2,2);
    dice_matrix(2,1)=sum(~isnan(dice_truth(:,1)))
end

%%
if exist('frame_test','var') %if there is a test file(some detection)
    for i=1:size(frame_truth,1)
        if isnan(frame_truth(i,1)) %Ground Truth Negative
            if isnan(frame_test(i,1))   %Positive detection
                frame_result(i)=1;                %TN
            else                        %Neg Detection
                frame_result(i)=2;               %FP
            end
        else                        %ground Truth Positive
            if edge_case(frame_truth(i,:))==1
                frame_result(i)=6;
            else
                if isnan(frame_test(i,1))   %Negative Detection
                    frame_result(i)=3;                %FN
                else                        %Positive Detection
                   if bboxOverlapRatio(frame_truth(i,:),frame_test(i,:))>=0.5 %75 overlap needed
                        frame_result(i)=4;            %TP
                    else
                      frame_result(i)=5;
                    end 
                end
            end
        end
    end
    frame_matrix(1,1)=sum(frame_result(:)==1);
    frame_matrix(1,2)=sum(frame_result(:)==2);
    frame_matrix(2,1)=sum(frame_result(:)==3);
    frame_matrix(2,2)=sum(frame_result(:)==4);
    frame_filtered=sum(frame_result(i)==5);
    frame_matrix
    frame_fpr=frame_matrix(1,2)/(frame_matrix(1,2)+frame_matrix(1,1));
    frame_tpr=frame_matrix(2,2)/(frame_matrix(2,2)+frame_matrix(2,1));
    [frame_fpr;frame_tpr]
%     frame_filtered
    
else
    frame_matrix=zeros(2,2);
    frame_matrix(2,1)=sum(~isnan(frame_truth(:,1)))
end

%%
if exist('hedgehog_test','var') %if there is a test file(some detection)
    for i=1:size(hedgehog_truth,1)
        if isnan(hedgehog_truth(i,1)) %Ground Truth Negative
            if isnan(hedgehog_test(i,1))   %Positive detection
                hedgehog_result(i)=1;                %TN
            else                        %Neg Detection
                hedgehog_result(i)=2;               %FP
            end
        else                        %ground Truth Positive
%             if edge_case(hedgehog_truth(i,:))==1
%                 hedgehog_result(i)=6;
%                 else84
                if isnan(hedgehog_test(i,1))   %Negative Detection
                    hedgehog_result(i)=3;                %FN
                else                        %Positive Detection
                   if bboxOverlapRatio(hedgehog_truth(i,:),hedgehog_test(i,:))>=0.5 %75 overlap needed
                        hedgehog_result(i)=4;            %TP
                    else
                      hedgehog_result(i)=5;
                    end 
                end
%             end
        end
    end
    hedgehog_matrix(1,1)=sum(hedgehog_result(:)==1);
    hedgehog_matrix(1,2)=sum(hedgehog_result(:)==2);
    hedgehog_matrix(2,1)=sum(hedgehog_result(:)==3);
    hedgehog_matrix(2,2)=sum(hedgehog_result(:)==4);
    hedgehog_filtered=sum(hedgehog_result(i)==5);
    hedgehog_matrix
     hedgehog_fpr=hedgehog_matrix(1,2)/(hedgehog_matrix(1,2)+hedgehog_matrix(1,1));
    hedgehog_tpr=hedgehog_matrix(2,2)/(hedgehog_matrix(2,2)+hedgehog_matrix(2,1));
    [hedgehog_fpr;hedgehog_tpr]
%     hedgehog_filtered
 
else
    hedgehog_matrix=zeros(2,2);
    hedgehog_matrix(2,1)=sum(~isnan(hedgehog_truth(:,1)))
end

%%
if exist('shark_test','var') %if there is a test file(some detection)
    for i=1:size(shark_truth,1)
        if isnan(shark_truth(i,1)) %Ground Truth Negative
            if isnan(shark_test(i,1))   %Positive detection
                shark_result(i)=1;                %TN
            else                        %Neg Detection
                shark_result(i)=2;               %FP
            end
        else                        %ground Truth Positive
            if edge_case(shark_truth(i,:))==1
                shark_result(i)=6;
                else
                if isnan(shark_test(i,1))   %Negative Detection
                    shark_result(i)=3;                %FN
                else                        %Positive Detection
                   if bboxOverlapRatio(shark_truth(i,:),shark_test(i,:))>=0.5 %75 overlap needed
                        shark_result(i)=4;            %TP
                    else
                      shark_result(i)=5;
                    end 
                end
            end
        end
    end
    shark_matrix(1,1)=sum(shark_result(:)==1);
    shark_matrix(1,2)=sum(shark_result(:)==2);
    shark_matrix(2,1)=sum(shark_result(:)==3);
    shark_matrix(2,2)=sum(shark_result(:)==4);
    shark_filtered=sum(shark_result(i)==5);
    shark_matrix
     shark_fpr=shark_matrix(1,2)/(shark_matrix(1,2)+shark_matrix(1,1));
    shark_tpr=shark_matrix(2,2)/(shark_matrix(2,2)+shark_matrix(2,1));
    [shark_fpr;shark_tpr]
%     shark_filtered
   
else
    shark_matrix=zeros(2,2);
    shark_matrix(2,1)=sum(~isnan(shark_truth(:,1)))
end

%%
if exist('top_test','var') %if there is a test file(some detection)
    for i=1:size(top_truth,1)
        if isnan(top_truth(i,1)) %Ground Truth Negative
            if isnan(top_test(i,1))   %Positive detection
                top_result(i)=1;                %TN
            else                        %Neg Detection
                top_result(i)=2;               %FP
            end
        else                        %ground Truth Positive
            if edge_case(top_truth(i,:))==1
                top_result(i)=6;
                else
                if isnan(top_test(i,1))   %Negative Detection
                    top_result(i)=3;                %FN
                else                        %Positive Detection
                   if bboxOverlapRatio(top_truth(i,:),top_test(i,:))>=0.5 %75 overlap needed
                        top_result(i)=4;            %TP
                    else
                      top_result(i)=5;
                    end 
                end
            end
        end
    end
    top_matrix(1,1)=sum(top_result(:)==1);
    top_matrix(1,2)=sum(top_result(:)==2);
    top_matrix(2,1)=sum(top_result(:)==3);
    top_matrix(2,2)=sum(top_result(:)==4);
    top_filtered=sum(top_result(i)==5);
    top_matrix
     top_fpr=top_matrix(1,2)/(top_matrix(1,2)+top_matrix(1,1));
    top_tpr=top_matrix(2,2)/(top_matrix(2,2)+top_matrix(2,1));
    [top_fpr;top_tpr]
%     top_filtered
  
else
    top_matrix=zeros(2,2);
    top_matrix(2,1)=sum(~isnan(top_truth(:,1)))
end







% TPR=top_matrix(2,2)/(top_matrix(2,1)+top_matrix(2,2))
% FPR=top_matrix(1,2)/(top_matrix(1,1)+top_matrix(1,2))
        
        