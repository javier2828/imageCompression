% Javier Salazar Andrew Bouasry
% Usage: Input Huffman 0/1 signal along with dictionary
% size of DCT signal needed to preallocate ahead of time for efficiency
function decodedRLE = sourceDecoding(runHuffSignal, dict, sizeTransmission)
% decode huff get RLE signal
decodedHuff = cast(huffmandeco(cast(runHuffSignal, 'double'), dict), 'int32');
%store RLE length 
len = length(decodedHuff);
% preallocate decoded dct signal
decodedRLE = zeros(sizeTransmission, 'int16');
% counter for knowing how many times to store certain value up to stored
% repeapeted count
counter = 1;
% position for uncompressed signal
newPosition = 1;
% iteration for entire RLE signal
iteration = 1;
while iteration <= len % go through RLE signal
    while (counter <= decodedHuff(iteration+1)) % if counter isnt the same as repeated count value keep going
        decodedRLE(newPosition) = decodedHuff(iteration); %store actual value in new signal
        counter = counter + 1; % icnrease counter
        newPosition = newPosition + 1; % move postition. rinse repeat
    end
    iteration = iteration + 2; % go to new repeated stored count
    counter = 1; % set back and assume unique value
end
end