close all
clear all
clc
addpath('Vid0')
gaze_import
frame=test_import('frame_90.csv');
frame=[cell2mat(frame(:,3:6));[0 0 0 0]];
shark=test_import('shark_30.csv');
shark=[cell2mat(shark(:,3:6));[0 0 0 0]];
top=test_import('top_90.csv');
top=[cell2mat(top(:,3:6));[0 0 0 0]];


reader=VideoReader('Vid0.mp4');
height=reader.height;
width=reader.width;
vid_frame_count=floor(reader.duration*reader.framerate);

frame_sample=zeros(size(top,1),4);
shark_sample=frame_sample;
top_sample=frame_sample;

% for i=1:vid_frame_count
%     ref=1+floor(i/30);
%     frame_sample(i,:)=frame(ref,:);
%     shark_sample(i,:)=shark(ref,:);
%     top_sample(i,:)=top(ref,:);
% end

for i=1:size(frame,1)
    start=1+30*(i-1);
    stop=start+29;
    for index=start:stop
    frame_sample(index,:)=frame(i,:);
    shark_sample(index,:)=shark(i,:);
    top_sample(index,:)=top(i,:);
    end
end
%%

[confidence, norm_pos_x, norm_pos_y] = clean_gaze_position('gaze_postions.csv');
% pos_x=norm_pos_x(110:2:end)*width;
% pos_y=height-norm_pos_y(110:2:end)*height;
finish=size(confidence,1);
% start_offset=1;
% end_offset=0;
% norm_pos_x=norm_pos_x(start_offset:finish-end_offset);
% norm_pos_y=norm_pos_y(start_offset:finish-end_offset);
pos_x=resample(norm_pos_x,vid_frame_count,size(norm_pos_x,1))*width;
pos_y=height-resample(norm_pos_y,vid_frame_count,size(norm_pos_y,1))*height;
% confidence_sample=resample(confidence,vid_frame_count,size(confidence,1));
% save('gaze.mat','norm_pos_x','norm_pos_y','confidence')
% clearvars norm_pos_x norm_pos_y confidence 

%%
for i=1:1:vid_frame_count
    img=read(reader,i);
    imshow(img)
    rectangle('Position',[pos_x(i)-5,pos_y(i)-5,10,10],'FaceColor','[0 0.5 0.5]');
    title(i);
    pause(0.01)
end    
    

%%
for i=1:size(frame_sample,1)
    ref=i;
    if confidence_sample(i)>=0.75
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
        frame_gaze_final=circshift(frame_gaze_filtered,-2,2);
        frame_gaze_final(:,3)=frame_gaze_final(:,2)-frame_gaze_final(:,1);
        frame_gaze_final(:,4)=[];
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
        shark_gaze_final=circshift(shark_gaze_filtered,-2,2);
        shark_gaze_final(:,3)=shark_gaze_final(:,2)-shark_gaze_final(:,1);
        shark_gaze_final(:,4)=[];
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
        top_gaze_final=circshift(top_gaze_filtered,-2,2);
        top_gaze_final(:,3)=top_gaze_final(:,2)-top_gaze_final(:,1);
        top_gaze_final(:,4)=[];
        
        save('vid0_gaze_test.mat','frame_gaze_final','shark_gaze_final','top_gaze_final');
            



