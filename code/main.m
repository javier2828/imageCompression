%Javier Salazar & Andrew Bouasary - Telecom Video Compression
clc

%import uncompressed avi as luminance channel only with 8 bit data
filename = 'sample.avi';
movie = readData(filename);
info = size(movie);
% quantize 16 levels and display pictures along with SNR & Histogram
bits = 4;
quantizeMovie = uint8(reshape(pcm(movie(:), bits), info));
SQNR_PCM = 20*log10(norm(double(movie(:)))/norm(double(movie(:))-double(quantizeMovie(:))));
AvgP_PCM = rms(double(movie(:))-double(quantizeMovie(:)));
%-----------PLOT PCM DATA----------------------------------
figure
subplot(1,2,1)
imshow(movie(:,:,1));
title('Video Frame #1 Original Image: 8 bits')
subplot(1,2,2)
imshow(quantizeMovie(:,:,1));
title(['Video Frame #1 Quantized Image: ' num2str(bits) ' bits SQNR: ' num2str(SQNR_PCM)])
%---------------------------------------------------------------

%perform DCPM INTRAFRAME transmission
[errorSignal, FY1,FY2,FY3] = encodeDPCM(movie, bits);
dpcmMovie = decodeDPCM(errorSignal, info, FY1, FY2, FY3);
[errorSignalTra3, FY1,FY2,FY3] = encodeDPCM(movie, 3);
[errorSignalTra4, FY1,FY2,FY3] = encodeDPCM(movie, 4);
[errorSignalTra5, FY1,FY2, FY3] = encodeDPCM(movie, 5);
movie2 = movie(2:end,2:end,:);
SQNR_DPCMIntra = 20*log10(norm(double(movie2(:)))/norm(double(movie2(:))-double(dpcmMovie(:))));
AvgP_DPCMIntra = rms(double(errorSignal(:)));

dpcmMovie3 = decodeDPCM(errorSignalTra3, info, FY1, FY2, FY3);
dpcmMovie4 = decodeDPCM(errorSignalTra4, info, FY1, FY2, FY3);
dpcmMovie5 = decodeDPCM(errorSignalTra5, info, FY1, FY2, FY3);

figure
subplot(1,3,1)
imshow(dpcmMovie3(:,:,1));
title('DPCM 3 BIT');
subplot(1,3,2)
imshow(dpcmMovie4(:,:,1));
title('DPCM 4 BIT');
subplot(1,3,3)
imshow(dpcmMovie5(:,:,1));
title('DPCM 5 BIT');

%----------PLOT DPCM INTRAFRAME QUANTIZER HISTOGRAMS----------------------
[errorSignal3, ~,~,~, ~, ~] = dpcm_transmit(movie, 3);
[errorSignal4, ~,~,~, ~,~] = dpcm_transmit(movie, 4);
[errorSignal5, ~,~,~, ~, ~] = dpcm_transmit(movie, 5);

figure
histogram(uencode(errorSignal3,3, 200,'signed'), 2^3, 'FaceAlpha', 0.25, 'FaceColor', 'blue','Normalization','count');
hold on
histogram(uencode(errorSignal4, 4, 200, 'signed'), 2^4, 'FaceAlpha', 0.25, 'FaceColor', 'green', 'Normalization','count');
hold on
histogram(uencode(errorSignal5, 5, 200, 'signed'), 2^5, 'FaceAlpha', 0.25, 'FaceColor', 'red', 'Normalization','count')
hold off
title('DPCM INTRAFRAME QUANTIZER HISTOGRAM')
xlabel('Error Signal Values')
ylabel('Count')
legend('3 bit','4 bit','5 bit')
%------------------------------------------------------------------------

% DPCM INTERFRAME TRANSMISSION
[errorSignal2, FY1, FY2, FY3, FY4, FY5, FY6] = encodeDPCMinter(movie, bits);
dpcmMovieInter = decodeDPCMinter(errorSignal2, info, FY1, FY2, FY3, FY4, FY5, FY6);
SQNR_DPCMInter = 20*log10(norm(double(movie2(:)))/norm(double(movie2(:))-double(dpcmMovieInter(:))));
AvgP_DPCMInter = rms(double(errorSignal2));

%-----------PLOT INTERFRAME VS INTRAFRAME TRANSMISSION----------------
[errorSignalTra9, FY1,FY2,FY3] = encodeDPCM(movie, 9);
[errorSignal_inter9, FY1, FY2, FY3, FY4, FY5, FY6] = encodeDPCMinter(movie, 9);
figure
histogram(errorSignalTra9,200,'FaceAlpha', 0.5, 'FaceColor', 'green','Normalization','count');
hold on
histogram(errorSignal_inter9,200,'FaceAlpha', 0.25, 'FaceColor', 'blue','Normalization','count')
hold off
title('DPCM INTERFRAME VS INTRAFRAME QUANTIZER HISTOGRAM')
xlim([-100 100])
ylabel('Count')
xlabel('DPCM Value')
legend('Intraframe 9-Bit','Interframe 9-Bit', 'FontSize', 20);

%-------------------------------------------------------------------

%perform DCT intraframe compression
%perform DCT intraframe compression
scale = 1; % Q = 50% will try 0.5, 1, and 2 with histograms
dctSignal = dct_compress(movie, scale, 0);
dctMovie = dct_receiver(dctSignal, info, scale, 0);

SQNR_DCT = 20*log10(norm(double(movie(:)))/norm(double(movie(:))-double(dctMovie(:))));
AvgP_DCT = rms(double(dctSignal(:)));

scale = 0.1;
dctSignal01 = dct_compress(movie, scale, 0);


scale = 10;
dctSignal10 = dct_compress(movie, scale, 0);


figure
histogram(dctSignal01, 'FaceAlpha', 0.25, 'FaceColor', 'blue','Normalization','count');
xlim([-30 30])
hold on
histogram(dctSignal,150, 'FaceAlpha', 0.25, 'FaceColor', 'green', 'Normalization','count');
hold on
histogram(dctSignal10, 'FaceAlpha', 0.25, 'FaceColor', 'red', 'Normalization','count');
hold off
title('DCT INTRAFRAME QUANTIZER HISTOGRAM')
xlabel('Error Signal Values')
ylabel('Count')
legend('Scale = 0.1','Scale = 1','Scale = 10')

dctMovie01 = dct_receiver(dctSignal01, info, 0.1, 0);
dctMovie = dct_receiver(dctSignal, info, 1, 0);
dctMovie10 = dct_receiver(dctSignal10, info, 10, 0);

figure
subplot(1,3,1)
imshow(dctMovie01(:,:,1));
title('DCT scale = 0.1');
subplot(1,3,2)
imshow(dctMovie(:,:,1));
title('DCT scale = 1');
subplot(1,3,3)
imshow(dctMovie10(:,:,1));
title('DCT scale = 10');



%----------PLOT DCT TRANSMISSION-----------------------------
dctSignal_9 = dct_compress(movie, scale, 1);
[errorSignal_9, FY1,FY2,FY3] = encodeDPCM(movie, 9);
figure
histogram(errorSignal_9,'FaceAlpha', 0.5, 'FaceColor', 'green','Normalization','count');
xlim([-64 64])
hold on
histogram(dctSignal_9,'FaceAlpha', 0.25, 'FaceColor', 'blue','Normalization','count');
hold off
title('DPCM VS DCT COMPRESSION HISTOGRAM')
ylabel('Count')
xlabel('Signal Value')
legend('Intraframe DPCM Signal','Intraframe DCT Signal (Q = 50)', 'FontSize', 20);
%------------------------------------------------------------------------


%-------------------------------------------------------------------------

%Perform lossless source coding (RLE+Huffman)
% IF ANY ERROR RETURNS: *UNTICK MATLAB WORKSPACE CHECKBOX FOR LIMIT MAX ARRAY SIZE*
% Matlab inefficiently uses doubles in huffman function so large ram needed but I convert
% them back to smaller data type so large ram/storage ssd needed for a bit

%[encodedSignal, dict] = sourceCoding(dctSignal);

%compressionRatio_DCT = length(X_true)/length(encodedSignal);

%perform source decoding (RLE+Huffman)
%decodedSignal = sourceDecoding(encodedSignal, dict, size(dctSignal));

% perform inverse dct method to produce video
%dctMovie = dct_receiver(decodedSignal, size(movie));
