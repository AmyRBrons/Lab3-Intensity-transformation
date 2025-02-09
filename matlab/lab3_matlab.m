%Task 1: Contrast enhancement with function adjust
%importing an image
clear all
imfinfo('assets/breastXray.tif')
f = imread('assets/breastXray.tif');
imshow(f)

%check the dimension of f
f = imread('assets/breastXray.tif');
f(3,10)
imshow(f(1:241,:)) %display half

%find min and max intensity values
f = imread('assets/breastXray.tif');
[fmin, fmax] = bounds(f(:))

%test yourself
imshow(f(:,241:482))

%negative image
f = imread('assets/breastXray.tif');
g1 = imadjust(f, [0 1], [1 0])
figure                       
imshowpair(f, g1, 'montage')

%gamma correction
f = imread('assets/breastXray.tif');
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})

%Task 2: Contrast-stretching transformation
clear all       
close all       
f = imread('assets/bonescan-front.tif');
r = double(f);  % uint8 to double conversion
k = mean2(r);   % find mean intensity of image
E = 0.9;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
g = uint8(255*s);
imshowpair(f, g, "montage")

%Task 3: Contrast enhancement using histogram

%plotting the histogram
clear all       % clear all variable in workspace
close all       % close all figure windows
f=imread('assets/pollen.tif');
imshow(f)
figure          
imhist(f);     

%use the imadjust function
close all
g=imadjust(f,[0.3 0.55]);
montage({f, g})    
figure
imhist(g);

%histogram, PDF, CDF
g_pdf = imhist(g) ./ numel(g);  % compute PDF
g_cdf = cumsum(g_pdf);          % compute CDF
close all                       % close all figure windows
imshow(g);
subplot(1,2,1)                  % plot 1 in a 1x2 subplot
plot(g_pdf)
subplot(1,2,2)                  % plot 2 in a 1x2 subplot
plot(g_cdf)

%histogram equalization
x = linspace(0, 1, 256);    % x has 256 values equally spaced
                             .... between 0 and 1
figure
plot(x, g_cdf)
axis([0 1 0 1])             % graph x and y range is 0 to 1
set(gca, 'xtick', 0:0.2:1)  % x tick marks are in steps of 0.2
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9)
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)

% the following code will perform this function and provide 
% plots of all three images and their histogram
h = histeq(g,256);              % histogram equalize g
close all
montage({f, g, h})
figure;
subplot(1,3,1); imhist(f);
subplot(1,3,2); imhist(g);
subplot(1,3,3); imhist(h);

%Task 4: Noise reduction with lowpass filter
%import an X-ray image of a printed circuit board
clear all
close all
f = imread('assets/noisyPCB.jpg');
imshow(f)

%Use the function fspecial to produce a 9x9 averaging 
%filter kernel _ and a 7 x 7 Gaussian kernel with sigma = 0.5
w_box = fspecial('average', [9 9])
w_gauss = fspecial('Gaussian', [7 7], 1.0)

%further filtering
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})

%Task 5: Median filtering
g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})

%Task 6: Sharpening the image with Laplacian, Sobel and
%Unsharp filers
w_box = fspecial('average', [5 5]) %testing average
w_gauss = fspecial('Gaussian', [7 7], 1.0) %testing gauss
e_gauss = fspecial('Gaussian', [7 7], 2.0) %testing  gaus with larger kern
r_gauss = fspecial('Gaussian', [7 7], 6.0) %testing  gaus with larger kern
t_gauss = fspecial('Gaussian', [7 7], 7.0) %testing  gaus with larger kern

g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
h_gauss = imfilter(f, e_gauss, 0);
j_gauss = imfilter(f, r_gauss, 0);
k_gauss = imfilter(f, t_gauss, 0);
figure
montage({g_gauss, h_gauss, j_gauss, k_gauss}) %seeing differences of kernerl
                                                %sizes on gaus filter outputs

%seeing difference in mediaun filter and original image
g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})

%setting of all possible filters
f = imread('assets/moon.tif');
w_box = fspecial('average', [1 1])
w_disk = fspecial("disk",0.5)
w_lap = fspecial("laplacian", 0.1)
w_gauss = fspecial('Gaussian', [1 1], 1.0)
w_log = fspecial("log", [1000 1000], 0.5)
w_motion = fspecial("motion", 2, 0)
w_prew = fspecial("prewitt")
w_sobel = fspecial("sobel")
w_unsharp = fspecial("unsharp", 0.2)

%placing all filters on image
g_box = imfilter(f, w_box, 0);
g_disk = imfilter(f,w_box,0);
g_lap = imfilter(f, w_lap,0);
g_gauss = imfilter(f, w_gauss, 0);
g_log = imfilter(f, w_log, 0);
g_motion = imfilter(f, w_motion, 0);
g_prew = imfilter(f, w_prew, 0);
g_sobel = imfilter(f, w_sobel, 0);
g_unsharp = imfilter(f, w_unsharp,0);

%montage of all filter outputs
figure
montage({f, g_box, g_disk, g_lap, g_gauss, g_log, g_motion, g_prew, g_sobel, g_unsharp})

%the best outcomes, and most clear filters adjusted to get 
%maximum clarity
f = imread('assets/moon.tif');
w_box = fspecial('average', [1 1])
w_disk = fspecial("disk",0.2)
w_gauss = fspecial('Gaussian', [1 1], 0.5)

g_box = imfilter(f, w_box, 0);
g_disk = imfilter(f,w_box,0);
g_gauss = imfilter(f, w_gauss, 0);

figure
montage({f, g_box, g_disk, g_gauss})


%Task 7: Test yourself Challenges
%Improve the contrast of a lake and tree image store in file lake&tree.png
%Use of contrast stretching was used 
f = imread("assets/lake&tree.png")
imshow(f)
g=imadjust(f,[0.15 0.45]);
montage({f, g})     
r = double(g);  
k = mean2(r);  
E = 2;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
h = uint8(255*s);
imwrite(h,"lake&tree.png")
montage({f, g, h,}) %see differnce in steps

%Use the Sobel filter in combination with any other techniques, 
% find the edge of the circles in the image file _circles.tif_.
%Sobel filter is used in conjunction with the prewitt filter to 
% get best results
f= imread("assets/circles.tif")
w_sobel = fspecial("sobel")
g_sobel = imfilter(f, w_sobel, 0);
w_prew = fspecial("prewitt")
g_prew = imfilter(g_sobel,w_prew,0);
montage({f,g_sobel, g_prew}) %see the different in steps

%* _office.jpg_ is a colour photograph taken of an office with bad 
% exposure.  Use whatever means at your disposal to improve the 
% lighting and colour of this photo.
% Use of contrast stretching, gaussian filter, and average
% for best results
f = imread("assets/office.jpg")
g=imadjust(f,[0.2 0.55]);
r = double(g);  
k = mean2(r);  
E = 2;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
h = uint8(255*s);
w_gauss = fspecial("gaussian",[7 7], 1.0) %kernel found from trial and error
g_gauss = imfilter(h, w_gauss, 0);
w_box = fspecial("average",[2 2]) %size found from trial and error
g_box = imfilter(g_gauss, w_box, 0);
montage({f, g, h, g_box})  %see difference in steps
