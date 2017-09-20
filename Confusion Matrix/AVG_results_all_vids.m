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
%% Get total length of video
addpath(foldername);

reader = VideoReader(sprintf('%s_raw_60fps.mp4',foldername));
vid_length = reader.NumberOfFrames;
    
%% Student gt vs. alg
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

    FINAL = [final_face1; final_face2; final_face3; final_frame; final_shark; final_top; vid_acc vid_fp vid_fn sum(vid_overlap) sum(vid_union)];
