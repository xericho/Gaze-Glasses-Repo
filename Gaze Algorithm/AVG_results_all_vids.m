%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
restoredefaultpath

foldername = 'vid000';
look_duration = 6;

frame_gt_binary = []; frame_test_binary = []; frame_overlap = []; frame_union = [];
shark_gt_binary = []; shark_test_binary = []; shark_overlap = []; shark_union = [];
top_gt_binary = []; top_test_binary = []; top_overlap = []; top_union = []; 
face1_gt_binary = []; face1_test_binary = []; face1_overlap = []; face1_union = []; 
face2_gt_binary = []; face2_test_binary = []; face2_overlap = []; face2_union = []; 
face3_gt_binary = []; face3_test_binary = []; face3_overlap = []; face3_union = [];

%%
for i = 0:4
    restoredefaultpath
    foldername = sprintf('vid00%d',i);
    addpath(foldername);

    % Get total length of video
    reader = VideoReader(sprintf('%s_raw_60fps.mp4',foldername));
    vid_length = reader.NumberOfFrames;
    
    % Student gt vs. alg
    gt_name = sprintf('%s_gt_gaze_25-%d.mat', foldername, look_duration);
    test_name = sprintf('%s_test_gaze_25-%d.mat', foldername, look_duration);
    load(gt_name);
    load(test_name);
    
    % Convert gaze to a vector
    [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vec_ALL(frame_gt_gaze, frame_gaze, frame_gt_binary, frame_test_binary, frame_overlap, frame_union);
%     title('Photo');
    [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vec_ALL(shark_gt_gaze, shark_gaze, shark_gt_binary, shark_test_binary, shark_overlap, shark_union);
%     title('Shark');
    [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vec_ALL(top_gt_gaze, top_gaze, top_gt_binary, top_test_binary, top_overlap, top_union);
%     title('Top');
    [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vec_ALL(face1_gt_gaze, face1_gaze, face1_gt_binary, face1_test_binary, face1_overlap, face1_union);
%     title('Face 1');
    [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vec_ALL(face2_gt_gaze, face2_gaze, face2_gt_binary, face2_test_binary, face2_overlap, face2_union);
%     title('Face 2');
    [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vec_ALL(face3_gt_gaze, face3_gaze, face3_gt_binary, face3_test_binary, face3_overlap, face3_union);
%     title('Face 3');
    
    % Calc metric set #3
    [frame_accuracy, frame_fp, frame_fn] = gaze_metric_3(frame_overlap, frame_union, frame_test_binary, frame_gt_binary);
    [shark_accuracy, shark_fp, shark_fn] = gaze_metric_3(shark_overlap, shark_union, shark_test_binary, shark_gt_binary);
    [top_accuracy, top_fp, top_fn]       = gaze_metric_3(top_overlap, top_union, top_test_binary, top_gt_binary);
    [face1_accuracy, face1_fp, face1_fn] = gaze_metric_3(face1_overlap, face1_union, face1_test_binary, face1_gt_binary);
    [face2_accuracy, face2_fp, face2_fn] = gaze_metric_3(face2_overlap, face2_union, face2_test_binary, face2_gt_binary);
    [face3_accuracy, face3_fp, face3_fn] = gaze_metric_3(face3_overlap, face3_union, face3_test_binary, face3_gt_binary);

    % Group results
    final_frame = [frame_accuracy, frame_fp, frame_fn, sum(frame_overlap), sum(frame_union)];
    final_shark = [shark_accuracy, shark_fp, shark_fn, sum(shark_overlap), sum(shark_union)];
    final_top = [top_accuracy, top_fp, top_fn, sum(top_overlap), sum(top_union)];
    final_face1 = [face1_accuracy, face1_fp, face1_fn, sum(face1_overlap), sum(face1_union)];
    final_face2 = [face2_accuracy, face2_fp, face2_fn, sum(face2_overlap), sum(face2_union)];
    final_face3 = [face3_accuracy, face3_fp, face3_fn, sum(face3_overlap), sum(face3_union)];
end
    % Calc total vid results
    vid_overlap = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
    vid_union = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
    vid_acc = sum(vid_overlap)/sum(vid_union);
    
    vid_test = [frame_test_binary; top_test_binary; shark_test_binary; face1_test_binary; face2_test_binary; face3_test_binary;];
    vid_gt = [frame_gt_binary; top_gt_binary; shark_gt_binary; face1_gt_binary; face2_gt_binary; face3_gt_binary;];
    vid_fp = sum(vid_test & ~vid_gt)/sum(vid_test);
    vid_fn = sum(vid_gt & ~vid_test)/sum(vid_gt);

    %% Calc IOU and std dev
    
    total_face1_iou = [];
    total_face2_iou = [];
    total_face3_iou = [];
    total_frame_iou = [];
    total_shark_iou = [];
    total_top_iou = [];
    
    for ii = 0:4
        restoredefaultpath
        foldername = sprintf('vid00%d',ii);
        addpath(foldername);
        
        % Load GT bboxes
        load(sprintf('%s_gt_bbox.mat',foldername));

        % Load test bboxes
        frame_name = sprintf('%s_frame_90.csv',foldername);
        frame = ind_import(frame_name);       
        % frame = dilate(frame,1);                      
        shark_name = sprintf('%s_shark_50.csv',foldername);
        shark = ind_import(shark_name);
        % shark = dilate(shark,25);
        top_name = sprintf('%s_top_90.csv',foldername);
        top = ind_import(top_name);
        % top = dilate(top,10);

        load('face1.mat');
        face1 = squeeze(face1_identified)';
        face1 = face_expand(face1);
        load('face2.mat');
        face2 = squeeze(face2_identified)'; 
        face2 = face_expand(face2);   
        load('face3.mat');
        face3 = squeeze(face3_identified)';
        face3 = face_expand(face3);

        % pad with 0s
        if(strcmp(foldername,'vid002'))
            face1 = [face1; zeros(size(face2,1)-size(face1,1),4)]; 
        end
        if(strcmp(foldername,'vid003'))
            face2 = [face2; zeros(size(face1,1)-size(face2,1),4)];
        end
        if(strcmp(foldername,'vid004'))
            face2 = [face2; zeros(size(face1,1)-size(face2,1),4)];
            face3 = [face3; zeros(size(face1,1)-size(face3,1),4)];
        end
        % Expand csv bboxes to have a bbox for every frame
        % The csv bboxes are currently sampled every 5 frames

        % initialize
        frame_sample = zeros(size(frame,1), 4);
        shark_sample = zeros(size(shark,1), 4);
        top_sample   = zeros(size(top,1), 4);

        for i=1:size(frame,1)*5
            ref = 1+floor((i-1)/5);
            frame_sample(i,:) = frame(ref,:);
            shark_sample(i,:) = shark(ref,:);
            top_sample(i,:) = top(ref,:);
        end

        stop = min(size(face1,1),size(shark_sample,1));
        frame_iou = nan(stop,1);
        shark_iou = nan(stop,1);
        top_iou   = nan(stop,1);
        face1_iou = nan(stop,1);
        face2_iou = nan(stop,1);
        face3_iou = nan(stop,1);

        for i = 1:stop
            if ~isnan(frame_sample(i,1)) && ~isnan(frame_gt(i,1))
                frame_iou(i)=bboxOverlapRatio(frame_gt(i,:),frame_sample(i,:));
            end
            if ~isnan(shark_sample(i,1)) && ~isnan(shark_gt(i,1))
                shark_iou(i)=bboxOverlapRatio(shark_gt(i,:),shark_sample(i,:));
            end
            if ~isnan(top_sample(i,1)) && ~isnan(top_gt(i,1))
                top_iou(i)=bboxOverlapRatio(top_gt(i,:),top_sample(i,:));
            end
            if ~isnan(face1_gt(i,1)) && face1(i,1)~=0
                face1_iou(i)=bboxOverlapRatio(face1_gt(i,:),face1(i,:));
            end
            if ~isnan(face2_gt(i,1)) && face2(i,1)~=0
                face2_iou(i)=bboxOverlapRatio(face2_gt(i,:),face2(i,:));
            end
            if ~isnan(face3_gt(i,1)) && face3(i,1)~=0
                face3_iou(i)=bboxOverlapRatio(face3_gt(i,:),face3(i,:));
            end
        end
        
        total_face1_iou = [total_face1_iou; face1_iou];
        total_face2_iou = [total_face2_iou; face2_iou];
        total_face3_iou = [total_face3_iou; face3_iou];
        total_frame_iou = [total_frame_iou; frame_iou];
        total_shark_iou = [total_shark_iou; shark_iou];
        total_top_iou   = [total_top_iou; top_iou];
    end
    
    total_avg = nanmean([face1_iou;face2_iou;face3_iou;frame_iou;shark_iou;top_iou]);
    total_stddev = nanstd([face1_iou;face2_iou;face3_iou;frame_iou;shark_iou;top_iou]);
%%
    FINAL = [final_face1 nanmean(total_face1_iou) nanstd(total_face1_iou); final_face2 nanmean(total_face2_iou) nanstd(total_face2_iou); final_face3 nanmean(total_face3_iou) nanstd(total_face3_iou);...
             final_frame nanmean(total_frame_iou) nanstd(total_frame_iou); final_shark nanmean(total_shark_iou) nanstd(total_shark_iou); final_top nanmean(total_top_iou) nanstd(total_top_iou);...
             vid_acc vid_fp vid_fn sum(vid_overlap) sum(vid_union) total_avg total_stddev];
         