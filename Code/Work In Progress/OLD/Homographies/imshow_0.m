function imshow_0(img)

img_ref = imref2d(size(img), [0,size(img,2)], [0,size(img,1)]);
imshow(img, img_ref);

