gambarAsli = imread('Kasus2.jpg');
F = imread('Kasus2.jpg');
%figure, imshow(gambarAsli), title('Citra Asli')
%1===========================GRAYSCALE=========================
B = rgb2gray(gambarAsli); %mengubah citra RGB menjadi citra graylevel

folder = 'D:\.Semester 5\Informatika medis\matlab\TugasKelompok2';
imwrite(B,fullfile(folder,'grayKasus2.jpg')); %menyimpan hasil konversi sebagai citra
%figure, imshow(B),title('Grayscale')
%2========================TRESHOLD-OTSU==================================
[baris, kolom] = size(B);
g = zeros (baris, kolom);

for i = 1:baris
    for j = 1:kolom
        if B(i,j) < 225
            g(i,j) = 1;
    end;
    end  
end;
g = logical(g);
%figure, imshow(g), title('Otsu')
imwrite(g,fullfile(folder,'Otsu.jpg')); %menyimpan hasil konversi sebagai citra
%3=================IMFILL=========================
citraFill = imfill(g,'holes');
Area_citraFill=regionprops(citraFill,'area'); %segmented binary

imwrite(citraFill,fullfile(folder,'imfill.jpg')); %menyimpan hasil konversi sebagai citra

%figure, imshow(citraFill), title('Imfill')
%4==================TEPI=========================
C = imread('imfill.jpg');
%mengambil ukuran baris kolom dari matriks B
[r,c] = size(C);
%inisialisasi matriks
Gx = zeros(r,c);
Gy = zeros(r,c);
G = zeros(r,c);
%kernel sesuai operator Sobel
sx = (1/8)*[-1 0 1; -2 0 2; -1 0 1];
sy = (1/8)*[1 2 1; 0 0 0; -1 -2 -1];

%operasi konvolusi dengan memastikan ouput berdimensi sama dngan citra asli
Gx = conv2(double(C),sx,'same');
Gy = conv2(double(C),sy,'same');
absGx = uint8(abs(Gx));
absGy = uint8(abs(Gy));
%memastikan Gx dan Gy bertipe data unsigned integer 8 bit, didalamanya
%terdapat proses pembulatan nilai hasil konvolusi
Gx = uint8(Gx);
Gy = uint8(Gy);
G = absGx+absGy;

imwrite(G,fullfile(folder,'TepiSobel.jpg'));
%figure, imshow(G), title('Tepi')
%5==========================SEGMENTED WARNA========================
segmentedWarna = zeros(r,c,3);
for i = 1:r
    for j = 1:c
        if citraFill(i,j)
            segmentedWarna(i,j,:) = F(i,j,:);
        end
    end
end

segmentedWarna = uint8(segmentedWarna);
imwrite(segmentedWarna,fullfile(folder,'Kasus2 segmented color.jpg'));
%figure, imshow(segmentedWarna), title('Segmented Warna')
%======================SEL DENGAN LABEL================
T = imread('imfill.jpg');

[r,c] = size(T);

N = im2bw(T); %pindah gambar ke biner
M = bwlabel(N,4); %memberikan label (index)

[M,num] = bwlabel(M)
imwrite(M,fullfile(folder,'Sel berlabel.jpg'));
%figure, subplot(1,2,1),imshow(citraFill), title('Imfill'),...
   % subplot(1,2,2), imshow(M), title('Sel berlabel')

%=========================EKSTRAKSI CIRI==========================
U = imread('Kasus2 segmented color.jpg');
[r,c] = size(U);
p = im2bw(U);
[L,num] = bwlabel(p,4)

MeanR = regionprops('table',L,U(:,:,1),'MeanIntensity');
MeanG = regionprops('table',L,U(:,:,2),'MeanIntensity');
MeanB = regionprops('table',L,U(:,:,3),'MeanIntensity');

FiturWarna = [MeanR.MeanIntensity MeanG.MeanIntensity MeanB.MeanIntensity]

ShapeDescp = regionprops('table',L,'Perimeter','Area','MajorAxisLength','MinorAxisLength','Centroid','Orientation')

Roundness = (ShapeDescp.Perimeter).^2./(4*pi*ShapeDescp.Area)

Ciri = [FiturWarna ShapeDescp.Area ShapeDescp.Perimeter Roundness ShapeDescp.Centroid]

%7===============================SEL BULAT===========================
indeksTrombosit = find(Ciri(:,1)>189 & Ciri(:,3)>177 & Ciri(:,6)<0.96)

cc = bwconncomp(L); 
stats = indeksTrombosit; 
selBulat = ismember(labelmatrix(cc), stats);
imwrite(selBulat,fullfile(folder,'Sel Bulat.jpg'));

%8===============================SEL TIDAK BULAT===========================

indeksSelTidakBulat = find(Ciri(:,3)>198)
aa = bwconncomp(L); 
statsz = indeksSelTidakBulat; 
selTidakBulat = ismember(labelmatrix(aa), statsz);
imwrite(selTidakBulat,fullfile(folder,'Sel Tidak Bulat.jpg'));
figure, subplot(1,2,1), imshow(selBulat), title('Sel Bulat'),...
    subplot(1,2,2), imshow(selTidakBulat), title('Sel tidak bulat')
%9===============================CENTROID>100===========================
indeksCentroid1 = find(Ciri(:,7)>100)
ff = bwconncomp(L); 
statsa = indeksCentroid1; 
selCentroid1 = ismember(labelmatrix(ff), statsa);
imwrite(selCentroid1,fullfile(folder,'Centroid lebih dari 100.jpg'));

%10=======================CENTROID<100==================================
indeksCentroid2 = find(Ciri(:,7)<100)
fff = bwconncomp(L); 
statsaa = indeksCentroid2; 
selCentroid2 = ismember(labelmatrix(fff), statsaa);
imwrite(selCentroid2,fullfile(folder,'Centroid kurang dari 100.jpg'));

figure,subplot(1,2,1),imshow(selCentroid1), title('Centroid > 100'), subplot(1,2,2),imshow(selCentroid2), title('Centroid < 100')

%=============================HASIL TAMPILAN KESELURUHAN================
    subplot(4,3,1), imshow(gambarAsli), title('Citra Asli'),...
    subplot(4,3,2), imshow(g),title('Otsu'),...
    subplot(4,3,3), imshow(citraFill), title('Imfill'),...
    subplot(4,3,4), imshow(G), title('Tepi'),...
    subplot(4,3,5), imshow(segmentedWarna), title('SegmentedWarna'),...
    subplot(4,3,6), imshow(M), title('Labelled cells'),...
    subplot (4,3,7), imshow(selBulat), title('Sel Berbentuk Bulat'),...
    subplot(4,3,8), imshow(selTidakBulat), title('Sel tidak bulat'),...
    subplot(4,3,10), imshow(selCentroid1), title('Centroid > 100')
    subplot(4,3,11), imshow(selCentroid2), title('Centroid < 100')
