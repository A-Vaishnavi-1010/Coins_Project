%Vaishnavi Agrawal
%MATLAB code to claculate the number of coins present in given image and
%calculating area of each coin in terms of number of pixels occupied by
%each coin

clc;
close all;
clear all;

%taking an image
I = imread('coins.jfif');
subplot 231
imshow(I)
title('Original Image')

%converting RGB image to gray scale
I_gray=rgb2gray(I);
subplot 232
imshow(I_gray)
title('Gray image')

% plotting histogram to find threshold values
subplot 233
imhist(I_gray);
title("histogram");

% %converting gray image to binary image according to the threshold
% %obtained by observing histogram of gray image
% [m,n]=size(I_gray);
% Ib = zeros(m,n)
% for i=1:m
%     for j=1:n
%         if I_gray(i,j) < 200        
%             Ib(i,j)=1;
%         else
%             Ib(i,j)=0;
%         end
%     end
% end

%to obtain more accurate results otsu's method is applied here

%converting gray image to binary image by the threshold calculated by
%otsu's method which is based on global threshold which is calculated by
%calculating inter class variance

threshold = graythresh(I_gray);
Ib =~im2bw(I_gray,threshold);
subplot 234
imshow(Ib)
title('binary image')

%dilation of image to fill the holes in the image
%here double dilation is applied to obtain better results
[m,n] = size(Ib)
I_d = zeros(m,n);
for i = 2 : m-1
     for j = 2 : n-1
         if(Ib(i,j)==1 || Ib(i+1,j)==1 || Ib(i,j+1)==1 || Ib(i+1,j+1)==1)
             I_d(i,j)=1;
         end
     end    
end

I_dd = zeros(m,n);
for i = 2 : m-1
     for j = 2 : n-1
         if(I_d(i-1,j)==1 || I_d(i+1,j)==1 || I_d(i,j+1)==1 || I_d(i,j-1)==1)
             I_dd(i,j)=1;
         end
     end    
end

subplot 235
imshow(I_dd)
title('Dilated image')

%algorithm to find connected components in an image

B=[1,1,1; 1,1,1; 1,1,1]      %defining structuring element
A=I_dd;   

%Finding a non-zero element's position.
p=find(A==1);
p=p(1);
%defining a matrix to label different coins
Label=zeros(m, n);
N=0;

while(~isempty(p))
    N=N+1;              %Label for each component
    p=p(1);
    X=false(m,n);
    X(p)=1;

    %calculating intersection of image A and dilated image X
    Y=A&imdilate(X,B);

    while(~isequal(X,Y))
        X=Y;
        Y=A&imdilate(X,B);
    end
    
    Pos=find(Y==1);
    A(Pos)=0;

    %Labeling the components
    Label(Pos)=N;
    p=find(A==1);

end

subplot 236
imshow(Label)
title('Label image')

%calculating the area of each coin (in terms of number of pixels)

coin_area=zeros(1,N)        %array to store area of coins
for i = 1:N
    for j = 1:m
        for k = 1:n
            if(Label(j,k) == i)
                coin_area(1,i) = coin_area(1,i) + 1;
            end
        end
    end
end

%printing the area and number of coins
for i = 1:N
    sprintf('coin %d area = %d', i, coin_area(1,i))
end
sprintf('Total number of coins: %d', N)