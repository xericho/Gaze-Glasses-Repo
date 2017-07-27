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
addpath('Vid002');
% load csv bboxes for gt
gt = csvimport('vid002_gt_bbox.csv');

% extract bboxes
face1_gt = cell2matrix(gt(2:end,1:4));
face2_gt = cell2matrix(gt(2:end,5:8));
face3_gt = cell2matrix(gt(2:end,9:12));
top_gt   = cell2matrix(gt(2:end,13:16));
shark_gt = cell2matrix(gt(2:end,17:20));
frame_gt = cell2matrix(gt(2:end,21:24));

save('vid002_gt_bbox.mat','face2_gt','face3_gt','face1_gt','top_gt','shark_gt','frame_gt');

%% Load video and gaze position
reader = VideoReader('vid002-60fps.mp4');
vid_frame_count = reader.NumberOfFrames;

[new_confidence,pos_x,pos_y] = clean_gaze_position('vid002_gaze_positions.csv', reader);

%% Check if gaze is in the bbox for ground truth
if size(frame_gt,1) > size(new_confidence,2)
    max_length = size(new_confidence,2);
else
    max_length = size(frame_gt,1); 
end

conf = .75;
for i=1:max_length
    ref=i;
    if new_confidence(i) >= conf            % filter out anything less than 70% confidence
        frame_gt_binary(i)=(pos_x(i)>=frame_gt(ref,1) && pos_x(i)<=frame_gt(ref,1)+frame_gt(ref,3)) && (pos_y(i)>=frame_gt(ref,2) && pos_y(i)<=frame_gt(ref,2)+frame_gt(ref,4));
        shark_gt_binary(i)=(pos_x(i)>=shark_gt(ref,1) && pos_x(i)<=shark_gt(ref,1)+shark_gt(ref,3)) && (pos_y(i)>=shark_gt(ref,2) && pos_y(i)<=shark_gt(ref,2)+shark_gt(ref,4));
        top_gt_binary(i)  =(pos_x(i)>=top_gt(ref,1)   && pos_x(i)<=top_gt(ref,1)+top_gt(ref,3))     && (pos_y(i)>=top_gt(ref,2)   && pos_y(i)<=top_gt(ref,2)+top_gt(ref,4));
        face1_gt_binary(i)=(pos_x(i)>=face1_gt(ref,1) && pos_x(i)<=face1_gt(ref,1)+face1_gt(ref,3)) && (pos_y(i)>=face1_gt(ref,2) && pos_y(i)<=face1_gt(ref,2)+face1_gt(ref,4));
        face2_gt_binary(i)=(pos_x(i)>=face2_gt(ref,1) && pos_x(i)<=face2_gt(ref,1)+face2_gt(ref,3)) && (pos_y(i)>=face2_gt(ref,2) && pos_y(i)<=face2_gt(ref,2)+face2_gt(ref,4));
        face3_gt_binary(i)=(pos_x(i)>=face3_gt(ref,1) && pos_x(i)<=face3_gt(ref,1)+face3_gt(ref,3)) && (pos_y(i)>=face3_gt(ref,2) && pos_y(i)<=face3_gt(ref,2)+face3_gt(ref,4));
    end
%     if i >= 3502 || i <= 4001         % for vid001 only
%         continue 
%     end
end

% name = sprintf('vid000_gt_binary_%2.0f.mat',conf*100);
% save(name, 'frame_gt_binary', 'shark_gt_binary', 'top_gt_binary');

%% Convert to gaze using RLE
look_duration = 6;                              % let a look be at least 6 frames
for look_duration = 3:20
    frame_gt_gaze = gaze_RLE(frame_gt_binary, look_duration);
    shark_gt_gaze = gaze_RLE(shark_gt_binary, look_duration);
    top_gt_gaze   = gaze_RLE(top_gt_binary, look_duration);
    face1_gt_gaze = gaze_RLE(face1_gt_binary, look_duration);
    face2_gt_gaze = gaze_RLE(face2_gt_binary, look_duration);
    face3_gt_gaze = gaze_RLE(face3_gt_binary, look_duration);

    name = sprintf('vid002_gt_gaze_%2.0f-%d.mat',conf*100,look_duration);
    save(name,'frame_gt_gaze','shark_gt_gaze','top_gt_gaze','face1_gt_gaze','face2_gt_gaze','face3_gt_gaze');
end