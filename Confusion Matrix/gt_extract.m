clear all
close all
clc

addpath('Ground_truth');
filename='vid0_gt.csv';
matrix=csv_import(filename);
len=size(matrix,1);
%% strip to individual
brain_truth(len,4)=nan;
dice_truth=brain_truth;
frame_truth=brain_truth;
hedgehog_truth=brain_truth;
shark_truth=brain_truth;
top_truth=brain_truth;
for index=1:len
    for row=1:size(matrix,2)
        if strcmp(matrix(index,row),'brain')
            for i=1:4
                    try brain_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch brain_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
            
        end
        if brain_truth(index,1)==0;
            brain_truth(index,1:4)=nan;
        end
        %%%%%%%%%%
        if strcmp(matrix(index,row),'dice')
            for i=1:4
                    try dice_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch dice_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
        end
        if dice_truth(index,1)==0;
            dice_truth(index,1:4)=nan;
        end
        %%%%%%%%%%%
        if strcmp(matrix(index,row),'frame')
            for i=1:4
                    try frame_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch frame_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
            
        end
        if frame_truth(index,1)==0;
            frame_truth(index,1:4)=nan;
        end
        %%%%%%%%%%%
        if strcmp(matrix(index,row),'hedgehog')
            for i=1:4
                    try hedgehog_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch hedgehog_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
        end
        if hedgehog_truth(index,1)==0;
            hedgehog_truth(index,1:4)=nan;
        end
        %%%%%%%%%%%%%
        if strcmp(matrix(index,row),'shark')
            for i=1:4
                    try shark_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch shark_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
        end
        if shark_truth(index,1)==0;
            shark_truth(index,1:4)=nan;
        end
        %%%%%%%%%%%%%%%%
        if strcmp(matrix(index,row),'top')
            for i=1:4
                    try top_truth(index,i)=cell2mat(matrix(index,row+i)); 
                    catch top_truth(index,i)=str2double(cell2mat(matrix(index,row+i)));
                    end
            end
        end
        if top_truth(index,1)==0;
            top_truth(index,1:4)=nan;
        end
    end
    
end
%%
clearvars filename i index len row
save('vid0_gt.mat');