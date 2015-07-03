function print_part1()
    global database;
    for i = 1:length(database)
        nam = database.Name{i};
        cent = database.Centroid(i,:);
        area = database.Area(i);
        box = database.BoundingBox(i,:);
        str1 = sprintf('%d.\n Name: %s\n Center of Mass: [%d,%d]\n Area: %d\n Bounding Box: [%d,%d], [%d,%d]\n'...
        , i, nam, round(cent(1)),round(cent(2)),round(area),round(box(1)),round(box(2)),...
        round(box(1)+box(3)), round(box(2)+box(4)));
        str2 = [' Description: ', print_building(i)];
        str2 = sprintf('%s\n', str2);
        disp([str1,str2]);
    end
end