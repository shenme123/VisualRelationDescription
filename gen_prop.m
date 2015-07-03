function database = gen_prop()
    global map_labeled;
    
    database = regionprops(map_labeled, 'centroid','area', 'boundingbox');
    database = struct2dataset(database);
    database = addprops(map_labeled, database);
    database = getname(database);
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

function database = addprops(map_labeled, database)
    % database = [Area, Centroid, BoundingBox, Small, Medium, Large,
    % SymmetricEW, SymmetricNS, OrientedEW, OrientedNS, Rect, Square,
    % Upper, Lower, Easter, Wester
    len = size(database,1);
    % small/medium/large
    area_sorted = sort(database.Area);
    area_small = area_sorted(len/3);
    area_large = area_sorted(len/3*2);
    small = [];
    medium = [];
    large = [];
    sym_EW = [];
    sym_NS = [];
    orient_EW = [];
    orient_NS = [];
    rect = [];
    sqr = [];
    upper = [];
    lower = [];
    easter = [];
    wester = [];
    for i=1:len
        % small/medium/large
        if database.Area(i) <= area_small
            small = [small; 1];
            medium = [medium; 0];
            large = [large; 0];
        elseif database.Area(i) > area_large
            small = [small; 0];
            medium = [medium; 0];
            large = [large; 1];
        else
            small = [small; 0];
            medium = [medium; 1];
            large = [large; 0];
        end
        % SymmetricEW/SymmetricNS/notSymmetric
        boundbox = database.BoundingBox(i,:);
        cent = database.Centroid(i,:);
        box_x = boundbox(1)+boundbox(3)/2;
        if cent(1) == box_x
            sym_EW = [sym_EW; 1];
        else 
            sym_EW = [sym_EW; 0];
        end
        box_y = boundbox(2)+boundbox(4)/2;
        if cent(2) == box_y
            sym_NS = [sym_NS; 1];
        else
            sym_NS = [sym_NS; 0];
        end
        % OrientedEW(x/y>1.2)/OrientedNS(x/y<1/1.2)
        if boundbox(3)/boundbox(4)>=1.2
            orient_EW = [orient_EW; 1];
            orient_NS = [orient_NS; 0];
        elseif boundbox(3)/boundbox(4)<=1/1.2
            orient_EW = [orient_EW; 0];
            orient_NS = [orient_NS; 1];
        else
            orient_EW = [orient_EW; 0];
            orient_NS = [orient_NS; 0];
        end
        % rect / square(1/1.05 <=x/y <= 1.05)
        if boundbox(3)*boundbox(4) == database.Area(i)
            if boundbox(3)/boundbox(4)>=1.05 || boundbox(4)/boundbox(3)>=1.05
                rect = [rect; 1];
                sqr = [sqr; 0];
            else
                rect = [rect; 0];
                sqr = [sqr;1];
            end
        else
            rect = [rect; 0];
            sqr = [sqr; 0];
        end
        % upper/lower/ester/wester
        width = size(map_labeled, 2);
        length = size(map_labeled, 1);
        upper_line = length/3;
        lower_line = length/3*2;
        wester_line = width/3;
        easter_line = width/3*2;
        if cent(1)>easter_line
            easter = [easter; 1];
            wester = [wester; 0];
        elseif cent(1)<wester_line
            easter = [easter; 0];
            wester = [wester; 1];
        else
            easter = [easter; 0];
            wester = [wester; 0];
        end
        if cent(2)<upper_line
            upper = [upper; 1];
            lower = [lower; 0];
        elseif cent(2)>lower_line
            upper = [upper; 0];
            lower = [lower; 1];
        else
            upper = [upper; 0];
            lower = [lower; 0];
        end          
    end
    database.Small = small;
    database.Medium = medium;
    database.Large = large;
    database.SymmetricEW = sym_EW;
    database.SymmetricNS = sym_NS;
    database.OrientedEW = orient_EW;
    database.OrientedNS = orient_NS;
    database.Rectangle = rect;
    database.Square = sqr;
    database.Upper = upper;
    database.Lower = lower;
    database.Easter = easter;
    database.Wester = wester;
end

