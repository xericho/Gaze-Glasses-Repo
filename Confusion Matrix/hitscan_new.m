%% loading and dilation
close all
clear all
clc
addpath('Vid0')
gaze_import
frame=ind_import('frame_90_5fps.csv');
% frame=[cell2mat(frame(:,3:6));[0 0 0 0]];
frame=dilate(frame,25);
shark=ind_import('shark_30_5fps.csv');
% shark=[cell2mat(shark(:,3:6));[0 0 0 0]];
shark=dilate(shark,25);
top=ind_import('top_90_5fps.csv');
% top=[cell2mat(top(:,3:6));[0 0 0 0]];
top=dilate(top,25);
%%
% addpath('Vid0')
reader=VideoReader('Vid0-60Fps.mp4');
height=reader.height;
width=reader.width;
vid_frame_count=floor(reader.duration*reader.framerate);

%% assign csv to frames
frame_sample=zeros(size(top,1),4);
shark_sample=frame_sample;
top_sample=frame_sample;

for i=1:size(frame,1)*5-1
    ref=1+floor(i/5);
    frame_sample(i,:)=frame(ref,:);
    shark_sample(i,:)=shark(ref,:);
    top_sample(i,:)=top(ref,:);
end

%% visualize

[new_confidence,pos_x,pos_y]=clean_gaze_position('Vid0_gaze.csv');
w=VideoWriter('output.mp4','MPEG-4');
w.FrameRate=60;
open(w)

for i=1:1:size(frame_sample,1)
    img=read(reader,i);
    imshow(img)
    rectangle('Position',[pos_x(i)-5,pos_y(i)-5,10,10],'FaceColor','[0 0.5 0.5]');
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
%     pause
    f=getframe;
    writeVideo(w,f);
end    
 close(w)   

%% gaze confidence filtering
for i=1:size(new_confidence,2)-1
    ref=i;
    if new_confidence(i)>=0.75
        frame_check(i)=(pos_x(i)>=frame_sample(ref,1) && pos_x(i)<=frame_sample(ref,1)+frame_sample(ref,3)) && (pos_y(i)>=frame_sample(ref,2) && pos_y(i)<=frame_sample(ref,2)+frame_sample(ref,4));
        shark_check(i)=(pos_x(i)>=shark_sample(ref,1) && pos_x(i)<=shark_sample(ref,1)+shark_sample(ref,3)) && (pos_y(i)>=shark_sample(ref,2) && pos_y(i)<=shark_sample(ref,2)+shark_sample(ref,4));
        top_check(i)=(pos_x(i)>=top_sample(ref,1) && pos_x(i)<=top_sample(ref,1)+top_sample(ref,3)) && (pos_y(i)>=top_sample(ref,2) && pos_y(i)<=top_sample(ref,2)+top_sample(ref,4));
    end
end
    duration=6;
 %% gaze RLE   
[length first last logic]=SplitVec(frame_check,[],'length','first','last', 'firstelem');
logic=double(logic');
compare=[length logic first last];
frame_index=1;
    for i=1:size(first,1)
        if compare(i,1)>=duration
            frame_gaze(frame_index,:)=compare(i,:);
            frame_index=frame_index+1;
        end
    end
    
    [length first last logic]=SplitVec(shark_check,[],'length','first','last', 'firstelem');
logic=double(logic');
compare=[length logic first last];
shark_index=1;
    for i=1:size(first,1)
        if compare(i,1)>=duration
            shark_gaze(shark_index,:)=compare(i,:);
            shark_index=shark_index+1;
        end
    end
    
    [length first last logic]=SplitVec(top_check,[],'length','first','last', 'firstelem');
logic=double(logic');
compare=[length logic first last];
top_index=1;
    for i=1:size(first,1)
        if compare(i,1)>=duration
            top_gaze(top_index,:)=compare(i,:);
            top_index=top_index+1;
        end
    end
    %% frame 
    start=min(find(frame_gaze(:,2)==1));
    frame_index=1;
    for i=start:size(frame_gaze,1)
        if i==1 && frame_gaze(1,2)==1   %initialize 1
            frame_gaze_filtered(frame_index,:)=frame_gaze(i,:);
            frame_index=frame_index+1;
        elseif frame_gaze(i,2)==1 && frame_gaze(i-1,2)==0  %0 to 1
            frame_gaze_filtered(frame_index,:)=frame_gaze(i,:);
        elseif frame_gaze(i,2)==1 && frame_gaze(i-1,2)==1  %1 to 1
            frame_gaze_filtered(frame_index,4)=frame_gaze(i,4);
        elseif frame_gaze(i,2)==0 && frame_gaze(i-1,2)==1  %1 to 0
            frame_index=frame_index+1;
        end
    end
        frame_gaze_filtered=circshift(frame_gaze_filtered,-2,2);
        frame_gaze_filtered(:,3)=frame_gaze_filtered(:,2)-frame_gaze_filtered(:,1)+1;
        frame_gaze_filtered(:,4)=[];
    %% shark
    start=min(find(shark_gaze(:,2)==1));
    shark_index=1;
    for i=start:size(shark_gaze,1)
        if i==1 && shark_gaze(1,2)==1   %initialize 1
            shark_gaze_filtered(shark_index,:)=shark_gaze(i,:);
            shark_index=shark_index+1;
        elseif shark_gaze(i,2)==1 && shark_gaze(i-1,2)==0  %0 to 1
            shark_gaze_filtered(shark_index,:)=shark_gaze(i,:);
        elseif shark_gaze(i,2)==1 && shark_gaze(i-1,2)==1  %1 to 1
            shark_gaze_filtered(shark_index,4)=shark_gaze(i,4);
        elseif shark_gaze(i,2)==0 && shark_gaze(i-1,2)==1  %1 to 0
            shark_index=shark_index+1;
        end
    end
        shark_gaze_filtered=circshift(shark_gaze_filtered,-2,2);
        shark_gaze_filtered(:,3)=shark_gaze_filtered(:,2)-shark_gaze_filtered(:,1)+1;
        shark_gaze_filtered(:,4)=[];
            %% top
    start=min(find(top_gaze(:,2)==1));
    top_index=1;
    for i=start:size(top_gaze,1)
        if i==1 && top_gaze(1,2)==1   %initialize 1
            top_gaze_filtered(top_index,:)=top_gaze(i,:);
            top_index=top_index+1;
        elseif top_gaze(i,2)==1 && top_gaze(i-1,2)==0  %0 to 1
            top_gaze_filtered(top_index,:)=top_gaze(i,:);
        elseif top_gaze(i,2)==1 && top_gaze(i-1,2)==1  %1 to 1
            top_gaze_filtered(top_index,4)=top_gaze(i,4);
        elseif top_gaze(i,2)==0 && top_gaze(i-1,2)==1  %1 to 0
            top_index=top_index+1;
        end
    end
        top_gaze_filtered=circshift(top_gaze_filtered,-2,2);
        top_gaze_filtered(:,3)=top_gaze_filtered(:,2)-top_gaze_filtered(:,1)+1;
        top_gaze_filtered(:,4)=[];
        
        save('gaze_result.mat','frame_gaze_filtered','shark_gaze_filtered','top_gaze_filtered');
            



