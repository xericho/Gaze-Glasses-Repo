%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script uses the csv bboxes and finds the RLE for analysis.
% It also overlay the bbox in the video for vizualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load csv files and dilate bboxes to account for error
close all
clear all
clc
% path of folder of video 0 which contains all the csv files for that video
addpath('Vid0')                    

frame = ind_import('frame_90_5fps.csv');
frame = dilate(frame,25);

shark = ind_import('shark_30_5fps.csv');
shark = dilate(shark,25);

top = ind_import('top_90_5fps.csv');
top = dilate(top,25);

%% Load video and gaze position
reader = VideoReader('vid0_60fps.mp4');
vid_frame_count = reader.NumberOfFrames;

[new_confidence,pos_x,pos_y] = clean_gaze_position('gaze_postions.csv', reader);

%% Expand csv bboxes to have a bbox for every frame
% The csv bboxes are currently sampled every 5 frames

% initialize
frame_sample = zeros(size(frame,1), 4);
shark_sample = zeros(size(shark,1), 4);
top_sample   = zeros(size(top,1), 4);

for i=1:size(frame,1)*5-1
    ref = 1+floor(i/5);
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
for i=1:size(new_confidence,2)-1
    ref=i;
    if new_confidence(i) >= 0.75            % filter out anything less than 75% confidence
        frame_check(i)=(pos_x(i)>=frame_sample(ref,1) && pos_x(i)<=frame_sample(ref,1)+frame_sample(ref,3)) && (pos_y(i)>=frame_sample(ref,2) && pos_y(i)<=frame_sample(ref,2)+frame_sample(ref,4));
        shark_check(i)=(pos_x(i)>=shark_sample(ref,1) && pos_x(i)<=shark_sample(ref,1)+shark_sample(ref,3)) && (pos_y(i)>=shark_sample(ref,2) && pos_y(i)<=shark_sample(ref,2)+shark_sample(ref,4));
        top_check(i)=(pos_x(i)>=top_sample(ref,1) && pos_x(i)<=top_sample(ref,1)+top_sample(ref,3)) && (pos_y(i)>=top_sample(ref,2) && pos_y(i)<=top_sample(ref,2)+top_sample(ref,4));
    end
end

 %% Gaze RLE
look_duration = 6;                              % let a look be at least 6 frames
frame_gaze = gaze_RLE(frame_check, look_duration);
shark_gaze = gaze_RLE(shark_check, look_duration);
top_gaze = gaze_RLE(top_check, look_duration);

% save('gaze_result.mat','frame_gaze_filtered','shark_gaze_filtered','top_gaze_filtered');
            



