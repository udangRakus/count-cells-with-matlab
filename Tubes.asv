%% Baca gambar sample %%
sample = imread('K10.jpg');
%=========  grayscale =========%
% mengubah warna sample menjadi abu-abu %
sampleChange = rgb2gray(sample); 
figure, imshow(sampleChange), title('Grayscale')

%% Mengubah Saturasi warna gambar %%
%========== ostu ============%
[baris, kolom] = size(sampleChange);
level = graythresh(sampleChange)*256; %% batas warna
level_otsu = zeros(baris, kolom);
for i = 1:baris
    for j = 1:kolom
        if sampleChange(i,j) < level
            level_otsu(i,j) = 1;
        end
    end
end
figure, imshow(level_otsu), title('Otsu')
%% Pre-Processing %%
%====== median filter ======%
sampleChange2 = medfilt2(level_otsu, [8 8]);
figure, imshow(sampleChange2), title('Noise reduce with median filter')
%% Edge detection %%
%====== morphology =======%
SE = strel('disk',5);
sampleDilate = imerode(sampleChange2,SE);
sampleChange3 = xor(sampleDilate,sampleChange2);
figure, imshow(sampleChange3), title('Edge detection with morphology')
%% Labeling %%
[label,num] = bwlabel(sampleDilate,4);
figure, vislabels(label), title('Labeling')
%% Seleksi kriteria sel %%
cellsCriteria = regionprops('table', label, 'Area','Perimeter','Eccentricity'); 
index = find(cellsCriteria.Area > 1500 & cellsCriteria.Area < 3000  & cellsCriteria.Perimeter > 140 & cellsCriteria.Perimeter < 280);
finalSample = zeros(size(label));

k = length(index);
for i=1:k
    finalSample(label==(index(i)))= 1;
end

figure, imshow(finalSample), title('Final Cells')

% Untuk mengambil tepi finalSample menggunakan morphology %
SE2 = strel('disk',2);
sampleDilate2 = imdilate(finalSample,SE2);
sampleEdge = xor(sampleDilate2,finalSample);

[label2,num2] = bwlabel(sampleDilate2,4);
figure, vislabels(label2), title('Final Cells label')

sampleFinalOverlay = imOverlay(sample,sampleEdge, [0 0 1]);
figure, imshow(sampleFinalOverlay), title('Final Cells Overlay')
