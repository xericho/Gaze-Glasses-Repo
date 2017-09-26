%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the updated gaze metric script
% Need:
% - gt gaze (not binary)
% - test gaze (not binary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
restoredefaultpath

RESULTS = [];

% Save the results?
save_data = true;

%% Get accuracy for GT-1 (student) vs GT-2 (Leanne)
        for exit = 5:20
            for entry = 3:20
                % initialize variables
                frame_gt_binary = []; frame_test_binary = []; frame_overlap = []; frame_union = [];
                shark_gt_binary = []; shark_test_binary = []; shark_overlap = []; shark_union = [];
                top_gt_binary = []; top_test_binary = []; top_overlap = []; top_union = []; 
                face1_gt_binary = []; face1_test_binary = []; face1_overlap = []; face1_union = []; 
                face2_gt_binary = []; face2_test_binary = []; face2_overlap = []; face2_union = []; 
                face3_gt_binary = []; face3_test_binary = []; face3_overlap = []; face3_union = [];
               
                for vid = 0:3
                    restoredefaultpath
                    foldername = sprintf('vid00%d', vid);
                    addpath(foldername);
                    addpath(sprintf('%s/Results',foldername));

                    % Get total length of video
                    reader = VideoReader(sprintf('%s_raw_60fps.mp4',foldername));
                    vid_length = reader.NumberOfFrames;
        
                    % load student gt
                    gt_name = sprintf('%s_gt_gaze_%d-%d.mat', foldername, entry, exit);
                    load(gt_name);
                    % load leanne gt
                    load(sprintf('%s_leanne_gt_gaze.mat',foldername));

                    % Convert gaze to a vector
                    [frame_gt_binary, frame_test_binary, frame_overlap, frame_union] = gaze2vec_ALL(frame_gt_gaze, frame_leanne_gt_gaze, frame_gt_binary, frame_test_binary, frame_overlap, frame_union);
                    [shark_gt_binary, shark_test_binary, shark_overlap, shark_union] = gaze2vec_ALL(shark_gt_gaze, shark_leanne_gt_gaze, shark_gt_binary, shark_test_binary, shark_overlap, shark_union);
                    [top_gt_binary, top_test_binary, top_overlap, top_union] = gaze2vec_ALL(top_gt_gaze, top_leanne_gt_gaze, top_gt_binary, top_test_binary, top_overlap, top_union);
                    [face1_gt_binary, face1_test_binary, face1_overlap, face1_union] = gaze2vec_ALL(face1_gt_gaze, face1_leanne_gt_gaze, face1_gt_binary, face1_test_binary, face1_overlap, face1_union);
                    [face2_gt_binary, face2_test_binary, face2_overlap, face2_union] = gaze2vec_ALL(face2_gt_gaze, face2_leanne_gt_gaze, face2_gt_binary, face2_test_binary, face2_overlap, face2_union);
                    [face3_gt_binary, face3_test_binary, face3_overlap, face3_union] = gaze2vec_ALL(face3_gt_gaze, face3_leanne_gt_gaze, face3_gt_binary, face3_test_binary, face3_overlap, face3_union);
                end
                
                % Calc acc for all vids
                vid_overlap = [frame_overlap; top_overlap; shark_overlap; face1_overlap; face2_overlap; face3_overlap];
                vid_union = [frame_union; top_union; shark_union; face1_union; face2_union; face3_union];
                vid_acc = sum(vid_overlap)/sum(vid_union);

                RESULTS(exit,entry) = vid_acc;
            end
        end

    % find what max is and where
    max_value = max(RESULTS(RESULTS>0));
    [row, col] = find(RESULTS == max(RESULTS(RESULTS>0)));
    
    if(save_data)
        % Saving results
        name = sprintf('%s_compare_gt_results.mat',foldername);  
        save(name,'RESULTS','max_value','row','col');
    end

%% Graphing with a heatmap
% replace 0's with the minimum value so imagesc will be to scaled 
RESULTS(RESULTS==0) = min(RESULTS(RESULTS>0));

imagesc(RESULTS.*100);
colorbar;
set(gcf, 'Position', [0 0 900 700])      % [x y width height]
if(strcmp(foldername, 'vid000'))
    title('Entry vs. Exit vs. IoU (Vid 0)');
else
    number = split(foldername, '0');            % get the vid number
%     title(sprintf('Entry vs. Exit vs. IoU (Vid %d)',double(number(3))));
    title('Entry vs. Exit vs. IoU');
end
xlabel('Entry');
ylabel('Exit');
% shift to the matrix we want
xlim([3 20]);
ylim([5 20]);
% mark each tick
set(gca, 'YDir', 'normal', 'XTick', 3:20, 'YTick', 5:20);
