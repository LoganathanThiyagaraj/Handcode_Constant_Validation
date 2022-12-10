clear all %clear all workspace variables 
clc %clear command window


selBasepath = uigetdir(path,'Select Base folder'); %It will ask to select base component folder path where constant .c files are present
 selReferpath = uigetdir(path,'Select Reference folder');%It will ask to select reference  component folder path where constant .c files are present
 addpath(genpath(selBasepath))% Base folder will be added to current folder
  addpath(genpath(selReferpath))% Current folder will be added to current folder

present=pwd;% Saving present working directory in present variable
cd(selBasepath) % switching from pwd to Base folder
 dinfo = dir('*.c'); % Collecting all .c file names in base forder and store in dinfo variable
 cd(selReferpath) % switching from base folder to reference folder
 
 
 [refer,path1]=uigetfile('*.c','Select Constant file'); % This will ask to select reference *const*.c file and store filename in variable refer
 
 [refer1,path1]=uigetfile('*.c','Select VariantROM file if not Constant file');% This will ask to select reference *VariantRom*.c file and store filename in variable refer1
 [refer2,path1]=uigetfile('*.c','Select VariantROM file if not Constant file' );% This will ask to select reference *VariableRom*_01*.c file and store filename in variable refer2

 ReportNam = inputdlg('Enter the name of Software Component', ' RPG', 1);% Diolog box asks for Software component name
 ReportName=strcat(ReportNam,'_ConstantComparison_Validation_Report.xlsx');% concatinates software component name with validation report name

 delete(sprintf('%s',char(ReportName)))% It deletes previously created validation report
% str = fileread([refer]);

l=3;
m=2;
  
  % Code to count the number of constants present in reference *const*.c file
 fid = fopen(refer);
tline = fgetl(fid);
count1=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
     index2=regexp(tline,'^static ');
    end

if  ~isempty(index) || ~isempty(index2)
    count1=count1+1;
end
end
fclose(fid);
  
  
  % Code which calls callfunction to do comparison only between base and reference *const*.c file 
for K = 1:length(dinfo)% Looping the base .c files
    
    base = dinfo(K).name;% extracting base .c files  in dinfo array and store in varibale base 

    a=strfind(base,'Variant'); % Finding substring Variant in base .c file 
    

  if isempty(a) && strcmp(refer,base)==0 % do comparison only if base .c file does not contain variant substring and not as same as reference .c file
       sheetname=strcat('Sheet',num2str(m)); % It assigns sheetname for report creation
      
      m=m+1;
         callfunction.diffversions(base,refer,sheetname,ReportName,ReportNam)% function callfunction is called for comparison
          cell=strcat('B',num2str(l));
      
%--------- Below code counts constants in base *const*.c file----------- 	  
          fid = fopen(base);
tline = fgetl(fid);
count=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
     index2=regexp(tline,'^static ');
    end

if ~isempty(index) || ~isempty(index2)
    count=count+1;
end
end
fclose(fid);
%-----------------------------------------------------------------------
%Below code writes constant count of base and reference .c file in validation report
          data1={'Total_constant_count'};
xlswrite(char(ReportName),data1,sheetname,'B1');  
   data1=count;
xlswrite(char(ReportName),data1,sheetname,'B3');       
            
   data1=count1;
xlswrite(char(ReportName),data1,sheetname,'B2');   
          
%--------------------------------------------------------------------------
          
  end
end

% Below code compares *Variant Rom* files of Base and Reference
%---------------------------------------------------------------------------
a=strfind(refer1,'VariantRom');% finding substring 'VariantRom' in reference .c file

if ~isempty(a)% if 'VariantRom' substring is present ,it will do comparison

%below code counts constant in reference 'VariantRom'file
fid = fopen(refer1);
tline = fgetl(fid);
count1=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
     index2=regexp(tline,'^static ');
    end

if  ~isempty(index) || ~isempty(index2)
    count1=count1+1;
end
end
fclose(fid);
%----------------------------------------------------------

%% Code which calls callfunction to do comparison only between base and reference *VariantROM*.c file
for K = 1:length(dinfo)
    
    base = dinfo(K).name;% extracting base .c files  in dinfo array and store in varibale base 
    
    a=strfind(base,'Const');
    b=strfind(base,'0');
%     b=strfind(refer,'Const');
  if isempty(a) && strcmp(refer1,base)==0 && isempty(b)% base const .c filename should not contain keyword *const* and '0'
       sheetname=strcat('Sheet',num2str(m));
       
    m=m+1;
         callfunction.diffversions(base,refer1,sheetname,ReportName,ReportNam)

  else
        
        continue;
  end

%--------- Below code counts constants in base *VariantRom*.c file-----------  
   fid = fopen(base);
tline = fgetl(fid);
count=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
       index2=regexp(tline,'^static ');
    end

if ~isempty(index) || ~isempty(index2)
    count=count+1;
end
end
fclose(fid);
%-----------------------------------------------------------------------
%Below code writes constant count of base and reference .c file in validation report

          data1={'Total_constant_count'};
xlswrite(char(ReportName),data1,sheetname,'B1');  
   data1=count;
xlswrite(char(ReportName),data1,sheetname,'B3');   
   data1=count1;
xlswrite(char(ReportName),data1,sheetname,'B2');  
end
%------------------------------------------------------------------------
else % if *VariantRom*.c reference file is not present below code will extract only base constants to validation report 

for K = 1:length(dinfo)
   
    base = dinfo(K).name;
 
          a=strfind(base,'Const');
    b=strfind(base,'0');
%     b=strfind(refer,'Const');
  if isempty(a) &&  isempty(b)
       sheetname=strcat('Sheet',num2str(m));      
    m=m+1;
         callfunction.diffversionsss(base,sheetname,ReportName,ReportNam)

  else
        
        continue;
  end
 fid = fopen(base);
tline = fgetl(fid);
count=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
    index2=regexp(tline,'^static ');
    end

if ~isempty(index) || ~isempty(index2)
    count=count+1;
end
end
fclose(fid);
data1={'Total_constant_count'};
xlswrite(char(ReportName),data1,sheetname,'B1');  
   data1=count;
xlswrite(char(ReportName),data1,sheetname,'B3');   
  
   data1=0;
xlswrite(char(ReportName),data1,sheetname,'B2'); 

end
end


%  m=K;

% Below code compares *VariantRom*_01.c* files of Base and Reference
%---------------------------------------------------------------------------


a=strfind(refer2,'_0');

if ~isempty(a)

%below code counts constant in reference 'VariantRom'file

fid = fopen(refer2);
tline = fgetl(fid);
count1=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
     index2=regexp(tline,'^static ');
    end

if  ~isempty(index) || ~isempty(index2)
    count1=count1+1;
end
end
fclose(fid);

%% Code which calls callfunction to do comparison only between base and reference *VariantROM*_01.c file

for K = 1:length(dinfo)
    
    base = dinfo(K).name;
    
    a=strfind(base,'Const');
    b=strfind(base,'_0');
%     b=strfind(refer,'Const');
  if isempty(a) && strcmp(refer2,base)==0 && ~isempty(b)
       sheetname=strcat('Sheet',num2str(m));
     
     m=m+1;
         callfunction.diffversions(base,refer2,sheetname,ReportName,ReportNam)       
    else
        continue;
  end
 
%below code counts constant in base 'VariantRom*_01.c' file 
%----------------------------------------------------------
   fid = fopen(base);
tline = fgetl(fid);
count=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
    index2=regexp(tline,'^static ');
    end

if ~isempty(index) || ~isempty(index2)
    count=count+1;
end
end
fclose(fid);

%-----------------------------------------------------------------------
%Below code writes constant count of base and reference .c file in validation report

data1={'Total_constant_count'};
xlswrite(char(ReportName),data1,sheetname,'B1');  
   data1=count;
xlswrite(char(ReportName),data1,sheetname,'B3');   
  
   data1=count1;
xlswrite(char(ReportName),data1,sheetname,'B2');  
end
%------------------------------------------------------------------------
else % if *VariantRom*_01.c reference file is not present below code will extract only base constants to validation report 

for K = 1:length(dinfo)
   
    base = dinfo(K).name;
 
          a=strfind(base,'Const');
    b=strfind(base,'_0');
%     b=strfind(refer,'Const');
  if isempty(a) && ~isempty(b)
       sheetname=strcat('Sheet',num2str(m));
     
     m=m+1;
         callfunction.diffversionsss(base,sheetname,ReportName,ReportNam)       
    else
        continue;
  end
 fid = fopen(base);
tline = fgetl(fid);
count=0;
while ischar(tline)
%     disp(tline)
    tline = fgetl(fid);
    pattern = 'const';
   
    if tline~=-1
    index=regexp(tline,'^const ');
    index2=regexp(tline,'^static ');
    end

if ~isempty(index) || ~isempty(index2)
    count=count+1;
end
end
fclose(fid);
data1={'Total_constant_count'};
xlswrite(char(ReportName),data1,sheetname,'B1');  
   data1=count;
xlswrite(char(ReportName),data1,sheetname,'B3');   
  
   data1=0;
xlswrite(char(ReportName),data1,sheetname,'B2'); 
		 
end
end

% Below command writes Column headings in Dashboard sheet of validation report 
sheetname='Sheet1';
data1={'ConstantName_Base'};
xlswrite(char(ReportName),data1,sheetname,'C2');
data1={'Value of Reference'};
xlswrite(char(ReportName),data1,sheetname,'D2');
data1={'Value of Base'};
xlswrite(char(ReportName),data1,sheetname,'E2');
data1={'Datatype of Reference'};
xlswrite(char(ReportName),data1,sheetname,'F2');
data1={'Datatype of Base'};
xlswrite(char(ReportName),data1,sheetname,'G2');
data1={'Status'};
xlswrite(char(ReportName),data1,sheetname,'H2');
data1={'Reference Files'};
xlswrite(char(ReportName),data1,sheetname,'A2');
data1={'Base Files'};
xlswrite(char(ReportName),data1,sheetname,'B2');
%----------------------------------------------------------------

%Below code will extract all NG conditions from individual sheets and display in dashboard sheet

filename1=strcat('\',char(ReportName));
filename=strcat(pwd,filename1);
exl = actxserver('excel.application');
exlWkbk = exl.Workbooks;
exlFile = exlWkbk.Open(filename);
exlFile.Activate


sheet='Sheet1';
   sheet1 = exlFile.Sheets.Item(sprintf('%s',sheet));

   len1=exlFile.Sheets.Count;% It gives count of total sheets in validation report
  m=4;
  sheet='Sheet1';
   sheet1 = exlFile.Sheets.Item(sprintf('%s',sheet));
  for i=2:len1 % Data will be accessed from sheet2 onwords
      
      sheetvar = exlFile.Sheets.Item(sprintf('Sheet%d',i));
       sheet1.Range(sprintf('A%d',m)).Value=sheetvar.Range('A2').Value;
                sheet1.Range(sprintf('B%d',m)).Value=sheetvar.Range('A3').Value;
     for j=4:500 % Inside individual sheet status column will be iterated to find NG conditions
        a=sheetvar.Range(sprintf('G%d',j)).Value; %Extracts value of status column from individual sheet
        if isempty(a)
            break;
        elseif strcmp(a,'NG')% if status found to be "NG", constant details of base component will be copied to Dashboard sheet
%            a=sheetvar.Range(sprintf('A%d',j)).Value;
%            if ~isempty(a)
            sheet1.Range(sprintf('C%d',m)).Value=sheetvar.Range(sprintf('B%d',j)).Value;
            sheet1.Range(sprintf('D%d',m)).Value=sheetvar.Range(sprintf('C%d',j)).Value;
            sheet1.Range(sprintf('E%d',m)).Value=sheetvar.Range(sprintf('D%d',j)).Value;
            sheet1.Range(sprintf('F%d',m)).Value=sheetvar.Range(sprintf('E%d',j)).Value;
            sheet1.Range(sprintf('G%d',m)).Value=sheetvar.Range(sprintf('F%d',j)).Value;
            sheet1.Range(sprintf('H%d',m)).Value=sheetvar.Range(sprintf('G%d',j)).Value;             
            m=m+1;
%            end
        end 
     end
      
  end
  exlFile.Sheets.Item('Sheet1').Name='Dashboard';
exlFile.Save();
exlFile.Close();
exl.Quit;
exl.delete;

% Below code moves validation report from reference folder to Script folder
psource=selReferpath;
pdest   = present;
pattern = '*.xlsx';
sourceDir = dir(fullfile(psource, pattern));% sourceDir->Directory which has .xlsx file 

    sourceFile = fullfile(psource, sourceDir.name); % gets validation report in reference folder
    destFile   = fullfile(pdest, sourceDir.name);  % gets destination to move the validation report
    movefile(sourceFile, destFile); % report will be moved from reference folder to sccript folder

cd(present) % path changed to script folder
f = msgbox('Completed');