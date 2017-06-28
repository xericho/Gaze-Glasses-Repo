%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleans the gaze position data so it is synced with the 
% video.
%
% Example: [confidence, pos_x, pos_y] = clean_gaze_position('gaze_postions.csv', 30);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [new_confidence, new_pos_x, new_pos_y] = clean_gaze_position(filename, video)
%     filename = 'gaze_postions.csv';
    [index, confidence, norm_pos_x, norm_pos_y] = csvimport(filename, 'columns', ...
                                        {'index','confidence','norm_pos_x','norm_pos_y'});
    
    % Initialize variables
    new_confidence = [];
    new_pos_x = [];
    new_pos_y = [];
    frame_num = 0;
    
    while frame_num < index(end)
        temp = find(index == frame_num);                            % find the index of frame number
        
        % no such frame number exists
        if isempty(temp)
            % Extract values
            new_confidence(frame_num+1) = 0;    % get the last element found
            new_pos_x(frame_num+1) = 0;
            new_pos_y(frame_num+1) = 0;
            frame_num = frame_num + 1;
            continue
        end
        
        % Extract values
        new_confidence(frame_num+1) = confidence(temp(end));        % get the last element found
        new_pos_x(frame_num+1) = norm_pos_x(temp(end));
        new_pos_y(frame_num+1) = norm_pos_y(temp(end));

        frame_num = frame_num + 1;
    end
    
    % Unnormalize gaze data
    new_pos_x = new_pos_x*video.width;
    new_pos_y = video.height - (new_pos_y*video.height);

end
