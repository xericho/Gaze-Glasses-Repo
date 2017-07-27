%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script uses the csv bboxes and finds the RLE for analysis.
% It also overlay the bbox in the video for vizualization
% 
% Functions required: 1) gaze_RLE.m 
%                     2) ind_import.m
%                     3) dilate.m
%                     4) clean_gaze_position.m
%
% Files required: - a video
%                 - CSV bboxes of the faces/objects from video
%                 - the gaze position from video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load csv files and dilate bboxes to account for error
% close all
% clear all
% clc

% path of folder which contains all the files for that video
addpath('Vid002')

frame = ind_import('frame_90_5fps.csv');        % load csv file
frame = dilate(frame,1);                       % dilate bbox by 25%

shark = ind_import('shark_30_5fps.csv');
shark = dilate(shark,25);

top = ind_import('top_90_5fps.csv');
top = dilate(top,10);

load('face1.mat');
face1 = squeeze(face1_identified)';
load('face2.mat');
face2 = squeeze(face2_identified)';
load('face3.mat');
face3 = squeeze(face3_identified)';

%% Load video and gaze position
reader = VideoReader('vid002-60fps.mp4');
vid_frame_count = reader.NumberOfFrames;

[new_confidence,pos_x,pos_y] = clean_gaze_position('vid002_gaze_positions.csv', reader);

%%
% w=VideoWriter('output_vid001.mp4','MPEG-4');
% w.FrameRate=60;
% open(w)
for i=3490:1:size(new_confidence,2)
    img = read(reader,i);               % read a frame
    imshow(img)                         % show frame
    % plot gaze position
    rectangle('Position',[pos_x(i)-5,pos_y(i)-5,10,10],'FaceColor','[0 0.5 0.5]');
    % plot bboxes of objects
    if ~isnan(face1_gt(i,1))
        rectangle('Position',face1_gt(i,:),'EdgeColor','r','LineWidth',2,'LineStyle','--');
    end
    if ~isnan(face2_gt(i,1))
        rectangle('Position',face2_gt(i,:),'EdgeColor','b','LineWidth',3,'LineStyle','--');
    end
    if ~isnan(face3_gt(i,1))
        rectangle('Position',face3_gt(i,:),'EdgeColor','g','LineWidth',3,'LineStyle','--');
    end
    if ~isnan(frame_gt(i,1))
        rectangle('Position',frame_gt(i,:),'EdgeColor','g','LineWidth',3,'LineStyle','--');
        end
    if ~isnan(top_gt(i,1))
        rectangle('Position',top_gt(i,:),'EdgeColor','g','LineWidth',3,'LineStyle','--');
        end
    if ~isnan(shark_gt(i,1))
        rectangle('Position',shark_gt(i,:),'EdgeColor','g','LineWidth',3,'LineStyle','--');
    end
    title(i);
%     f=getframe;
%     writeVideo(w,f);

    pause(.000000000000000001)
end    

%% Expand csv bboxes to have a bbox for every frame
% The csv bboxes are currently sampled every 5 frames

% initialize
frame_sample = zeros(size(frame,1), 4);
shark_sample = zeros(size(shark,1), 4);
top_sample   = zeros(size(top,1), 4);

for i=1:size(frame,1)*5-1
    ref = 1+floor(i/5);
%     if i >= 3502 && i <= 4001
%         continue 
%     end
    frame_sample(i,:) = frame(ref,:);
    shark_sample(i,:) = shark(ref,:);
    top_sample(i,:) = top(ref,:);
end

%% Overlay bbox and gaze position onto video

% w=VideoWriter('output.mp4','MPEG-4');
% w.FrameRate=60;
% open(w)

for i=1:1:size(frame_sample,1)
    img = read(reader,i);               % read a frame
    imshow(img)                         % show frame
    % plot gaze position
    rectangle('Position',[pos_x(i)-5,pos_y(i)-5,10,10],'FaceColor','[0 0.5 0.5]');
    % plot bboxes of objects
    if ~isnan(frame_sample(i,1))
        rectangle('Position',frame_sample(i,:),'EdgeColor','r','LineWidth',2,'LineStyle','--');
    end
    if ~isnan(shark_sample(i,1))
        rectangle('Position',shark_sample(i,:),'EdgeColor','b','LineWidth',3,'LineStyle','--');
    end
    if ~isnan(top_sample(i,1))
        rectangle('Position',top_sample(i,:),'EdgeColor','g','LineWidth',3,'LineStyle','--');
    end
    title(i);
    pause
%     f=getframe;
%     writeVideo(w,f);
end    
%  close(w)   

%% Check if gaze is in bbox
% Sometimes one is bigger than the other so use the smaller one to avoid error
if size(frame_sample,1) > size(new_confidence,2)
    max_length = size(new_confidence,2);
else
    max_length = size(frame_sample,1); 
end

conf = .25;
for i=1:max_length
    ref=i;
    if new_confidence(i) >= conf            % filter out anything less than confidence
        frame_binary(i)=(pos_x(i)>=frame_sample(ref,1) && pos_x(i)<=frame_sample(ref,1)+frame_sample(ref,3)) && (pos_y(i)>=frame_sample(ref,2) && pos_y(i)<=frame_sample(ref,2)+frame_sample(ref,4));
        shark_binary(i)=(pos_x(i)>=shark_sample(ref,1) && pos_x(i)<=shark_sample(ref,1)+shark_sample(ref,3)) && (pos_y(i)>=shark_sample(ref,2) && pos_y(i)<=shark_sample(ref,2)+shark_sample(ref,4));
        top_binary(i)=(pos_x(i)>=top_sample(ref,1) && pos_x(i)<=top_sample(ref,1)+top_sample(ref,3)) && (pos_y(i)>=top_sample(ref,2) && pos_y(i)<=top_sample(ref,2)+top_sample(ref,4));
        face1_binary(i)=(pos_x(i)>=face1(ref,1) && pos_x(i) <= face1(ref,1) + face1(ref,3)) && (pos_y(i)>= face1(ref,2) && pos_y(i) <= face1(ref,2)+face1(ref,4));
        face2_binary(i)=(pos_x(i)>=face2(ref,1) && pos_x(i) <= face2(ref,1) + face2(ref,3)) && (pos_y(i)>= face2(ref,2) && pos_y(i) <= face2(ref,2)+face2(ref,4));
        face3_binary(i)=(pos_x(i)>=face3(ref,1) && pos_x(i) <= face3(ref,1) + face3(ref,3)) && (pos_y(i)>= face3(ref,2) && pos_y(i) <= face3(ref,2)+face3(ref,4));
    end
end

%% Gaze RLE
look_duration = 6;                              % let a look be at least 6 frames
for look_duration = 3:20
    frame_gaze = gaze_RLE(frame_binary, look_duration);
    shark_gaze = gaze_RLE(shark_binary, look_duration);
    top_gaze   = gaze_RLE(top_binary, look_duration);
    face1_gaze = gaze_RLE(face1_binary, look_duration);
    face2_gaze = gaze_RLE(face2_binary, look_duration);
    face3_gaze = gaze_RLE(face3_binary, look_duration);

    name = sprintf('vid002_test_gaze_%2.0f-%d.mat',conf*100,look_duration);
    save(name,'frame_gaze','shark_gaze','top_gaze','face1_gaze','face2_gaze','face3_gaze');
end


        
