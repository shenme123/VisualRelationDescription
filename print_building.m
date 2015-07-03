function str2 = print_building(num)
    global database;
    str2 = [];
    if database.Small(num) == 1
        str2 = [str2, 'small '];
    end
    if database.Medium(num) == 1
        str2 = [str2, 'medium '];
    end
    if database.Large(num) == 1
        str2 = [str2, 'large '];
    end
    if database.SymmetricEW(num) == 1
        str2 = [str2, 'symmetricEastWest '];
    end
    if database.SymmetricNS(num) == 1
        str2 = [str2, 'symmetricNorthSouth '];
    end
    if database.SymmetricEW(num) == 0 && database.SymmetricNS(num) == 0
        str2 = [str2, 'nonSymmetric '];
    end
    if database.OrientedEW(num) == 1
        str2 = [str2, 'orientedEastWest '];
    end
    if database.OrientedNS(num) == 1
        str2 = [str2, 'orientedNorthSouth '];
    end
    if database.Rectangle(num) == 1
        str2 = [str2, 'rectangle '];
    end
    if database.Square(num) == 1
        str2 = [str2, 'square '];
    end
    if database.Rectangle(num) == 0 && database.Square(num) == 0
        str2 = [str2, 'nonRectangle '];
    end
    if database.Upper(num) == 1
        str2 = [str2, 'upperCampus '];
    end
    if database.Lower(num) == 1
        str2 = [str2, 'lowerCampus '];
    end
    if database.Easter(num) == 1
        str2 = [str2, 'easterCampus '];
    end
    if database.Wester(num) == 1
        str2 = [str2, 'westerCampus '];
    end
end