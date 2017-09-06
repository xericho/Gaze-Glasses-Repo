  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
foldername = 'vid004';
addpath(foldername);

index = 1;
look_duration = 6;
% for look_duration = 3:20
    gt_name = sprintf('%s_gt_gaze_25-%d.mat', foldername, look_duration);
    test_name = sprintf('%s_test_gaze_25-%d.mat', foldername, look_duration);
    load(gt_name);
    load(test_name);

    %% Convert gaze to a vector
    [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vec(frame_gt_gaze, frame_gaze);
    title('Frame');
    [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vec(shark_gt_gaze, shark_gaze);
    title('Shark');
    [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vec(top_gt_gaze, top_gaze);
    title('Top');
    [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vec(face1_gt_gaze, face1_gaze);
    title('Face 1');
    [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vec(face2_gt_gaze, face2_gaze);
    title('Face 2');
    [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vec(face3_gt_gaze, face3_gaze);
    title('Face 3');

    %% Calc metric set #3
    [frame_accuracy, frame_fp, frame_fn] = gaze_metric_3(frame_overlap, frame_union, frame_test_binary, frame_gt_binary);
    [shark_accuracy, shark_fp, shark_fn] = gaze_metric_3(shark_overlap, shark_union, shark_test_binary, shark_gt_binary);
    [top_accuracy, top_fp, top_fn]       = gaze_metric_3(top_overlap, top_union, top_test_binary, top_gt_binary);
    [face1_accuracy, face1_fp, face1_fn] = gaze_metric_3(face1_overlap, face1_union, face1_test_binary, face1_gt_binary);
    [face2_accuracy, face2_fp, face2_fn] = gaze_metric_3(face2_overlap, face2_union, face2_test_binary, face2_gt_binary);
    [face3_accuracy, face3_fp, face3_fn] = gaze_metric_3(face3_overlap, face3_union, face3_test_binary, face3_gt_binary);

    %% Save values
    total_frame_accuracy(index) = frame_accuracy;
    total_shark_accuracy(index) = shark_accuracy;
    total_top_accuracy(index)   = top_accuracy;
    total_face1_accuracy(index) = face1_accuracy;
    total_face2_accuracy(index) = face2_accuracy;
    total_face3_accuracy(index) = face3_accuracy;
    index = index + 1;
    
% end

%% Group results
final_frame = [frame_accuracy, frame_fp, frame_fn];
final_shark = [shark_accuracy, shark_fp, shark_fn];
final_top = [top_accuracy, top_fp, top_fn];
final_face1 = [face1_accuracy, face1_fp, face1_fn];
final_face2 = [face2_accuracy, face2_fp, face2_fn];
final_face3 = [face3_accuracy, face3_fp, face3_fn];
name = sprintf('%s_results',foldername);
% save(name,'final_frame','final_shark','final_top','final_face1','final_face2','final_face3');

%% Get total vid results
% dimensions have to match to use | or &
total_size = max([length(frame_overlap),length(top_overlap),length(shark_overlap), ...
                    length(face1_overlap),length(face2_overlap),length(face3_overlap)]);

% combine all gt binary vectors
vid_gt = [frame_gt_binary; zeros(total_size-length(frame_gt_binary),1)] | [top_gt_binary; zeros(total_size-length(top_gt_binary),1)] |...
         [shark_gt_binary; zeros(total_size-length(shark_gt_binary),1)] | [face1_gt_binary; zeros(total_size-length(face1_gt_binary),1)] |...
         [face2_gt_binary; zeros(total_size-length(face2_gt_binary),1)] | [face3_gt_binary; zeros(total_size-length(face3_gt_binary),1)];
     
% combine all test binary vectors
vid_test = [frame_test_binary; zeros(total_size-length(frame_test_binary),1)] | [top_test_binary; zeros(total_size-length(top_test_binary),1)] |...
           [shark_test_binary; zeros(total_size-length(shark_test_binary),1)] | [face1_test_binary; zeros(total_size-length(face1_test_binary),1)] |...
           [face2_test_binary; zeros(total_size-length(face2_test_binary),1)] | [face3_test_binary; zeros(total_size-length(face3_test_binary),1)];
     
% combine all overlaps
vid_overlap = [frame_overlap; zeros(total_size-length(frame_overlap),1)] | [top_overlap; zeros(total_size-length(top_overlap),1)] |...
              [shark_overlap; zeros(total_size-length(shark_overlap),1)] | [face1_overlap; zeros(total_size-length(face1_overlap),1)] |...
              [face2_overlap; zeros(total_size-length(face2_overlap),1)] | [face3_overlap; zeros(total_size-length(face3_overlap),1)];

% combine all unions
vid_union = [frame_union; zeros(total_size-length(frame_union),1)] | [top_union; zeros(total_size-length(top_union),1)] |...
            [shark_union; zeros(total_size-length(shark_union),1)] | [face1_union; zeros(total_size-length(face1_union),1)] |...
            [face2_union; zeros(total_size-length(face2_union),1)] | [face3_union; zeros(total_size-length(face3_union),1)];

vid_acc = sum(vid_overlap)/sum(vid_union);
vid_fp = sum(vid_test & ~vid_gt)/sum(vid_test);
vid_fn = sum(vid_gt & ~vid_test)/sum(vid_gt);

vid_overlap2 = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
vid_union2 = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
vid_acc2= sum(vid_overlap2)/sum(vid_union2);

%% Jack's way
overall_overlap = zeros(7763,1);
overall_union = zeros(7763,1);
test = zeros(7763,1);
for i=1:7763
    if face1_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    if face2_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    if face3_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    if frame_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    if shark_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    if top_overlap(i)==1
        overall_overlap(i)=overall_overlap(i)+1;
    end
    
   if face1_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end
    if face2_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end
    if face3_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end
    if frame_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end
    if shark_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end
    if top_union(i)==1
        overall_union(i)=overall_union(i)+1;
    end 
end

vid_acc3 = sum(overall_overlap)/sum(overall_union);

%% Graph
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