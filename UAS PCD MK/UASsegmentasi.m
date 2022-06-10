clc;
clear;
close all

%Membaca file Citra Rgb
img = imread('mangga.jpg');

%Mengkonversi Citra rgb menjadi L*a*b
Lab =rgb2lab(img);

%Mengekstrak komponen a dan b dari citra L*a*b
ab = double(Lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2); 
ab = reshape(ab,nrows*ncols,2);

%Melakukan Segmentasi citra menggunakan Algoritma K-Means Clustering
numberOfClasses = 2;
indexes = kmeans(ab,numberOfClasses);
classImage = reshape(indexes,nrows,ncols);

%menghitung area setiap cluster
area = zeros(numberOfClasses,1);
for n = 1:numberOfClasses
    area(n) = sum(sum(classImage==n));
end

 %Mencari cluster dengan area terkecil
 [~,min_area] = min(area);
 bw = classImage==min_area;

 %Mengekstrak kompnen rgn dari citra rgb
 R = img(:,:,1);
 G = img(:,:,2);
 B = img(:,:,3);
 
 %Melakukan thresholding terhdap komponen blue
 bw2 = ~imbinarize(B);

 %Melakukan operasi pengurangan (substaksi)
 bw3 = imsubtract(bw2,bw);

 %Operasi morfologi untuk menyempurnakan hasil segmentasi
 bw4 = bwareaopen(bw3,500);

 %menampilkan citra hasil segmnetasi
 R(~bw4) = 0;
 G(~bw4) = 0;
 B(~bw4) = 0;
 RGB = cat(3,R,G,B);
 
figure
subplot (2,4,1),imshow(img);title('Citra Asli');
subplot (2,4,2),imshow(Lab);title('Konversi RGB to L*a*b');
subplot (2,4,3),imshow(classImage,[]);title('Segmentasi K-Means');
subplot (2,4,4),imshow(bw);title('Mencari Kluster Area Terkecil');
subplot (2,4,5),imshow(bw2);title('Thresholding');
subplot (2,4,6),imshow(bw3);title('Substraksi');
subplot (2,4,7),imshow(bw4);title('Morfologi');
subplot (2,4,8),imshow(RGB);title('Hasil Segmentasi');
