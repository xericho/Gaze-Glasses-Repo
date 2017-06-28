% have not coded around the missing images yet
% will crash at 242

clear all
close all
clc
%run the other two first to get the mat files
load('vid11_gt.mat');
load('test.mat');
addpath('E:\auto confusion matrix\Pull\Confusion Matrix Auto\Base Images'); %change this to the folder with all the images
%%
offset=0;
for i=1:size(shark_truth,1)
    image_name=sprintf('test_%04d.jpg',i);
    if exist(image_name)
%         frame=imread(image_name);
        imshow(image_name)
        title(image_name)
        i=i-offset; %%%%%%%%%%%%%%%%
        if isnan(shark_truth(i,1))==0
            rectangle('Position',shark_truth(i,:),'EdgeColor','yellow','LineWidth',3);
        end
        if isnan(brain_truth(i,1))==0
            rectangle('Position',brain_truth(i,:),'EdgeColor','magenta','LineWidth',3);
        end
        if isnan(dice_truth(i,1))==0
            rectangle('Position',dice_truth(i,:),'EdgeColor','cyan','LineWidth',3);
        end
        if isnan(hedgehog_truth(i,1))==0
            rectangle('Position',hedgehog_truth(i,:),'EdgeColor','red','LineWidth',3);
        end
        if isnan(top_truth(i,1))==0
            rectangle('Position',top_truth(i,:),'EdgeColor','green','LineWidth',3);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        if exist('shark_test')
           if isnan(shark_test(i,1))==0
                rectangle('Position',shark_test(i,:),'EdgeColor','yellow','LineWidth',3,'LineStyle','--');
           end 
        end
        if exist('brain_test')
           if isnan(brain_test(i,1))==0
                rectangle('Position',brain_test(i,:),'EdgeColor','magenta','LineWidth',3,'LineStyle','--');
           end 
        end
        if exist('dice_test')
           if isnan(dice_test(i,1))==0
                rectangle('Position',dice_test(i,:),'EdgeColor','cyan','LineWidth',3,'LineStyle','--');
           end 
        end
        if exist('hedgehog_test')
           if isnan(hedgehog_test(i,1))==0
                rectangle('Position',hedgehog_test(i,:),'EdgeColor','red','LineWidth',3,'LineStyle','--');
           end 
        end
        if exist('top_test')
           if isnan(top_test(i,1))==0
                rectangle('Position',top_test(i,:),'EdgeColor','green','LineWidth',3,'LineStyle','--');
           end 
        end


        pause
    else
        offset=offset+1;
    end
    
end
    