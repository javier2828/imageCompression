% Javier Salazar Andrew Bouasry
% Usage height x width x frames matrix = readData('sample.avi')
function output = readData(filename)
videoObject = VideoReader(filename); % create object that reads meta data and file info
output = zeros([videoObject.Height videoObject.Width videoObject.Duration*videoObject.FrameRate], 'uint8'); %preallocate output marix given dimensions of input
i = 1; % frame counter
while hasFrame(videoObject) % go through all frames
    frameYUV = readFrame(videoObject); % read YUV frame
    output(:,:,i) = frameYUV(:,:,1); % get only Y luminance info
    i = i + 1;
end
end