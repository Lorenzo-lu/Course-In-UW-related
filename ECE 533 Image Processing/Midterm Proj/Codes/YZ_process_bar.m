

function YZ_process_bar(ratio)
    title = ['Be Patient, BeneFactor...|'];
    L = 50;
    fprintf(repmat('\b',1,L + length(title) + 1 + 6 + 1)); % '|' 1 digit, 90.00% has 6 digits, \n 1 digit
    for k = 1:L
        if floor(ratio * L) >= k
            title(end+1) = '1';
        else
            title(end+1) = '0';
        end
    end
    
    title(end+1) = '|';
    percent = [num2str(100*ratio,'%.2f'),'%%'];
    title(end+1: end+length(percent)) = percent;
    fprintf(title);
    fprintf('\n');
end