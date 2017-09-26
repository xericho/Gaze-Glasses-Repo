function dilated=dilate(entry,ratio)
    ratio = (ratio/100) + 1;
    dilated = zeros(size(entry));

    for i=1:size(entry,1)
        % h fix
        dilated(i,4)=floor(entry(i,4)*ratio);
        % w fix
        dilated(i,3)=floor(entry(i,3)*ratio);
        dilated(i,1)=floor(entry(i,1)-(0.5*(dilated(i,3)-entry(i,3))));
        % x fix
        if dilated(i,1)<=0
            dilated(i,1)=1;
        elseif dilated(i,1)>1280
            dilated(i,1)=1280;
        end
        % y fix
        dilated(i,2)=floor(entry(i,2)-(0.5*(dilated(i,4)-entry(i,4))));
        if dilated(i,2)<=0
            dilated(i,2)=0;
        elseif dilated(i,2)>720
            dilated(i,2)=720;
        end
    end
end
