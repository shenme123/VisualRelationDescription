function print_part2(relation)
    global database;
    for i=1:length(database)
        list = struct('e',[], 'w',[], 'n',[], 's',[], 'near',[]);
        name = database.Name{i};
        for j=1:length(database)
            if relation.rel_east(j,i)==1
                list.e = [list.e, j];
            end
            if relation.rel_west(j,i)==1
                list.w = [list.w, j];
            end
            if relation.rel_north(j,i)==1
                list.n = [list.n, j];
            end
            if relation.rel_south(j,i)==1
                list.s = [list.s, j];
            end
            if relation.rel_near(j,i)==1
                list.near = [list.near, j];
            end
        end
        str = sprintf('%d. %s is: ', i, name);
        if (length(list.e)~=0)
            str = [str, 'east of ', add_name(list.e)];
        end
        if (length(list.w)~=0)
            str = [str, 'west of ', add_name(list.w)];
        end
        if (length(list.n)~=0)
            str = [str, 'north of ', add_name(list.n)];
        end
        if (length(list.s)~=0)
            str = [str, 'south of ', add_name(list.s)];
        end
        str = [str, 'near ', add_name(list.near)];
        disp(str);
    end 
end

function str = add_name(lst)
    global database;
    str = '';
    for i = 1:length(lst)
        str = [str, database.Name{lst(i)}, ', '];
    end
end


