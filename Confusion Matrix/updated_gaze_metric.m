%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
addpath('Vid002/25Conf');

index = 1;
look_duration = 6;
% for look_duration = 3:20
    gt_name = sprintf('vid002_gt_gaze_25-%d.mat', look_duration);
    test_name = sprintf('vid002_test_gaze_25-%d.mat', look_duration);
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
    [top_accuracy, top_fp, top_fn] = gaze_metric_3(top_overlap, top_union, top_test_binary, top_gt_binary);
    [face1_accuracy, face1_fp, face1_fn] = gaze_metric_3(face1_overlap, face1_union, face1_test_binary, face1_gt_binary);
    [face2_accuracy, face2_fp, face2_fn] = gaze_metric_3(face2_overlap, face2_union, face2_test_binary, face2_gt_binary);
    [face3_accuracy, face3_fp, face3_fn] = gaze_metric_3(face3_overlap, face3_union, face3_test_binary, face3_gt_binary);

    %% Save values
    total_frame_accuracy(index) = frame_accuracy;
    total_shark_accuracy(index) = shark_accuracy;
    total_top_accuracy(index) = top_accuracy;
    total_face1_accuracy(index) = face1_accuracy;
    total_face2_accuracy(index) = face2_accuracy;
    total_face3_accuracy(index) = face3_accuracy;
    index = index + 1;
% end

%% Graph
figure
plot(3:20, total_frame_accuracy);
title('Frame accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');

figure
plot(3:20, total_shark_accuracy);
title('Shark accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');

figure
plot(3:20, total_top_accuracy);
title('Top accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');

figure
plot(3:20, total_face1_accuracy);
title('Face 1 accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');

figure
plot(3:20, total_face2_accuracy);
title('Face 2 accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');

figure
plot(3:20, total_face3_accuracy);
title('Face 3 accuracy vs. look duration');
xlabel('Look duration'); ylabel('Accuracy');