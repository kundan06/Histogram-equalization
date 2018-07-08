% histogram equalization
clear all;
a=imread('cameraman.tif');
[rows,columns]=size(a);
L=256;
b=double(a);
pixel_val=0:255;
nk=zeros(1,L);
prk=zeros(1,L);
s=zeros(1,L);
psk=zeros(1,L);

for i=1:rows
    for j=1:columns
        
        val=b(i,j);
%         val+1 as values from 0 to 255
        nk(1,val+1)= nk(1,val+1)+1;
    end
end
prk=nk/(rows*columns);
sum1=0;
for i=1:size(nk,2)
    sum1=sum1+prk(i);
    s(i)=sum1*(L-1);
%     to avoid zero ndexing as values between 0 to 255  
     map(i)= round(s(i));
     psk(map(i)+1)=psk(map(i)+1)+prk(i);
end

b=map(double(a)+1);
maxim=max(prk(:));

% using histeq function
final_img=histeq(a,256);
nk_out=zeros(1,L);
for i=1:rows
    for j=1:columns
        val=double(final_img(i,j));
%         val+1 as values from 0 to 255
        nk_out(val+1)= nk_out(val+1)+1;
    end
end    
prk_out=double(nk_out)/(rows*columns);

% change the loss function accordingly


nkout=zeros(1,L);
for i=1:rows
    for j=1:columns
        val=double(b(i,j));
%         val+1 as values from 0 to 255
        nkout(val+1)= nkout(val+1)+1;
    end
end    
prkout=double(nkout)/(rows*columns);
sout=zeros(1,L);
%cumulative distribution
so=0;
for i=1:L
    so=so+prkout(i);
    sout(i)=so;
end    
figure;
stairs(pixel_val,sout);

%loss function
diff=double(final_img)-b;
mse=sum(sum((diff.*diff)/(rows*columns),1),2);
rmse=sqrt(sum(sum(mse,1),2));
disp('Error is');
disp(rmse);

% plotting
figure;
subplot(1,3,1);
bar(pixel_val,prk,'BarWidth',3);
title('Original Histogram');
xlabel('Intensity Value');
ylabel('Probability Destribution');
axis([0,260,0,maxim+0.01]);
subplot(1,3,2);
bar(pixel_val,psk,'BarWidth',1);
title('Histogram Equalization');
xlabel('Intensity Value');
ylabel('Probability Destribution');
axis([0,260,0,maxim+0.01]);
% plotting image using inbuilt fucntion
subplot(1,3,3);
bar(pixel_val,prk_out,'BarWidth',1);
title('Inbuilt Histogram Equalization');
xlabel('Intensity Value');
ylabel('Probability Destribution');
axis([0,260,0,maxim+0.01]);

figure;
subplot(1,3,1);
imshow(uint8(a));
title('Original Image');
subplot(1,3,2);
imshow(uint8(b));
title('Histogram Equalization');
subplot(1,3,3);
imshow(final_img);
title('Inbuilt Histogram Equalization');