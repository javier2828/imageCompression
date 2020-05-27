% Javier Salazar Andrew Bouasry
% Usage: input decoded signal and size of video get quantized video
function dctMovie = dct_receiver(transmitSignal, infoSize, scale, option)
blockSize = 8;
receivedSize = size(transmitSignal); % get size of signal received
% add trailing zeros back based on metadata
transmitSignal = [transmitSignal; zeros(infoSize(1)*infoSize(2)*infoSize(3)-receivedSize(1),1)]; 
% reshape vector signal into each row being a specific frame
transmitSignal = reshape(transmitSignal, [infoSize(3), (infoSize(1)/8)*(infoSize(2)/8)*blockSize*blockSize]);
% preallocate output video
dctMovie = zeros(infoSize, 'uint8');
% denormalize matrix
JPEG_QUANT= scale.*[16 11 10 16 24 40 51 61  
          12 12 14 19 26 58 60 55
          14 13 16 24 40 57 69 56
          14 17 22 29 51 87 80 62
          18 22 37 56 68 109 103 77
          24 35 55 64 81 104 113 92
          49 64 78 87 103 121 120 101
          72 92 95 98 112 100 103 99];
 if (option == 1)
    JPEG_QUANT = ones(8,8); 
 end
% go through all frames
for z = 1:infoSize(3)
    rowCount = 1; % counters to store data in output matrix
    columnCount =1;
    % reshape each row that is a frame back into an image and take blocks
    % to inverse dct
    tempSignal = reshape(transmitSignal(z,:), [(infoSize(1)/8)*(infoSize(2)/8), blockSize*blockSize]);
    % go through all blocks in given image frame
    for count = 1:(infoSize(1)/8)*(infoSize(2)/8)
        if (rowCount == (infoSize(1)/8) + 1) % if we reach end of row increase column and set row back to zero
            rowCount = 1;
            columnCount = columnCount + 1;
        end
        % inverse dct of block
        block = zigzag(tempSignal(count,:), 1);
        % denormalize and round to uint8
        block = round(idct2(double(block).*JPEG_QUANT));
        %store block on output matrix given row/column counters
        dctMovie(((rowCount-1)*blockSize + 1):(rowCount*blockSize),((columnCount-1)*blockSize + 1):(columnCount*blockSize),z) = block;
        rowCount = rowCount + 1;
    end
end
end