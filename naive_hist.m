function naive_hist(root, trainlist, testlist, svmpath, modelpath)

addpath(svmpath);

h = 80;
w = 80;
c = 3;

fd = fopen(trainlist);
data = textscan(fd, '%s %d');
fclose(fd);

% Training phase
trainFeatures = [];
sumImg = zeros(80, 80, 3);
sqrsumImg = zeros(80, 80, 3);
for idx=1:size(data{1}, 1)
    if (mod(idx, 100) == 0) 
        fprintf(1, '#%d file\n', idx);
    end
    img = imresize(imread(fullfile(root, data{1}{idx})), [h w]);
    sumImg = sumImg + double(img);
    sqrsumImg = sqrsumImg + double(img.^2);
    trainFeatures = [trainFeatures ; double(reshape(img, 1, []))];
end
meanVector = reshape(sumImg/size(data{1}, 1), 1, []);
stdVector = reshape(sqrsumImg/size(data{1}, 1), 1, [])-meanVector.^2;
trainFeatures = trainFeatures-repmat(meanVector, size(trainFeatures, 1), 1);
trainFeatures = trainFeatures./repmat(stdVector, size(trainFeatures, 1), 1);
trainFeatures = sparse(trainFeatures);
trainLabel = double(data{2}(1:size(trainFeatures, 1)));

model = train(trainLabel, trainFeatures);
[predict_train, train_acc, ans] = predict(trainLabel, trainFeatures, model);
[predict_test, train_acc, ans] = predict(trainLabel, trainFeatures, model);
save(modelpath, 'model');
end
