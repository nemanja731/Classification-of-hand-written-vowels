function P = obelezja(x)

    %% Binarizacija piksela na crnu i belu boju u zavisnosti od nivoa sivog
    
    y = double(x); %uint8 -> double
    T = 0.8;
    y(y < T*max(max(y))) = 0;
    y(y >= T*max(max(y))) = 255;

    %% Isecanje crnog okvira i zumiranje slike sklanjanjem belog okvira

    [num_rows, num_columns] = size(y);

    top = 1;
    down = num_rows;
    while (top < num_rows) && (sum(y(top,1:num_columns))/num_columns < 200) %prosecan nivo sivog u vrsti < 200
        top = top + 1;
    end
    while (down > 1) && (sum(y(down,1:num_columns))/num_columns < 200)
        down = down - 1;
    end

    left = 1;
    right = num_columns;
    while (left < num_columns) && (sum(y(1:num_rows, left))/num_rows < 200)
        left = left + 1;
    end
    while (right > 1) && (sum(y(1:num_rows,right))/num_rows < 200)
        right = right -1;
    end

    %sklanjanje okvira
    y = y(top:down, left:right);
    [num_rows,num_columns] = size(y);
    
    %zumiranje
    top = 1;
    while (top < num_rows) && ((sum(y(top,1:num_columns))/num_columns > 250)...
            || ((sum(y(top,1:num_columns))/num_columns <= 250) && sum(y(top+1,1:num_columns))/num_columns > 250))
        top = top + 1;
    end
    down = num_rows;
    while (down > 1) && ((sum(y(down,1:num_columns))/num_columns > 250)...
            || ((sum(y(down,1:num_columns))/num_columns <= 250) && sum(y(down-1,1:num_columns))/num_columns > 250))
        down = down - 1;
    end
    left = 1;
    while (left < num_columns) && ((sum(y(1:num_rows,left))/num_rows > 250)...
            || ((sum(y(1:num_rows,left))/num_rows <= 250) && sum(y(1:num_rows,left+1))/num_rows > 250))
        left = left + 1;
    end
    right = num_columns;
    while (right > 1) && ((sum(y(1:num_rows,right))/num_rows > 250) ...
            || ((sum(y(1:num_rows,right))/num_rows <= 250) && sum(y(1:num_rows,right-1))/num_rows > 250))
        right = right - 1;
    end

    y = y(top:down, left:right);
    [num_rows, num_columns] = size(y);

    %% Izdvajanje oblezja

    %prvo obelezje
    P(1, 1) = sum(sum(y(1:round(num_rows/2), :) == 0))/(sum(sum(y(:, :) == 0)));
    
    %drugo obelezje
    P(2, 1) = sum(sum(y(round(1/3*num_rows) + 1:round(2/3*num_rows),round(1/3*num_columns) + 1:round(2/3*num_columns)) == 0))/((round(2/3*num_rows) - round(1/3*num_rows))*(round(2/3*num_columns) - round(1/3*num_columns)));    
    
    p1 = 0;
    i = 1;
    while (i < num_rows)
        if (y(i, round(num_columns/2)) == 0)
            p1 = p1 + 1;
            while((y(i, round(num_columns/2)) == 0) && i < num_rows)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    p2 = 0;
    i = 1;
    while (i < num_columns)
        if (y(round(1/3*num_rows), i) == 0)
            p2 = p2 + 1;
            while ((y(round(1/3*num_rows), i) == 0) && i < num_columns)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    p3 = 0;
    i = 1;
    while (i < num_columns)
        if (y(round(2/3*num_rows), i) == 0)
            p3 = p3 + 1;
            while ((y(round(2/3*num_rows), i) == 0) && i < num_columns)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    
    %trece obelezje
    P(3, 1) = p1;
    
    %cetvrto obelezje
    P(4, 1) = p2;
    
    %peto obelezje
    P(5, 1) = p3;
    
end