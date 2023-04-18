function features = findFeatures(x)

    %% Binarization of pixels to black and white depending on the gray level
    
    y = double(x); %uint8 -> double
    T = 0.8;
    y(y < T*max(max(y))) = 0;
    y(y >= T*max(max(y))) = 255;

    %% Crop the black frame and zoom the image by removing the white frame

    [numRows, numColumns] = size(y);

    top = 1;
    down = numRows;
    while (top < numRows) && (sum(y(top,1:numColumns))/numColumns < 200) %prosecan nivo sivog u vrsti < 200
        top = top + 1;
    end
    while (down > 1) && (sum(y(down,1:numColumns))/numColumns < 200)
        down = down - 1;
    end

    left = 1;
    right = numColumns;
    while (left < numColumns) && (sum(y(1:numRows, left))/numRows < 200)
        left = left + 1;
    end
    while (right > 1) && (sum(y(1:numRows,right))/numRows < 200)
        right = right -1;
    end

    %scaling the frame
    y = y(top:down, left:right);
    [numRows,numColumns] = size(y);
    
    %zooming
    top = 1;
    while (top < numRows) && ((sum(y(top,1:numColumns))/numColumns > 250)...
            || ((sum(y(top,1:numColumns))/numColumns <= 250) && sum(y(top+1,1:numColumns))/numColumns > 250))
        top = top + 1;
    end
    down = numRows;
    while (down > 1) && ((sum(y(down,1:numColumns))/numColumns > 250)...
            || ((sum(y(down,1:numColumns))/numColumns <= 250) && sum(y(down-1,1:numColumns))/numColumns > 250))
        down = down - 1;
    end
    left = 1;
    while (left < numColumns) && ((sum(y(1:numRows,left))/numRows > 250)...
            || ((sum(y(1:numRows,left))/numRows <= 250) && sum(y(1:numRows,left+1))/numRows > 250))
        left = left + 1;
    end
    right = numColumns;
    while (right > 1) && ((sum(y(1:numRows,right))/numRows > 250) ...
            || ((sum(y(1:numRows,right))/numRows <= 250) && sum(y(1:numRows,right-1))/numRows > 250))
        right = right - 1;
    end

    y = y(top:down, left:right);
    [numRows, numColumns] = size(y);

    %% Feature extraction

    %first feature
    features(1, 1) = f1
    f1 = sum(sum(y(1:round(numRows/2), :) == 0))/(sum(sum(y(:, :) == 0)));
    
    %second feature
    features(2, 1) = f2
    f2 = sum(sum(y(round(1/3*numRows) + 1:round(2/3*numRows),round(1/3*numColumns) + 1:round(2/3*numColumns)) == 0))/((round(2/3*numRows) - round(1/3*numRows))*(round(2/3*numColumns) - round(1/3*numColumns)));    
    
    %third feature
    f3 = 0;
    i = 1;
    while (i < numRows)
        if (y(i, round(numColumns/2)) == 0)
            f3 = f3 + 1;
            while((y(i, round(numColumns/2)) == 0) && i < numRows)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    features(3, 1) = f3;

    %fourth feature
    f4 = 0;
    i = 1;
    while (i < numColumns)
        if (y(round(1/3*numRows), i) == 0)
            f4 = f4 + 1;
            while ((y(round(1/3*numRows), i) == 0) && i < numColumns)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    features(4, 1) = f4;

    %fifth feature
    f5 = 0;
    i = 1;
    while (i < numColumns)
        if (y(round(2/3*numRows), i) == 0)
            f5 = f5 + 1;
            while ((y(round(2/3*numRows), i) == 0) && i < numColumns)
                i = i + 1;
            end
            i = i + 20;
        else
            i = i + 1;
        end
    end
    features(5, 1) = f5;
    
end