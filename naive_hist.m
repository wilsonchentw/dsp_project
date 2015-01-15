function naive_hist(root, filelist, svmpath, modelpath)

addpath(svmpath);

fd = fopen(filelist);
data = textscan(fd, '%s %d');
fclose(fd);

h = 80;
w = 80;
c = 3;

imgArray = [];
for idx=1:size(data{1}, 1)/100
    img = imread(fullfile(root, data{1}{idx}));
    imgArray(:,:,:,idx) = imresize(img, [h w]);
end
meanImg = mean(imgArray, 4);
stdImg = std(imgArray, 1, 4);

features = [];
for idx=1:size(imgArray, 4)
    img = (imgArray(:,:,:,idx)-meanImg)./stdImg;
    features = [features ; sparse(reshape(img, 1, []))];
end
label = double(data{2}(1:size(features, 1)));

model = train(label, features);
[predict_label, acc, ans] = predict(label, features, model);
save(modelpath, 'model');