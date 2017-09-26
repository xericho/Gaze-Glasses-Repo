%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the confusion matrix. Returns the matrix and the
% TP rate and FP rate
%
% Example: [CM, TPFP, filtered] = extract_classification_matrix(brain_data, brain_test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [conf_matrix, TPFPrate, filtered] = extract_classification_matrix(truth_data, test_data)

    % Initialize 
    results = [];
    filtered = 0;
    conf_matrix = zeros(2,2);
    TPFPrate = zeros(2,1);
    
    for i = 1:size(truth_data,1)
        if isnan(truth_data(i,1))              %Ground Truth Negative
            if isnan(test_data(i,1))           %Negative detection
                results(i) = 1;                %TN
            else                               %Positive Detection
                results(i) = 2;                %FP
            end
        else                                   %ground Truth Positive
            if edge_case(truth_data(i,:)) == 1 %check edge case
                results(i) = 6;
            else
                if isnan(test_data(i,1))       %Negative Detection
                    results(i) = 3;            %FN
                else                           %Positive Detection
                    if bboxOverlapRatio(truth_data(i,:), test_data(i,:)) >= 0.5 %75 overlap needed
                        results(i) = 4;        %TP
                    else
                      results(i) = 5;          % did not make it to TP
                    end 
                end
            end
        end
    end
    
    % add up results
    conf_matrix(1,1) = sum(results(:) == 1);
    conf_matrix(1,2) = sum(results(:) == 2);
    conf_matrix(2,1) = sum(results(:) == 3);
    conf_matrix(2,2) = sum(results(:) == 4);
    filtered = sum(results(i) == 5);
    
    % calc TP rate and FP rate
    TPFPrate(1) = conf_matrix(1,2)/(conf_matrix(1,2)+conf_matrix(1,1));
    TPFPrate(2) = conf_matrix(2,2)/(conf_matrix(2,2)+conf_matrix(2,1));
    
    % display results 
    conf_matrix
    TPFPrate
end