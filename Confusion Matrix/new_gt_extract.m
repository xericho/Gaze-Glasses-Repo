%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script converts the gt bboxes to looks
% Requires cell2matrix.m function
% 
% Functions required: 1) gaze_RLE.m 
%                     2) clean_gaze_position.m
%                     3) cell2matrix.m
%
% Files required: - a video
%                 - CSV GT bboxes of the faces/objects from video
%                 - the gaze position from video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load files
addpath('Vid000');
% load csv bboxes for gt
gt = csvimport('vid000_gt.csv');

% extract bboxes
face1_gt = cell2matrix(gt(2:end,1:4));
face2_gt = cell2matrix(gt(2:end,5:8));
face3_gt = cell2matrix(gt(2:end,9:12));
top_gt   = cell2matrix(gt(2:end,13:16));
shark_gt = cell2matrix(gt(2:end,17:20));
frame_gt = cell2matrix(gt(2:end,21:24));

% save('official_vid000_gt.mat','face2_gt','face3_gt','face1_gt','top_gt','shark_gt','frame_gt');

%% Load video and gaze position
reader = VideoReader('vid000-60fps.mp4');
vid_frame_count = reader.NumberOfFrames;

[new_confidence,pos_x,pos_y] = clean_gaze_position('vid000_gaze_positions.csv', reader);

%% Check if gaze is in the bbox for ground truth
if size(frame_gt,1) > size(new_confidence,2)
    max_length = size(new_confidence,2);
else
    max_length = size(frame_gt,1); 
end

for i=1:max_length
    ref=i;
    if new_confidence(i) >= 0.7            % filter out anything less than 70% confidence
        frame_gt_check(i)=(pos_x(i)>=frame_gt(ref,1) && pos_x(i)<=frame_gt(ref,1)+frame_gt(ref,3)) && (pos_y(i)>=frame_gt(ref,2) && pos_y(i)<=frame_gt(ref,2)+frame_gt(ref,4));
        shark_gt_check(i)=(pos_x(i)>=shark_gt(ref,1) && pos_x(i)<=shark_gt(ref,1)+shark_gt(ref,3)) && (pos_y(i)>=shark_gt(ref,2) && pos_y(i)<=shark_gt(ref,2)+shark_gt(ref,4));
        top_gt_check(i)  =(pos_x(i)>=top_gt(ref,1)   && pos_x(i)<=top_gt(ref,1)+top_gt(ref,3))     && (pos_y(i)>=top_gt(ref,2)   && pos_y(i)<=top_gt(ref,2)+top_gt(ref,4));
    end
end

%% Convert to gaze using RLE
look_duration = 6;                              % let a look be at least 6 frames
frame_gt_gaze = gaze_RLE(frame_gt_check, look_duration);
shark_gt_gaze = gaze_RLE(shark_gt_check, look_duration);
top_gt_gaze   = gaze_RLE(top_gt_check, look_duration);

save('vid000_gt_gaze','frame_gt_gaze','shark_gt_gaze','top_gt_gaze');