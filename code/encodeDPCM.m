function [errorSignal, FY1, FY2, FY3] = encodeDPCM(movie, bits)
firstFrame = movie(:,:,1);
info = size(movie);
% for k=2:2:info(1) % go through all even rows and flip them left right
%     firstFrame(k,:) = flip(firstFrame(k,:));
% end
X = transpose(firstFrame); % transpose video such that
X = X(:); % save to X Signal
X = cast(X,'double'); % To perform calculations later on, must be double type and not integer 8bit
Y1 = circshift(X,1);
Y2 = circshift(X,info(2));
Y3 = circshift(X, info(2)+1);
detM=det([mean(Y1.^2) mean(Y1.*Y2) mean(Y1.*Y3); mean(Y1.*Y2) mean(Y2.^2) mean(Y2.*Y3); mean(Y1.*Y3) mean(Y2.*Y3) mean(Y3.^2)]); % derived matrix discriminant value
detA=det([mean(X.*Y1) mean(Y1.*Y2) mean(Y1.*Y3); mean(X.*Y2) mean(Y2.^2) mean(Y2.*Y3); mean(X.*Y3) mean(Y2.*Y3) mean(Y3.^2)]); % disc. for Y1 constant
detB=det([mean(Y1.^2) mean(X.*Y1) mean(Y1.*Y3); mean(Y1.*Y2) mean(X.*Y2) mean(Y2.*Y3); mean(Y1.*Y3) mean(X.*Y3) mean(Y3.^2)]); % disc. for Y2 constant  
detC= det([mean(Y1.^2) mean(Y1.*Y2) mean(X.*Y1); mean(Y1.*Y2) mean(Y2.^2) mean(X.*Y2); mean(Y1.*Y3) mean(Y2.*Y3) mean(X.*Y3)]); % disc. for Y3 constant
FY1 = detA/detM; FY2=detB/detM; FY3=detC/detM;
%clear X Y1 Y2 Y3 detA detB detC detM
%X_hat = (FY1).*Y1+(FY2).*Y2+(FY3).*Y3; % create X_hat array from derived formulas
%errorSig_model_intra = X-X_hat; % create error signal
%figure;histogram(errorSig_model_intra, 2^bits);
movie = cast(movie, 'double');
X_hat = zeros(info); errorSignal=X_hat;
for frameLoc = 1:info(3)
    for rowLoc=1:info(1)
        for colLoc=1:info(2)
            if rowLoc==1
                if colLoc==1
                    X_pred = 0;
                else
                    X_pred = FY1*X_hat(rowLoc,colLoc-1, frameLoc);
                end
            elseif colLoc==1
                if rowLoc == 1
                    X_pred = 0;
                else
                    X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc);
                end
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1,frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1,frameLoc);
            end
            error_pixel = movie(rowLoc,colLoc, frameLoc) - X_pred;
            errorSignal(rowLoc,colLoc, frameLoc) = signedQuantizer(error_pixel, bits);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorSignal(rowLoc,colLoc, frameLoc);
        end
        for colLoc=(colLoc+1):info(2)
            if rowLoc==1
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc);
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1, frameLoc);
            end
            error_pixel = movie(rowLoc,colLoc, frameLoc) - X_pred;
            errorSignal(rowLoc,colLoc, frameLoc) = signedQuantizer(error_pixel, bits);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorSignal(rowLoc,colLoc, frameLoc);
        end
    end
end
errorSignal = errorSignal(:);
end