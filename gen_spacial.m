function rel = gen_spacial()
    global database;
    len = length(database);
    rel_east = zeros(len, len);
    rel_west = zeros(len, len);
    rel_north = zeros(len, len);
    rel_south = zeros(len, len);
    rel_near = zeros(len, len);
    global bw_dilate;
    bw_dilate = cell(len, 1);
    gen_bw_dilate();
    for i = 1:length(database)
        cent_s = database.Centroid(i,:);
        for j = 1:length(database)
            cent_t = database.Centroid(j,:);
            rel_east(i,j) = east([cent_s, i], [cent_t,j]);
            rel_west(i,j) = west([cent_s, i], [cent_t,j]);
            rel_north(i,j) = north([cent_s, i], [cent_t,j]);
            rel_south(i,j) = south([cent_s, i], [cent_t,j]);
            rel_near(i,j) = near([cent_s, i], [cent_t,j]);
            if i==j
                rel_east(i,j) = 0;
                rel_west(i,j) = 0;
                rel_north(i,j) = 0;
                rel_south(i,j) = 0;
                rel_near(i,j) = 0;
            end
        end
    end
    %%%%%%%%%%  filter %%%%%%%%
    rel_east = filter(rel_east);
    rel_west = filter(rel_west);
    rel_north = filter(rel_north);
    rel_south = filter(rel_south);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    rel.rel_east = rel_east;
    rel.rel_west = rel_west;
    rel.rel_north = rel_north;
    rel.rel_south = rel_south;
    rel.rel_near = rel_near;
end

function relation = filter(relation)
    global database;
    for i = 1:size(relation,1)
        for j = 1:size(relation,1)
            if relation(i,j)==1
                for k = 1:size(relation,1)
                    if relation(j,k)==1
                        relation(i,k) = 0;
                    end
                end
            end
        end
    end
    
    relation_1 = relation;
    for i = 1:size(relation, 1)
        min_dist = 100000;
        ind = 0;
        for j = 1:size(relation, 1)
            if relation_1(i,j) == 1
                dist = norm(database.Centroid(i,:)-database.Centroid(j,:));
                if dist<min_dist
                    min_dist = dist;
                    ind = j;
                end
            end
        end
        if ind~=0
            relation_1(i,:) = 0;
            relation_1(i, ind) = 1;
        end
    end
    
    relation_2 = relation;
    for j = 1:size(relation, 1)
        min_dist = 100000;
        ind = 0;
        for i = 1:size(relation, 1)
            if relation_2(i,j)==1
                dist = norm(database.Centroid(i,:)-database.Centroid(j,:));
                if dist<min_dist
                    min_dist = dist;
                    ind = i;
                end
            end
        end
        if ind~=0
            relation_2(:,j) = 0;
            relation_2(ind, j) = 1;
        end
    end
    
    relation = (relation_1 | relation_2);
end

function gen_bw_dilate()
    global map_labeled;
    global bw_dilate;
    global database;
    for i = 1:length(database)
        bw_img = (map_labeled == i);
        area = database.Area(i);
        bw_dilate{i} = bwmorph(bw_img,'dilate', sqrt(area)/2);
    end
end
