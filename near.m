function flag = near(s, t)
    global database;
    global map_labeled;
    global bw_dilate;
    [y,x] = size(map_labeled);
    labeled_s = s(3);
    labeled_t = t(3);
    if labeled_s==0
        bw_s = zeros([y,x]);
        bw_s(round(s(2)), round(s(1))) = 1;
    else
        bw_s = bw_dilate{labeled_s};
    end
    if labeled_t==0
        bw_t = zeros([y,x]);
        bw_t(round(t(2)), round(t(1))) = 1;
    else
        bw_t = (map_labeled == labeled_t);
    end
    if ~(bw_s & bw_t)
        flag = 0;
    else
        flag = 1;
    end
end