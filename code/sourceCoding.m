%Javier Salazar Andrew Bouasry
% Usage give vector and compress using RLE and Huffman
function [encodeSignal, dict] = sourceCoding(inputSignal)
len = 2*length(inputSignal); % get length of vector 
currentPosition = 1; % position of uncoded signal, go thorugh and count repeats
newValue = 1; % position of encoded RLE array
iteration = 1; % cunter for uncoded signal
runSignal = zeros(size(inputSignal), 'int32'); % large size needed due to repetative zeros
while iteration < len % go thorugh length of signal and find repeating values
    counter = 1; % assume first value is unique
    for currentPosition = currentPosition:len/2 % here we will go though current pos of signal until the end
        if (currentPosition == len/2) % if we reach the end then stop
            break
        end
        if (inputSignal(currentPosition) == inputSignal(currentPosition+1)) 
            % if we find a repeated value then increase counter
            counter = counter + 1;
        else % if its not repeated we are done here so end for loop
            break
        end
    end
    % store the number of repeated values
    runSignal(newValue + 1) = counter;
    % store the actual value in encoded array
    runSignal(newValue) = inputSignal(currentPosition);
    % due to starting for loop above, we need to add a break otherwise we
    % will be out of bounds in the code below
    %exit while loop if we reach end and contains repeatability
    if (currentPosition == len/2 && inputSignal(currentPosition)==inputSignal(currentPosition-1))
        break
    end
    % increase while loop iteration and perform once more
    iteration = iteration + 1;
    % move to new position of uncoded signal
    currentPosition = currentPosition + 1;
    % move along encoded signal as well
    newValue = newValue + 2;
    % if we reach end by incrament above and theres no repeatability then
    % store only that value and counter 1 then exit while looop
    if (currentPosition == len/2)
        runSignal(newValue) = inputSignal(currentPosition);
        runSignal(newValue+1) = 1;
        break
    end
end
% remove trailing zeros to efficiently encode
runSignal = runSignal(1:find(runSignal,1,'last'));
% tabulate will return frequencies of values in rle signal
table = tabulate(runSignal);
%create dictionary huffman to encode signal
[dict, avglen] = huffmandict(table(:,1), table(:,3)./100);
%create huffman signal and change to uint8 for memory purpose
encodeSignal = cast(huffmanenco(runSignal, dict), 'uint8');
end
