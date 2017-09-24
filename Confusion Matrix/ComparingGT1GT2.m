%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
restoredefaultpath

foldername = 'vid004';
addpath(foldername);
addpath(sprintf('%s/Results',foldername));

%% What do you want to compare?
% Choose only ONE to be true

GT1 = false;             % GT-1 vs. alg
GT2 = true;            % GT-2 gt vs. alg
compare_gts = false;    % GT-1 vs. GT-2

% Save the results?
save_data = true;

%% Get total length of video
reader = VideoReader(sprintf('%s_raw_60fps.mp4',foldername));
vid_length = reader.NumberOfFrames;

RESULTS = [];

%% Get accuracy for GT-1 (student) vs Alg
if(GT1)
    for exit = 5:20
        for entry = 5:20
            % load student gt
            gt_name = sprintf('%s_gt_gaze_%d-%d.mat', foldername, entry, exit);
            load(gt_name);
            % load alg data
            test_name = sprintf('%s_test_gaze_%d-%d.mat', foldername, entry, exit);
            load(test_name);

            % Convert gaze to a vector
            [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vecNOGRAPH(frame_gt_gaze, frame_gaze, vid_length);
            [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vecNOGRAPH(shark_gt_gaze, shark_gaze, vid_length);
            [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vecNOGRAPH(top_gt_gaze, top_gaze, vid_length);
            [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vecNOGRAPH(face1_gt_gaze, face1_gaze, vid_length);
            [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vecNOGRAPH(face2_gt_gaze, face2_gaze, vid_length);
            [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vecNOGRAPH(face3_gt_gaze, face3_gaze, vid_length);

            % Calc metric set #3
            [frame_accuracy, frame_fp, frame_fn] = gaze_metric_3(frame_overlap, frame_union, frame_test_binary, frame_gt_binary);
            [shark_accuracy, shark_fp, shark_fn] = gaze_metric_3(shark_overlap, shark_union, shark_test_binary, shark_gt_binary);
            [top_accuracy, top_fp, top_fn]       = gaze_metric_3(top_overlap, top_union, top_test_binary, top_gt_binary);
            [face1_accuracy, face1_fp, face1_fn] = gaze_metric_3(face1_overlap, face1_union, face1_test_binary, face1_gt_binary);
            [face2_accuracy, face2_fp, face2_fn] = gaze_metric_3(face2_overlap, face2_union, face2_test_binary, face2_gt_binary);
            [face3_accuracy, face3_fp, face3_fn] = gaze_metric_3(face3_overlap, face3_union, face3_test_binary, face3_gt_binary);

            % Calc total vid results
            vid_overlap = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
            vid_union = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
            vid_acc= sum(vid_overlap)/sum(vid_union);

            vid_test = [frame_test_binary; top_test_binary; shark_test_binary; face1_test_binary; face2_test_binary; face3_test_binary;];
            vid_gt = [frame_gt_binary; top_gt_binary; shark_gt_binary; face1_gt_binary; face2_gt_binary; face3_gt_binary;];
            vid_fp = sum(vid_test & ~vid_gt)/sum(vid_test);
            vid_fn = sum(vid_gt & ~vid_test)/sum(vid_gt);

            RESULTS(exit,entry) = vid_acc;
        end
    end
    max_value = max(RESULTS(RESULTS>0));
    [row, col] = find(RESULTS == max(RESULTS(RESULTS>0)));
    if(save_data)
        % Saving results
        name = sprintf('%s_studentVSalg_results.mat',foldername); 
        save(name,'RESULTS','max_value','row','col');
    end
end
%% Get accuracy for Alg vs GT-2 (Leanne)
if(GT2)
    % load leanne gt
    load(sprintf('%s_leanne_gt_gaze.mat',foldername));
    for exit = 5:20
        for entry = 5:20
            
            test_name = sprintf('%s_test_gaze_%d-%d.mat', foldername, entry, exit);
            load(test_name);
            
            % Convert gaze to a vector
            [frame_gt_binary2, frame_test_binary2, frame_overlap2, frame_union2] = gaze2vecNOGRAPH(frame_leanne_gt_gaze, frame_gaze, vid_length);
            [shark_gt_binary2, shark_test_binary2, shark_overlap2, shark_union2] = gaze2vecNOGRAPH(shark_leanne_gt_gaze, shark_gaze, vid_length);
            [top_gt_binary2, top_test_binary2, top_overlap2, top_union2] = gaze2vecNOGRAPH(top_leanne_gt_gaze, top_gaze, vid_length);
            [face1_gt_binary2, face1_test_binary2, face1_overlap2, face1_union2] = gaze2vecNOGRAPH(face1_leanne_gt_gaze, face1_gaze, vid_length);
            [face2_gt_binary2, face2_test_binary2, face2_overlap2, face2_union2] = gaze2vecNOGRAPH(face2_leanne_gt_gaze, face2_gaze, vid_length);
            [face3_gt_binary2, face3_test_binary2, face3_overlap2, face3_union2] = gaze2vecNOGRAPH(face3_leanne_gt_gaze, face3_gaze, vid_length);

            % Calc metric set #3
            [frame_accuracy2, frame_fp2, frame_fn2] = gaze_metric_3(frame_overlap2, frame_union2, frame_test_binary2, frame_gt_binary2);
            [shark_accuracy2, shark_fp2, shark_fn2] = gaze_metric_3(shark_overlap2, shark_union2, shark_test_binary2, shark_gt_binary2);
            [top_accuracy2, top_fp2, top_fn2]       = gaze_metric_3(top_overlap2, top_union2, top_test_binary2, top_gt_binary2);
            [face1_accuracy2, face1_fp2, face1_fn2] = gaze_metric_3(face1_overlap2, face1_union2, face1_test_binary2, face1_gt_binary2);
            [face2_accuracy2, face2_fp2, face2_fn2] = gaze_metric_3(face2_overlap2, face2_union2, face2_test_binary2, face2_gt_binary2);
            [face3_accuracy2, face3_fp2, face3_fn2] = gaze_metric_3(face3_overlap2, face3_union2, face3_test_binary2, face3_gt_binary2);

            % Calc total vid results
            vid_overlap2 = [frame_overlap2; top_overlap2; shark_overlap2; face1_overlap2; face2_overlap2; face3_overlap2];
            vid_union2 = [frame_union2; top_union2; shark_union2; face1_union2; face2_union2; face3_union2];
            vid_acc2 = sum(vid_overlap2)/sum(vid_union2);

            vid_test2 = [frame_test_binary2; top_test_binary2; shark_test_binary2; face1_test_binary2; face2_test_binary2; face3_test_binary2;];
            vid_gt2 = [frame_gt_binary2; top_gt_binary2; shark_gt_binary2; face1_gt_binary2; face2_gt_binary2; face3_gt_binary2;];
            vid_fp2 = sum(vid_test2 & ~vid_gt2)/sum(vid_test2);
            vid_fn2 = sum(vid_gt2 & ~vid_test2)/sum(vid_gt2);

            RESULTS(exit,entry) = vid_acc2;
        end
    end
    max_value = max(RESULTS(RESULTS>0));
    [row, col] = find(RESULTS == max(RESULTS(RESULTS>0)));
    if(save_data)
        % Saving results
        name = sprintf('%s_leanneVSalg_results.mat',foldername); 
        save(name,'RESULTS','max_value','row','col');
    end
end
%% Get accuracy for GT-1 (student) vs GT-2 (Leanne)
if(compare_gts)
    % load leanne gt
    load(sprintf('%s_leanne_gt_gaze.mat',foldername));
    for exit = 5:20
        for entry = 5:20
            % load student gt
            gt_name = sprintf('%s_gt_gaze_%d-%d.mat', foldername, entry, exit);
            load(gt_name);

            % Convert gaze to a vector
            [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vecNOGRAPH(frame_gt_gaze, frame_leanne_gt_gaze, vid_length);
            [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vecNOGRAPH(shark_gt_gaze, shark_leanne_gt_gaze, vid_length);
            [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vecNOGRAPH(top_gt_gaze, top_leanne_gt_gaze, vid_length);
            [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vecNOGRAPH(face1_gt_gaze, face1_leanne_gt_gaze, vid_length);
            [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vecNOGRAPH(face2_gt_gaze, face2_leanne_gt_gaze, vid_length);
            [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vecNOGRAPH(face3_gt_gaze, face3_leanne_gt_gaze, vid_length);

            % Calc metric set #3
            [frame_accuracy, frame_fp, frame_fn] = gaze_metric_3(frame_overlap, frame_union, frame_test_binary, frame_gt_binary);
            [shark_accuracy, shark_fp, shark_fn] = gaze_metric_3(shark_overlap, shark_union, shark_test_binary, shark_gt_binary);
            [top_accuracy, top_fp, top_fn]       = gaze_metric_3(top_overlap, top_union, top_test_binary, top_gt_binary);
            [face1_accuracy, face1_fp, face1_fn] = gaze_metric_3(face1_overlap, face1_union, face1_test_binary, face1_gt_binary);
            [face2_accuracy, face2_fp, face2_fn] = gaze_metric_3(face2_overlap, face2_union, face2_test_binary, face2_gt_binary);
            [face3_accuracy, face3_fp, face3_fn] = gaze_metric_3(face3_overlap, face3_union, face3_test_binary, face3_gt_binary);

            % Calc total vid results
            vid_overlap = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
            vid_union = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
            vid_acc= sum(vid_overlap)/sum(vid_union);

            vid_test = [frame_test_binary; top_test_binary; shark_test_binary; face1_test_binary; face2_test_binary; face3_test_binary;];
            vid_gt = [frame_gt_binary; top_gt_binary; shark_gt_binary; face1_gt_binary; face2_gt_binary; face3_gt_binary;];
            vid_fp = sum(vid_test & ~vid_gt)/sum(vid_test);
            vid_fn = sum(vid_gt & ~vid_test)/sum(vid_gt);

            RESULTS(exit,entry) = vid_acc;
        end
    end
    max_value = max(RESULTS(RESULTS>0));
    [row, col] = find(RESULTS == max(RESULTS(RESULTS>0)));
    if(save_data)
        % Saving results
        name = sprintf('%s_compare_gt_results.mat',foldername); 
        save(name,'RESULTS','max_value','row','col');
    end
end

%% Graphing with a heatmap
% replace 0's with the minimum value so imagesc will be to scaled 
RESULTS(RESULTS==0) = min(RESULTS(RESULTS>0));

imagesc(RESULTS.*100);
colorbar;
set(gcf, 'Position', [10 10 1000 1000])      % [x y width height]
if(strcmp(foldername, 'vid000'))
    title('Entry vs. Exit vs. IoU (Vid 0)');
else
    number = split(foldername, '0');            % get the vid number
    title(sprintf('Entry vs. Exit vs. IoU (Vid %d)',double(number(3))));
end
xlabel('Entry');
ylabel('Exit');
% shift to the matrix we want
xlim([5 20]);
% set(gca,'ydir','reverse')
ylim([5 20]);
% mark each tick
set(gca, 'YDir', 'normal', 'XTick', 5:20, 'YTick', 5:20);
