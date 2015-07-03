function flag = east(s, t)
    global database;
    labeled_s = s(3);
    labeled_t = t(3);
    % find bound box and centroid of s and t
    if labeled_s==0
        boundbox_s = [s(1), s(2), 1, 1];
        cent_s = [s(1), s(2)];
    else
        boundbox_s = database.BoundingBox(labeled_s, :);
        cent_s = database.Centroid(labeled_s, :);
    end
    if labeled_t==0
        boundbox_t = [t(1), t(2), 1, 1];
        cent_t = [t(1), t(2)];
    else
        boundbox_t = database.BoundingBox(labeled_t, :);
        cent_t = database.Centroid(labeled_t, :);
    end
    % compute if t at east of s
    if cent_t(1) > boundbox_s(1)+boundbox_s(3) && cent_t(2)>boundbox_s(2) && cent_t(2)<boundbox_s(2)+boundbox_s(4)
        flag = 1;
    else
        flag = 0;
    end
end