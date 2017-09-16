%Load picture
imdata = imread('Image5Non.jpg');
image(imdata)

%Get random points
x = 1;
y = 1;
ni = 601;
while x < 800
    while y < 1600
        nred(ni)=imdata(round(x),round(y),1);
        ngreen(ni)=imdata(round(x),round(y),2);
        nblue(ni)=imdata(round(x),round(y),3);
        ni = ni + 1;
        y = y + 10;
    end;
    x = x + 10;
end;
    

%Generate scatter plot
scatter3(red,green,blue,1,color);
hold on;
scatter3(nred,ngreen,nblue,1,ncolor);

Clustering
redAverage = mean(red);
greenAverage = mean(green);
blueAverage = mean(blue);

poolAverage = [redAverage, greenAverage, blueAverage];

% Find threshold
longestDistance = 0;

p1 = 0;
p2 = poolAverage;

for i = 1 : 150
    p1 = [red(i),green(i), blue(i)];
    pV = double([p1;p2]);
    d = pdist(pV,'euclidean');
    if d > longestDistance
        longestDistance = d;
    end
end
    


redAverageN = mean(nred);
greenAverageN = mean(ngreen);
blueAverageN = mean(nblue);

nAverage = [redAverageN, greenAverageN, blueAverageN];



%Get average distance to each point
shortestDistance = 999;
p1 = 0;
p2 = 0;
shortestDistanceMatrix = [];
for i = 1 : 150
    shortestDistance = 999;
    p1 = [red(i),green(i), blue(i)];
    for j = i+1 : 150
        p2 = [red(j),green(j), blue(j)];
        pV = double([p1;p2]);
        d = pdist(pV,'euclidean');
        if d < shortestDistance
            shortestDistance = d;
        end
    end
    shortestDistanceMatrix(i) = shortestDistance;
end

averageDistanceToNearestNeighbor = mean(shortestDistanceMatrix);



%Get average distance to each point
shortestDistance = 999;
p1 = 0;
p2 = 0;
shortestDistanceMatrixN = [];
for i = 1 : 760
    shortestDistance = 999;
    p1 = [nred(i),ngreen(i), nblue(i)];
    for j = i+1 : 760
        p2 = [nred(j),ngreen(j), nblue(j)];
        pV = double([p1;p2]);
        d = pdist(pV,'euclidean');
        if d < shortestDistance
            shortestDistance = d;
        end
    end
    shortestDistanceMatrixN(i) = shortestDistance;
end

averageDistanceToNearestNeighborN = mean(shortestDistanceMatrixN);




% %Get pixels from picture
pictureDimentions = size(imdata);
imageMaxX = pictureDimentions(1);
imageMaxY = pictureDimentions(2);

picturePixels = [];

count = 1;
i = 100;
j = 1024;
scatterMatrixX = 0;
scatterMatrixY = 0;
scatterMatrixCount = 1;
while i < 283 
    while j < 1229
        picturePixels(1,count) = imdata(round(i),round(j),1);
        picturePixels(2,count) = imdata(round(i),round(j),2);
        picturePixels(3,count) = imdata(round(i),round(j),3);
        

        
         pixelColor = [imdata(round(i),round(j),1), imdata(round(i),round(j),2), imdata(round(i),round(j),3)];
         pV = double([poolAverage;pixelColor]);
         distFromCentroid = pdist(pV,'euclidean');
         
         pV = double([nAverage;pixelColor]);
         distFromNCentroid = pdist(pV, 'euclidean');
         
        if(distFromCentroid < 50)
            scatterMatrixX(scatterMatrixCount) = i;
            scatterMatrixY(scatterMatrixCount) = j;
            scatterMatrixCount = scatterMatrixCount + 1;
        end
        pixelColor = [imdata(round(i),round(j),1), imdata(round(i),round(j),2), imdata(round(i),round(j),3)];


        % %Find nearest neighbor
        shortestDistanceToN = 999;
        p1 = 0;

        for k = 1 : 760
            p1 = [nred(k),ngreen(k), nblue(k)];
            pV = double([p1;pixelColor]);
            d = pdist(pV,'euclidean');
            if d < shortestDistanceToN
                shortestDistanceToN = d;
            end
        end

        shortestDistanceToP = 999;
        p1 = 0;

        for k = 1 : 150
            p1 = [red(k),green(k), blue(k)];
            pV = double([p1;pixelColor]);
            d = pdist(pV,'euclidean');
            if d < shortestDistanceToP
                shortestDistanceToP = d;
            end
        end

        normalizedShortestDistanceToN = shortestDistanceToN * (1/averageDistanceToNearestNeighborN);
        normalizedShortestDistanceToP = shortestDistanceToP * (1/averageDistanceToNearestNeighbor);

        if(normalizedShortestDistanceToP < normalizedShortestDistanceToN)
            scatterMatrixX(scatterMatrixCount) = i;
            scatterMatrixY(scatterMatrixCount) = j;
            scatterMatrixCount = scatterMatrixCount + 1;
        end

         j = j + 5;
    end
     i = i + 5;
     j = 1024;
end

