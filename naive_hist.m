function naive_hist(root, trainlist, testlist, svmpath, modelpath)

addpath(svmpath);

h = 80;
w = 80;
c = 3;

fd = fopen(trainlist);
data = textscan(fd, '%s %d');
fclose(fd);

% Training phase
features = [zeros(size(data{1}, 1), w*h*c)];
sumImg = zeros(80, 80, 3);
sqrsumImg = zeros(80, 80, 3);
for idx=1:size(data{1}, 1)
    if (mod(idx, 100) == 0) 
        fprintf(1, '#%d file\n', idx);
    end
    img = imresize(imread(fullfile(root, data{1}{idx})), [h w]);
    sumImg = sumImg + double(img);
    sqrsumImg = sqrsumImg + double(img.^2);
    features(idx,:) = double(reshape(img, 1, []));
end
meanVector = reshape(sumImg/size(data{1}, 1), 1, []);
stdVector = reshape(sqrsumImg/size(data{1}, 1), 1, [])-meanVector.^2;
features = features-repmat(meanVector, size(features, 1), 1);
features = features./repmat(stdVector, size(features, 1), 1);
features = sparse(features);
label = double(data{2}(1:size(features, 1)));
model = train(label, features);
[predict_test, train_acc, ans] = predict(label, features, model);

% Testing phase
fd = fopen(testlist);
data = textscan(fd, '%s %d');
fclose(fd);

features = [zeros(size(data{1}, 1), w*h*c)];
for idx=1:size(data{1}, 1)
    if (mod(idx, 100) == 0) 
        fprintf(1, '#%d file\n', idx);
    end
    img = imresize(imread(fullfile(root, data{1}{idx})), [h w]);
    features(idx,:) = double(reshape(img, 1, []));
end
features = features-repmat(meanVector, size(features, 1), 1);
features = features./repmat(stdVector, size(features, 1), 1);
features = sparse(features);
label = double(data{2}(1:size(features, 1)));

[predict_test, test_acc, ans] = predict(label, features, model);
save(modelpath, 'model');
end
