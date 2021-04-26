% imageDirectory = '1-UnderFilled/';
imageDirectory = '2-OverFilled/';
% imageDirectory = '3-NoLabel/';
% imageDirectory = '4-NoLabelPrint/';
% imageDirectory = '5-LabelNotStraight/';
% imageDirectory = '6-CapMissing/';
% imageDirectory = '7-DeformedBottle/';
% imageDirectory = 'All/';
% imageDirectory = 'Combinations/';
% imageDirectory = 'MissingBottle/';
%%
% fprintf('%s', imageDirectory);


%Creating directory for reading the files present in folder
%Initializing value to 0 for performing count operation
%%
dataFile = dir(fullfile(imageDirectory,'*.jpg'));

total_bottle_missing = 0;
total_bottle_underfilled = 0;
total_bottle_overfilled = 0;
total_label_not_present = 0;
total_label_no_print = 0;
total_cap_missing = 0;
total_label_not_straight = 0;
total_bottle_deformed = 0;
%%

%Total count of items present in the defective items folder obtained by
%performing a manual count in individual respective folders
%%
count_of_bottle_missing = 11;
count_of_underfilled = 10;
count_of_overfilled = 10;
count_of_labelNotPresent = 10;
count_of_labelNotPrinted = 10;
count_of_capMissing = 10;
count_of_labelNotStraight = 10;
count_of_bottleDeformed = 10;
%%

%Loop for reading the files and incrementing counter for defective items
%detected in the individual folders
%%
for i = 1:length(dataFile)
    file = fullfile(imageDirectory, dataFile(i).name);
    image = imread(file);
    %     imshow(image)
    %     pause(2);
    
    %Calling function to checking missing bottle and incrementing counter to check the total number of missing bottles
    bottlemissing = bottleMissing(image);
    if bottlemissing
        total_bottle_missing = total_bottle_missing + 1;
        continue
    end
    
    %Calling function to check underfilled bottles and incrementing counter
    %to check the total number of underfilled bottles
    underfilled = isUnderFilled(image);
    if underfilled
        total_bottle_underfilled = total_bottle_underfilled + 1;
    end
    
    %Calling function to check overfilled bottles and incrementing counter 
    %to check the total number of overfilled bottles
    overfilled = isOverFilled(image);
    if overfilled
        total_bottle_overfilled = total_bottle_overfilled + 1;
    end
    
    %Calling function to check if bottle has no label and incrementing 
    %counter to check the total number of bottles with no label
    nolabel = noLabel(image);
    if nolabel 
        total_label_not_present = total_label_not_present + 1;
    end
    
    %Calling function to check bottles with no label print and incrementing
    %counter for the total number of defective bottles
    nolabelprint = noLabelPrint(image);
    if nolabelprint
        total_label_no_print = total_label_no_print + 1;
    end
    
    %Calling function to check bottles with missing cap and incrementing
    %counter for obtaining the total number of bottles with missing caps
    iscapmissing = capMissing(image);
    if iscapmissing
        total_cap_missing = total_cap_missing + 1;
    end
    
    %Calling function to check bottles with label not straight and 
    %incrementing counter to find total number of bottles with labels
    %not straight
    labelnotstraight = labelNotStraight(image);
    if labelnotstraight && ~nolabel && ~nolabelprint && ~bottledeformed
        total_label_not_straight = total_label_not_straight + 1;
    end
    
    %Calling function to check deformed bottles and incrementing counter to
    %find total number of deformed bottles
    bottledeformed = isBottleDeformed(image);
    if bottledeformed
        total_bottle_deformed = total_bottle_deformed + 1;
    end
         
end
%%


%%
%This is to calculate Precision value for for a defect
%Checks if there is an overlap in other defects when trying to find one
%defects in one folder
false_positive = total_bottle_missing + total_bottle_underfilled + total_bottle_overfilled + total_label_not_present + total_label_no_print + total_cap_missing + total_label_not_straight + total_bottle_deformed;
%%


% Printing the total count of defects in each image subset
%For combinations printing ground truth vs detected value for comparison
%%
if ~isequal(imageDirectory, 'Combinations/')
    fprintf('Total number of bottles missing %d \n', total_bottle_missing);
    fprintf('Total number of bottles underfilled %d \n',total_bottle_underfilled);
    fprintf('Total number of bottles overfilled: %d \n',total_bottle_overfilled);
    fprintf('Total number of bottles with label not found: %d \n', total_label_not_present);
    fprintf('Total number of bottles with no label print: %d \n', total_label_no_print);
    fprintf('Total number of bottles with no cap: %d \n', total_cap_missing);
    fprintf('Total number of bottles with label not straight: %d \n', total_label_not_straight);
    fprintf('Total number of bottles deformed: %d \n\n', total_bottle_deformed);
end
%%

%Groundtruth values for combinations folder
%%
combination_totalBottleMissing = 1;
combination_totalUnderfilled = 3;
combination_totalOverfilled = 4;
combination_totalLabelNotFound = 1;
combination_totalLabelNotPrinted = 3;
combination_totalNoCap = 5;
combination_labelNotStraight = 3;
combination_bottleDeformed = 1;
%%


%Section to determine Accuracy for defect in individual folders
%%
if isequal(imageDirectory, 'MissingBottle/')
    fprintf('Accuracy of Bottle Missing: %d \n',(total_bottle_missing/count_of_bottle_missing) .* 100);
    fprintf('Precision value for Bottle Missing: %d \n',(total_bottle_missing/(false_positive+count_of_bottle_missing-total_bottle_missing)).* 100);
elseif isequal(imageDirectory, '1-UnderFilled/')
    fprintf('Accuracy of Underfilled Bottles: %.2f \n', (total_bottle_underfilled/count_of_underfilled)*100);
    fprintf('Precision value for Underfilled Bottles: %.2f \n', (total_bottle_underfilled/(false_positive+count_of_underfilled-total_bottle_underfilled))*100);
elseif isequal(imageDirectory, '2-OverFilled/')
    fprintf('Accuracy of Overfilled Bottles: %.2f \n', (total_bottle_overfilled/count_of_overfilled)*100);
    fprintf('Precision value for Overfilled Bottles: %.2f \n', (total_bottle_overfilled/(false_positive+count_of_overfilled-total_bottle_overfilled))*100);
elseif isequal(imageDirectory, '3-NoLabel/')
    fprintf('Accuracy of Bottles with no label present: %.2f \n', (total_label_not_present/count_of_labelNotPresent).*100);
    fprintf('Precision value for cap missing: %.2f \n', (total_label_not_present/(count_of_labelNotPresent+false_positive-total_label_not_present)).*100);
elseif isequal(imageDirectory, '4-NoLabelPrint/')
    fprintf('Accuracy of Bottles with label not printed: %.2f \n', (total_label_no_print/count_of_labelNotPrinted).*100);
    fprintf('Precision value for cap missing: %.2f \n', (total_label_no_print/(count_of_labelNotPrinted+false_positive-total_label_no_print)).*100);
elseif isequal(imageDirectory, '5-LabelNotStraight/')
    fprintf('Accuracy of Bottles with labels not straight: %.2f \n', (total_label_not_straight/count_of_labelNotStraight).*100);
    fprintf('Precision value for of cap missing: %.2f \n', (total_label_not_straight/(count_of_labelNotStraight+false_positive-total_label_not_straight)).*100);
elseif isequal(imageDirectory, '6-CapMissing/')
    fprintf('Accuracy of cap missing: %.2f \n', (total_cap_missing/count_of_capMissing).*100);
    fprintf('Precision value for cap missing: %.2f \n', (total_cap_missing/(count_of_capMissing+false_positive-total_cap_missing)).*100);
elseif isequal(imageDirectory, '7-DeformedBottle/')
    fprintf('Accuracy of deformed bottle: %.2f \n', (total_bottle_deformed/count_of_bottleDeformed).*100);
    fprintf('Precision value for deformed bottle: %.2f \n', (total_bottle_deformed/(count_of_bottleDeformed+false_positive-total_bottle_deformed-total_label_not_straight)).*100);
elseif isequal(imageDirectory, 'Combinations/')
    fprintf('Detected: %d \t GroundTruth: %d \n', total_bottle_missing, combination_totalBottleMissing);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_bottle_underfilled, combination_totalUnderfilled);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_bottle_overfilled, combination_totalOverfilled);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_label_not_present, combination_totalLabelNotFound);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_label_no_print, combination_totalLabelNotPrinted);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_label_not_straight, combination_labelNotStraight);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_cap_missing, combination_totalNoCap);
    fprintf('Detected: %d \t Groundtruth: %d \n', total_bottle_deformed, combination_bottleDeformed);    
end
%%


%Function to check if bottle is missing
%%
function bottlemissing = bottleMissing(image)
bottlemissing = 0;
image = rgb2gray(image);
bottleIndex = [121.5 , 2.5, 122, 282];
image = imcrop(image, bottleIndex);
filter = image > 100;
blackPresence = (1-nnz(filter)/numel(filter))*100;
%     fprintf('%d \n',blackPresence);
%     imshow(filter)
%     pause(2);
if blackPresence < 2
    bottlemissing = 1;
end
end
%%


%Function to check if bottle is underfilled
%%
function underfilled = isUnderFilled(image)
underfilled = 0;
image = rgb2gray(image);
%     filledSpacedIndex = [115, 136, 238-115, 164-136];
filledSpacedIndex = [115, 136, 123, 28];
%     image = image(130:166, 113:238);
image = imcrop(image, filledSpacedIndex);
image = image > 100;
emptySpace = (nnz(image)/ numel(image)) * 100 ;
%     fprintf('%d \n',emptySpace);
%     pause(2);
if emptySpace > 90
    %     if emptySpace == 100
    underfilled =  1;
end
end
%%


%Function to check if bottle is overfilled
%%
function overfilled = isOverFilled(image)
overfilled = 0;
%     image = rgb2gray(image);
filledSpaceIndex = [119, 62, 108, 68];
% filledSpaceIndex = [110.5 100.5 111 30];
image = imcrop(image, filledSpaceIndex);
    imshow(image);
    pause(3);
blackPresence = (nnz(~image)/ numel(image)) * 100 ;
whitePresence = (nnz(image)/ numel(image)) * 100 ;
% fprintf('blackPresence: %d \n',blackPresence);
% fprintf('whitePresence: %d \n',whitePresence);
% pause(2);
if (blackPresence > 1.2) && (whitePresence>95)
    %         fprintf('inloop');
    overfilled = 1;
end
end
%%

%Function to check if there is no label
%%
function nolabel = noLabel(image)
nolabel = 0;
%     greyImage = rgb2gray(image);
%     labelIndex = [115,181,244-115,283-181];
labelIndex = [115, 181, 129, 102];
image = imcrop(image, labelIndex);
blackPercentage = (nnz(~image)/numel(image))*100;
%     fprintf('%f \n', blackPercentage);
%     pause(1);
if blackPercentage > 19
    nolabel = 1;
end
end
%%


%Function to check if label is not printed
%%
function nolabelprint = noLabelPrint(image)
nolabelprint = 0;
%     greyImage = rgb2gray(image);
labelIndex = [106, 176, 132, 99];
image = imcrop(image, labelIndex);
whitePercentage = nnz(image) / numel(image) * 100;
blackPercentage = nnz(~image) / numel(image) * 100;
%     fprintf('%d \n', whitePercentage);
%     fprintf('%d \n', blackPercentage);
%     pause(2);
if (whitePercentage > 98) && (blackPercentage < 1.3)
    nolabelprint = 1;
end
end
%%


%Function to check if cap is missing
%%
function iscapmissing = capMissing(image)
iscapmissing = 0;
%     capIndex = [148, 9, 208-148, 50-9];
capIndex = [142, 3, 65, 54];
image = imcrop(image, capIndex);
%if red color presence is less than the set threshold, bottle 
red = image(:,:,1)>=130 & image(:,:,2)<=60 & image(:,:,3)<=100;
totalRedPresence = sum(sum(red));
if totalRedPresence < 5
    iscapmissing  = 1;
end
end
%%


%Function to check if label is straight
%%
function labelnotstraight = labelNotStraight(image)
labelnotstraight = 0;
%     image = imcrop(image, labelIndex);
%     bw = rgb2gray(image);
% index_below_white_strip = imcrop(image, [113.5 186.5 125 97]);
label_index = image(183:185, 115:237);
label_index = label_index>100;
total_white = (nnz(label_index)/numel(label_index))*100;
if (total_white ~= 100) 
    %&& (totalRed > 1903000 && totalRed < 2740000) && (blackChannel > 0.028 && blackChannel < 0.095)
    labelnotstraight=1;
end
end
%%


%Function to check if bottle is deformed
%%
function bottledeformed = isBottleDeformed(image)
bottledeformed = 0;
%Comparing re
normal_image = imread('Normal\normal-image001.jpg');
bottleIndex = [114.5, 57.5, 124, 231];

normal_bottle = imcrop(normal_image, bottleIndex);
reference_hist = imhist(normal_bottle);

deformed_bottle_image = imcrop(image, bottleIndex);
histogram = imhist(deformed_bottle_image);

difference = pdist2(reference_hist, histogram, 'cityblock');
difference = sum(sum(difference));
% fprintf('%d \n', difference);
% pause(3);
if difference < 11841800
    bottledeformed = 1;
end
end
%%

