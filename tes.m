A = imread('K8.jpg'); %read file
B = rgb2gray(A);
[baris, kolom] = size(B);
figure, imshow(B)
%----otsu----
level = graythresh(B)*256; %% batas warna
level_otsu = zeros(baris, kolom);
for i = 1:baris
    for j = 1:kolom
        if B(i,j) < level
            level_otsu(i,j) = 1;
        end
    end
end
figure, imshow(level_otsu), title('Otsu')
%=========== imfill ========%
citraFill = imfill(level_otsu,'holes');
figure, imshow(citraFill);