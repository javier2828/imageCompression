%Javier Salazar Andrew Bouasry
% JPEG Compression on video given quantizer parameter
function transmitSignal = dct_compress(movie, scale, option)
info = size(movie); % get dimensions of movie
blockSize = 8; % size of blocks
JPEG_QUANT= scale.*[16 11 10 16 24 40 51 61       % Normalization matrix JPEG. Q=50 default
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
      
tempSignal = zeros((info(1)/8) * (info(2)/8),blockSize*blockSize, 'int16'); % dummy to store zigzag info for each block
transmitSignal = zeros(info(3),(info(1)/8) * (info(2)/8) *blockSize*blockSize, 'int16'); %preallocate final vector
for z = 1:info(3) % go through each frame
    count = 1; % counter for blocks in current frame
    for y = 1:(info(2)/8) % go through width
        for x = 1:(info(1)/8) % go through rows
            % get dct block given current block in frame
            dctMovie = dct2(movie((blockSize*(x-1)+1):(blockSize*(x-1)+blockSize),(blockSize*(y-1)+1):(blockSize*(y-1)+blockSize),z));
            %normalize dct coefficients. need to offset to get [0,255]
            %image to [-128,127] for symmatry
            dctMovie = floor((dctMovie+JPEG_QUANT/2)./(JPEG_QUANT));
            %store zigzag vector of current block
            tempSignal(count,:) = zigzag(dctMovie, 0);
            count = count + 1; % go to next block
        end
    end
    % store interwoven dct signal of entire frame
    transmitSignal(z,:) = tempSignal(:);
end
%store interwoven dct signal of entire video
transmitSignal = transmitSignal(:);
% remove all zero elements at trail. redundant info.
transmitSignal = transmitSignal(1:find(transmitSignal,1,'last'));
end