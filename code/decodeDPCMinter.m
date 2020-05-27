function dpcmMovie = decodeDPCMinter(errorSignal, info, FY1, FY2, FY3, FY4, FY5, FY6)
errorMovie = reshape(errorSignal, info);
X_hat = zeros(info); dpcmMovie = X_hat;
for frameLoc = 2:info(3)
    for rowLoc=1:info(1)
        for colLoc= 1:info(2)
            if rowLoc==1
                if colLoc==1
                    X_pred = 0;
                else
                    X_pred = FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
                end
            elseif colLoc == 1
                if rowLoc==1
                    X_pred = 0;
                else
                    X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) + FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
                end
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1,frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1,frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1) + FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            end
            dpcmMovie(rowLoc,colLoc, frameLoc) = X_pred + errorMovie(rowLoc,colLoc,frameLoc);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorMovie(rowLoc,colLoc, frameLoc);
        end
        for colLoc=(colLoc+1):info(2)
            if rowLoc==1
                    X_pred = FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            else
                X_pred = FY2*X_hat(rowLoc-1,colLoc, frameLoc) +  FY1*X_hat(rowLoc,colLoc-1, frameLoc) + FY3*X_hat(rowLoc-1,colLoc-1, frameLoc) + FY4*X_hat(rowLoc,colLoc-1, frameLoc-1) + FY5*X_hat(rowLoc-1,colLoc, frameLoc-1) + FY6*X_hat(rowLoc,colLoc, frameLoc-1);
            end
            dpcmMovie(rowLoc,colLoc, frameLoc) = X_pred + errorMovie(rowLoc,colLoc,frameLoc);
            X_hat(rowLoc,colLoc, frameLoc) = X_pred + errorMovie(rowLoc,colLoc, frameLoc);
        end
    end
end
dpcmMovie = dpcmMovie(2:end,2:end,:);
dpcmMovie = cast(dpcmMovie, 'uint8');
end