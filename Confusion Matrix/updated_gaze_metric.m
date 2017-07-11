%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all

addpath('Vid000');

load('vid000_gt_gaze.mat');
load('vid000_results_60-8.mat');

%% Convert gaze to a vector
[frame_gt_vec, frame_test_vec, frame_overlap, frame_union] = gaze2vec(frame_gt_gaze, frame_gaze);
title('Frame');
[shark_gt_vec, shark_test_vec, shark_overlap, shark_union] = gaze2vec(shark_gt_gaze, shark_gaze);
title('Shark');
[top_gt_vec, top_test_vec, top_overlap, top_union] = gaze2vec(top_gt_gaze, top_gaze);
title('Top');

%% Calculate matric 
frame_accuracy = sum(frame_overlap)/sum(frame_union);
frame_miss_detection = sum(frame_overlap)/sum(frame_gt_vec);
frame_fp = sum(frame_overlap)/sum(frame_test_vec);
a_frame = [frame_accuracy frame_fp frame_miss_detection];

shark_accuracy = sum(shark_overlap)/sum(shark_union);
shark_miss_detection = sum(shark_overlap)/sum(shark_gt_vec);
shark_fp = sum(shark_overlap)/sum(shark_test_vec);
a_shark = [shark_accuracy shark_fp shark_miss_detection];

top_accuracy = sum(top_overlap)/sum(top_union);
top_miss_detection = sum(top_overlap)/sum(top_gt_vec);
top_fp = sum(top_overlap)/sum(top_test_vec);
a_top = [top_accuracy top_fp top_miss_detection];