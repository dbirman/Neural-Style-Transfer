%% Set type and size

type = 'objects';
path = '~/proj/Neural-Style-Transfer/images/fbsear/';
fpath = fullfile(path,type);
fig_size = [500,500]; % specify in cm

inums = 1:4;

%% Find all the categories
cats = dir(fpath);
cats = {cats.name};
cats = cats(cellfun(@(x) isempty(strfind(x,'.')),cats));
cats = cats(cellfun(@(x) isempty(strfind(x,'out')),cats));

%% Get a list of all top-level images

imgs = cell(length(cats),length(inums));

for ci = 1:length(cats)
    cat = cats{ci};
    for ii = 1:length(inums)
        num = inums(ii);
        
        imgs{ci,ii} = fullfile(fpath,cat,sprintf('%i.jpg',num));
        
        if ~isfile(imgs{ci,ii})
            disp(sprintf('Warning %s does not exist',imgs{ci,ii}));
        end
    end
end

%% Load top-level images
idata = zeros(size(imgs,1),size(imgs,2),400,400,3); % we will crop to the center 400

for ci = 1:size(imgs,1)
    for ii = 1:size(imgs,2)
        I = imread(imgs{ci,ii});
        
        % resize the image to 400x400 (for simplicity)
        I = imresize(I,[400,400]);
        I = imrotate(I,180);
        
        % save
        idata(ci,ii,:,:,:) = I;
    end
end

%% Get a list of all built images
            % style       content      stylenum   contentnum
oimgs = cell(length(cats),length(cats),length(inums),length(inums));

% find combinations of categories, then find combo of images, then find
% iteration #10
for si = 1:length(cats) 
    style = cats{si};
    for ci = 1:length(cats)
        content = cats{ci};
        for sii = 1:length(inums)
            snum = inums(sii);
            for cii = 1:length(inums)
                cnum = inums(cii);
                
                ipath = fullfile(fpath,'out',sprintf('%s%s',style,content),sprintf('%i%i_at_iteration_10.png',sii,cii));
                 
                if ~isfile(ipath)
                    disp(sprintf('Warning %s does not exist',imgs{ci,ii}));
                end
                
                oimgs{si,ci,sii,cii} = ipath;
            end
        end
    end
end

%% Load built images
odata = zeros(size(oimgs,1),size(oimgs,2),size(oimgs,3),size(oimgs,4),400,400,3); % we will crop to the center 400

for si = 1:size(oimgs,1)
    for ci = 1:size(oimgs,2)
        for sii = 1:size(oimgs,3)
            for cii = 1:size(oimgs,4)
                I = imread(oimgs{si,ci,sii,cii});

                % resize the image to 400x400 (for simplicity)
                I = imresize(I,[400,400]);
                I = imrotate(I,180);
                I = mean(I,3);
                I = repmat(I,1,1,3);
                % save
                odata(si,ci,sii,cii,:,:,:) = I;
            end
        end
    end
end

%% Create plot

h = figure; hold on

axis equal
    
% offset for the y axis
yoff = 50;
xoff = -50;

% place the top-level images along the top and left side in order
for ci = 1:size(idata,1)
    for ii = 1:size(idata,2)
        % place on the top
        xidxs = ((ci-1)*50*size(idata,2)+(ii-1)*50+1):((ci-1)*50*size(idata,2)+ii*50);
        yidxs = 1:50;
        imagesc(xidxs,yidxs,squeeze(idata(ci,ii,:,:,:))./255);
        
        % place on the left
        yidxs = ((ci-1)*50*size(idata,2)+(ii-1)*50+1):((ci-1)*50*size(idata,2)+ii*50);
        xidxs = 1:50;
        imagesc(xoff+xidxs,yoff+yidxs,squeeze(idata(ci,ii,:,:,:))./255);
    end
end

yoff = 50;
xoff = 0;

% iterate over style and content images
for si = 1:size(oimgs,1) % style (row)
    for ci = 1:size(oimgs,2) % content (col)
        for sii = 1:size(oimgs,3)
            for cii = 1:size(oimgs,4)
                % xaxis position is the content
                xidxs = ((ci-1)*50*size(idata,2)+(cii-1)*50+1):((ci-1)*50*size(idata,2)+cii*50);
                % yaxis position is the style
                yidxs = ((si-1)*50*size(idata,2)+(sii-1)*50+1):((si-1)*50*size(idata,2)+sii*50);

                % use just the yoff to calculate location (xoff is for the y axis)

                imagesc(xoff+xidxs,yoff+yidxs,squeeze(odata(si,ci,sii,cii,:,:,:))./255);
            end
        end
    end
end
        

%% Save

drawPublishAxis(sprintf('figSize=[%i,%i]',fig_size(1),fig_size(2)));
savepdf(h,fullfile('~/proj/Neural-Style-Transfer','figures',sprintf('matrix_%s.pdf',type)));
