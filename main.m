function hw3
    close all;
    map = imread('ass3-campus.pgm');
    global map_labeled;
    map_labeled = imread('ass3-labeled.pgm');
    map_labeled = relabel(map_labeled);
    map2 = label2rgb(map_labeled, 'jet', 'k'); 
    figure;imshow(map2);
    %figure;imshow(map_labeled);

    % part 1
    global database;
    database = gen_prop();
    print_part1();

    % part 2
    relation = gen_spacial();
    print_part2(relation);

    % part 3
    fig = figure(); imshow(map)
    % get points
    disp('set start point (double click):');
    [y, x] = getpts(fig);
    start = [round(x), round(y)];
    hold on;
    plot(y, x, 'yx');
    disp('target point (double click):');
    [y, x] = getpts(fig);
    target = [round(x), round(y)];
    plot(y, x, 'yx');
    % plot start cloud
    map_labeled_rep = map_labeled;
    map_labeled(start(1), start(2)) = 28;
    database_rep = database;
    database = gen_prop_re();
    relation = gen_spacial();
    database = database_rep;
    list = print_info(relation, 'start point', 28);
    mask = gen_cloud(list);
    [row, col] = find(mask==1);
    plot(col, row, 'gs','MarkerSize',1);
    % plot target cloud
    map_labeled = map_labeled_rep;
    map_labeled(target(1), target(2)) = 28;
    database = gen_prop_re();
    relation = gen_spacial();
    database = database_rep;
    list = print_info(relation, 'target point', 28);
    mask2 = gen_cloud(list);
    [row, col] = find(mask2==1);
    plot(col, row, 'rs','MarkerSize',1);
    
    % part 4
    map_labeled = map_labeled_rep;
    map_labeled(start(1), start(2)) = 28;
    map_labeled(target(1), target(2)) = 29;
    database = gen_prop_re();
    relation = gen_spacial();
    database_rep2 = database;
    database = database_rep;
    print_info(relation, 'start point', 28);
    print_info(relation, 'target point', 29);
    database = database_rep2;
    %%%% generate path
    path = gen_path(relation);
    cent = [];
    for i = 1:length(path)
        cent = [cent; database.Centroid(path(i),:)];
    end
    plot(cent(:,1), cent(:,2),'bs-');
    database = database_rep;
    print_description(relation, path);
    
    %%%% user path
    fig2 = figure(); imshow(map);
    hold on;
    plot(start(2), start(1), 'yx');
    [y,x] = getpts(fig2);
    y = [start(2);y];
    x = [start(1);x];
    plot(y, x, 'rx-');
    
    fig3 = figure(); imshow(map);
    hold on;
    plot(start(2), start(1), 'yx');
    [y,x] = getpts(fig3);
    y = [start(2);y];
    x = [start(1);x];
    plot(y, x, 'rx-');
    a=1;
end

function print_description(rel, path)
    for i=1:length(path)-1
        step = 'go to ';
        if rel.rel_near(path(i),path(i+1))==1 || rel.rel_near(path(i+1),path(i))==1
            step = [step, 'near '];
        end
        if rel.rel_east(path(i),path(i+1))==1 || rel.rel_west(path(i+1),path(i))==1
            step = [step, 'east '];
        end
        if rel.rel_west(path(i),path(i+1))==1 || rel.rel_east(path(i+1),path(i))==1
            step = [step, 'west '];
        end
        if rel.rel_north(path(i),path(i+1))==1 || rel.rel_south(path(i+1),path(i))==1
            step = [step, 'north '];
        end
        if rel.rel_south(path(i),path(i+1))==1 || rel.rel_north(path(i+1),path(i))==1
            step = [step, 'south '];
        end
        if i+1<length(path) && i>=1
            step = [step, '(', print_building(path(i+1)), ')'];
        end
        disp (step)
    end
end


function path = gen_path(relation)
    global database;
    rel = (relation.rel_east | relation.rel_west | relation.rel_north | relation.rel_south | relation.rel_near);
    rel = rel | rel';
    len = size(rel,1);
    edge = ones(len,len)*100000;
    for i = 1:len
        for j = 1:len
            if rel(i,j)==1
                edge(i,j) = norm(database.Centroid(i,:) - database.Centroid(j,:));
            end
        end
    end
    dist = ones(len,1)*100000;
    visited = zeros(len, 1);
    track = zeros(len, 1);
    ind = 28;
    dist(ind) = 0;
    for i = 1:len-1
        for j = 1:len
            if edge(ind, j)+dist(ind)<dist(j)
                dist(j) = edge(ind, j)+dist(ind);
                track(j) = ind;
            end
        end
        visited(ind) = 1;
        ind = find(dist==min(dist(~visited)));
    end
    ind = 29;
    path = ind;
    while ind~=28
        path = [track(ind);path];
        ind = (track(ind));
    end
    a = 1;
    
end


function mask = gen_cloud(list)
    global database;
    global bw_dilate;
    mask = ones(495,275);
    if length(list.e)>0
        for i = 1:length(list.e)
            m = zeros(495, 275);
            bb = uint16(database.BoundingBox(list.e(i),:));
            m(bb(2):bb(2)+bb(4), min(bb(1)+bb(3),275):275) = 1;
            mask = mask & m;
        end
    end
    if length(list.w)>0
        for i = 1:length(list.w)
            m = zeros(495, 275);
            bb = uint16(database.BoundingBox(list.w(i),:));
            m(bb(2):bb(2)+bb(4), 1:bb(1)) = 1;
            mask = mask & m;
        end
    end
    if length(list.n)>0
        for i = 1:length(list.n)
            m = zeros(495, 275);
            bb = uint16(database.BoundingBox(list.n(i),:));
            m(1:bb(2), bb(1):min(bb(1)+bb(3),275)) = 1;
            mask = mask & m;
        end
    end
    if length(list.s)>0
        for i = 1:length(list.s)
            m = zeros(495, 275);
            bb = uint16(database.BoundingBox(list.s(i),:));
            m(bb(2)+bb(4):495, bb(1):min(bb(1)+bb(3),275)) = 1;
            mask = mask & m;
        end
    end
    if length(list.near)>0
        for i = 1:length(list.near)
            mask = mask & bw_dilate{list.near(i)};
        end
    end
end

function list = print_info(relation, name, num)
    list = struct('e',[], 'w',[], 'n',[], 's',[], 'near',[]);
    for j=1:size(relation.rel_east,1)
        if relation.rel_east(j,num)==1
            list.e = [list.e, j];
        end
        if relation.rel_west(j,num)==1
            list.w = [list.w, j];
        end
        if relation.rel_north(j,num)==1
            list.n = [list.n, j];
        end
        if relation.rel_south(j,num)==1
            list.s = [list.s, j];
        end
        if relation.rel_near(j,num)==1
            list.near = [list.near, j];
        end
    end
    str = sprintf('%s is: ', name);
    if (length(list.e)~=0)
        for i = 1:length(list.e)
            str = [str, 'east of building (', print_building(list.e(i)),'),'];
        end
    end
    if (length(list.w)~=0)
        for i = 1:length(list.w)
            str = [str, 'west of building (', print_building(list.w(i)),'),'];
        end
    end
    if (length(list.n)~=0)
        for i = 1:length(list.n)
            str = [str, 'north of building (', print_building(list.n(i)),'),'];
        end
    end
    if (length(list.s)~=0)
        for i = 1:length(list.s)
            str = [str, 'south of building (', print_building(list.s(i)),'),'];
        end
    end
    if (length(list.near)~=0)
        for i = 1:length(list.near)
            str = [str, 'near building (', print_building(list.near(i)),'),'];
        end
    end
    disp(str);
end

function str = add_name(lst)
    global database;
    str = '';
    for i = 1:length(lst)
        str = [str, database.Name{lst(i)}, ', '];
    end
end

function database = gen_prop_re()
    global map_labeled;
    database = regionprops(map_labeled, 'centroid','area', 'boundingbox');
    database = struct2dataset(database);
    database = getname(database);
end

function map_labeled = relabel(map_labeled)
    count = 1;
    for i=1:255
        ind = find(map_labeled==i);
        if ~isempty(ind)
            map_labeled(ind)=count;
            count = count+1;
        end
    end
end

function database = getname(database)
    name = {'Pupin';
            'Schapiro CEPSR';
            'Mudd, Engineering Terrace, Fairchild & Computer Science';
            'Physical Fitness Center';
            'Gymnasium & Uris';
            'Schermerhorn';
            'Chandler & Havemeyer';
            'Computer Center';
            'Avery';
            'Fayerweather';
            'Mathematics';
            'Low Library';
            'St. Paul''s Chapel';
            'Earl Hall';
            'Lewisohn';
            'Philosophy';
            'Buell & Maison Francaise';
            'Alma Mater';
            'Dodge';
            'Kent';
            'College Walk';
            'Journalism & Furnald';
            'Hamilton, Hartley, Wallach & John Jay';
            'Lion''s Court';
            'Lerner Hall';
            'Butler Library';
            'Carman'};
    database.Name = name;
end