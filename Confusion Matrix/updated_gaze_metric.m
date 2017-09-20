%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
restoredefaultpath

%% What data do you want to extract?
% Student gt vs alg?
student_gt = true;  
% Leanne gt vs alg?
leanne_gt = false;
% Compare student gt and Leanne gt?
compare_gts = false;     % can only run if prev variables are true

foldername = 'vid000';
look_duration = 6;

%% Get total length of video
addpath(foldername);

reader = VideoReader(sprintf('%s_raw_60fps.mp4',foldername));
vid_length = reader.NumberOfFrames;
    
%% Student gt vs. alg
if(student_gt)
    gt_name = sprintf('%s_gt_gaze_25-%d.mat', foldername, look_duration);
    test_name = sprintf('%s_test_gaze_25-%d.mat', foldername, look_duration);
    load(gt_name);
    load(test_name);
    
    % Convert gaze to a vector
    [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vec(frame_gt_gaze, frame_gaze, vid_length);
    title('Photo');
    [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vec(shark_gt_gaze, shark_gaze, vid_length);
    title('Shark');
    [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vec(top_gt_gaze, top_gaze, vid_length);
    title('Top');
    [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vec(face1_gt_gaze, face1_gaze, vid_length);
    title('Face 1');
    [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vec(face2_gt_gaze, face2_gaze, vid_length);
    title('Face 2');
    [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vec(face3_gt_gaze, face3_gaze, vid_length);
    title('Face 3');
    
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
    
    % Calc total vid results
    vid_overlap = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
    vid_union = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
    vid_acc= sum(vid_overlap)/sum(vid_union);

    vid_test = [frame_test_binary; top_test_binary; shark_test_binary; face1_test_binary; face2_test_binary; face3_test_binary;];
    vid_gt = [frame_gt_binary; top_gt_binary; shark_gt_binary; face1_gt_binary; face2_gt_binary; face3_gt_binary;];
    vid_fp = sum(vid_test & ~vid_gt)/sum(vid_test);
    vid_fn = sum(vid_gt & ~vid_test)/sum(vid_gt);
end

%% Leanne gt vs alg
if(leanne_gt)
    test_name = sprintf('%s_test_gaze_25-%d.mat', foldername, look_duration);
    load(test_name);
    load(sprintf('%s_leanne_gt_gaze.mat',foldername));
    
    % Convert gaze to a vector
    [frame_gt_binary2, frame_test_binary2, frame_overlap2, frame_union2] = gaze2vec(frame_leanne_gt_gaze, frame_gaze, vid_length);
    title('Photo');
    [shark_gt_binary2, shark_test_binary2, shark_overlap2, shark_union2] = gaze2vec(shark_leanne_gt_gaze, shark_gaze, vid_length);
    title('Shark');
    [top_gt_binary2, top_test_binary2, top_overlap2, top_union2] = gaze2vec(top_leanne_gt_gaze, top_gaze, vid_length);
    title('Top');
    [face1_gt_binary2, face1_test_binary2, face1_overlap2, face1_union2] = gaze2vec(face1_leanne_gt_gaze, face1_gaze, vid_length);
    title('Face 1');
    [face2_gt_binary2, face2_test_binary2, face2_overlap2, face2_union2] = gaze2vec(face2_leanne_gt_gaze, face2_gaze, vid_length);
    title('Face 2');
    [face3_gt_binary2, face3_test_binary2, face3_overlap2, face3_union2] = gaze2vec(face3_leanne_gt_gaze, face3_gaze, vid_length);
    title('Face 3');
    
    % Calc metric set #3
    [frame_accuracy2, frame_fp2, frame_fn2] = gaze_metric_3(frame_overlap2, frame_union2, frame_test_binary2, frame_gt_binary2);
    [shark_accuracy2, shark_fp2, shark_fn2] = gaze_metric_3(shark_overlap2, shark_union2, shark_test_binary2, shark_gt_binary2);
    [top_accuracy2, top_fp2, top_fn2]       = gaze_metric_3(top_overlap2, top_union2, top_test_binary2, top_gt_binary2);
    [face1_accuracy2, face1_fp2, face1_fn2] = gaze_metric_3(face1_overlap2, face1_union2, face1_test_binary2, face1_gt_binary2);
    [face2_accuracy2, face2_fp2, face2_fn2] = gaze_metric_3(face2_overlap2, face2_union2, face2_test_binary2, face2_gt_binary2);
    [face3_accuracy2, face3_fp2, face3_fn2] = gaze_metric_3(face3_overlap2, face3_union2, face3_test_binary2, face3_gt_binary2);

    % Group results
    final_frame2 = [frame_accuracy2, frame_fp2, frame_fn2, sum(frame_overlap2), sum(frame_union2)];
    final_shark2 = [shark_accuracy2, shark_fp2, shark_fn2, sum(shark_overlap2), sum(shark_union2)];
    final_top2   = [top_accuracy2, top_fp2, top_fn2, sum(top_overlap2), sum(top_union2)];
    final_face1_2 = [face1_accuracy2, face1_fp2, face1_fn2, sum(face1_overlap2), sum(face1_union2)];
    final_face2_2 = [face2_accuracy2, face2_fp2, face2_fn2, sum(face2_overlap2), sum(face2_union2)];
    final_face3_2 = [face3_accuracy2, face3_fp2, face3_fn2, sum(face3_overlap2), sum(face3_union2)];
    
    % Calc total vid results
    vid_overlap2 = [frame_overlap2; top_overlap2; shark_overlap2; face1_overlap2; face2_overlap2; face3_overlap2];
    vid_union2 = [frame_union2; top_union2; shark_union2; face1_union2; face2_union2; face3_union2];
    vid_acc2 = sum(vid_overlap2)/sum(vid_union2);

    vid_test2 = [frame_test_binary2; top_test_binary2; shark_test_binary2; face1_test_binary2; face2_test_binary2; face3_test_binary2;];
    vid_gt2 = [frame_gt_binary2; top_gt_binary2; shark_gt_binary2; face1_gt_binary2; face2_gt_binary2; face3_gt_binary2;];
    vid_fp2 = sum(vid_test2 & ~vid_gt2)/sum(vid_test2);
    vid_fn2 = sum(vid_gt2 & ~vid_test2)/sum(vid_gt2);

    FINAL2 = [final_face1_2; final_face2_2; final_face3_2; final_frame2; final_shark2; final_top2; vid_acc2 vid_fp2 vid_fn2 sum(vid_overlap2) sum(vid_union2)];
end

%% Saving results
name = sprintf('%s_results',foldername); 
% save(name,'final_frame','final_shark','final_top','final_face1','final_face2','final_face3');

%% Calculating the avg IOU and std dev
if(student_gt)
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

    load(sprintf('%s_face1.mat',foldername));
    face1 = squeeze(face1_identified)';
    face1 = face_expand(face1);
    load(sprintf('%s_face2.mat',foldername));
    face2 = squeeze(face2_identified)';
    face12 = face_expand(face2);
    load(sprintf('%s_face3.mat',foldername));
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
    
    total_avg = nanmean([face1_iou;face2_iou;face3_iou;frame_iou;shark_iou;top_iou]);
    total_stddev = nanstd([face1_iou;face2_iou;face3_iou;frame_iou;shark_iou;top_iou]);
%     misses = [sum(face1_iou==0); sum(face2_iou==0); sum(face3_iou==0); sum(frame_iou==0); sum(shark_iou==0); sum(top_iou==0)];

    FINAL = [final_face1 nanmean(face1_iou) nanstd(face1_iou); final_face2 nanmean(face2_iou) nanstd(face2_iou); final_face3 nanmean(face3_iou) nanstd(face3_iou);...
             final_frame nanmean(frame_iou) nanstd(frame_iou); final_shark nanmean(shark_iou) nanstd(shark_iou); final_top nanmean(top_iou) nanstd(top_iou);...
             vid_acc vid_fp vid_fn sum(vid_overlap) sum(vid_union) total_avg total_stddev];

end
%% Graphing student gt vs. Leanne gt
if(compare_gts)
    GT_graph(face1_gt_gaze, face1_leanne_gt_gaze, vid_length); title('Face 1');
    GT_graph(face2_gt_gaze, face2_leanne_gt_gaze, vid_length); title('Face 2');
    GT_graph(face3_gt_gaze, face3_leanne_gt_gaze, vid_length); title('Face 3');
    GT_graph(frame_gt_gaze, frame_leanne_gt_gaze, vid_length); title('Photo');
    GT_graph(top_gt_gaze, top_leanne_gt_gaze, vid_length);     title('Top');
    GT_graph(shark_gt_gaze, shark_leanne_gt_gaze, vid_length); title('Shark');
end
%% Graph old
% figure
% plot(3:20, total_frame_accuracy);
% title('Frame accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');
% 
% figure
% plot(3:20, total_shark_accuracy);
% title('Shark accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');
% 
% figure
% plot(3:20, total_top_accuracy);
% title('Top accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');
% 
% figure
% plot(3:20, total_face1_accuracy);
% title('Face 1 accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');
% 
% figure
% plot(3:20, total_face2_accuracy);
% title('Face 2 accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');
% 
% figure
% plot(3:20, total_face3_accuracy);
% title('Face 3 accuracy vs. look duration');
% xlabel('Look duration'); ylabel('Accuracy');