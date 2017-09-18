function [accuracy, fp, fn] = gaze_metric_3(overlap, union, test, gt)
   accuracy = sum(overlap)/sum(union);
   fp = sum(test.*~gt)/sum(test);
   fn = sum(gt.*~test)/sum(gt);
end