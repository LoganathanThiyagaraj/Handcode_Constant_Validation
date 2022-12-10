  classdef callfunction
    methods(Static)    
        function diffversions(base,refer,sheetname,ReportName,ReportNam)%function gets args from Handcode_Constant_Variation_v5 
            str = fileread([refer]);% Stores the contents in reference .c file to varibale str
            str1 = fileread([base]);% Stores the contents in base.c file to varibale str1

Parameters=strsplit(str, {'const', ',*;'});% splits string in str by keyword 'const' & ';' and store in array Parameters

for i = 2:length(Parameters)% Iterating Parameters array
    Temp=Parameters{1,i};
    parameter = regexprep(Temp,';.*','');% replaces unwanted string after ';' in each index of Parameters
    Parameters{1,i}=parameter;
end

Parameters1=strsplit(str1, {'const', ',*;'});% splits string in str1 by keyword 'const' & ';' and store in array Parameters
for i = 2:length(Parameters1)% Iterating Parameters1 array
    Temp1=Parameters1{1,i};
    parameter1 = regexprep(Temp1,';.*','');% replaces unwanted string after ';' in each index of Parameters1
    Parameters1{1,i}=parameter1;
end


k=1;
Parameters=Parameters(2:end);
[~,noMatch] = regexp(Parameters,'=','match','split');%splits string into two by delimiter '=' and stored in noMatch array
noMat=noMatch;
for i=1:length(noMatch)% Iterates through noMatch array having datatype,constant name and value 
    a=size(noMatch{1,i});
    if a(2)==2
name{k}=noMatch{1,i}{1}; 
refer1{k}=noMatch{1,i}{2};% 2nd index of noMatch contains values of reference
% const_values_refer{k} = regexprep(refer1{k},'/,*','');
const_values_refer{k} = regexprep(num2str(refer1{k}),';.*','');% Values of all reference constants are stored in const_values_refer array
k=k+1;
    end
end

k=1;
Parameters1=Parameters1(2:end);
[~,noMatch] = regexp(Parameters1,'=','match','split');%splits string into two by delimiter '=' and stored in noMatch array
for i=1:length(noMatch) 
    a=size(noMatch{1,i});
    if a(2)==2
name1{k}=noMatch{1,i}{1};
base1{k}=noMatch{1,i}{2};2nd index of noMatch contains values of base
const_values_base{k} = regexprep(num2str(base1{k}),';.*','');%% Values of all base constants are stored in const_values_base array
k=k+1;
    end
end

if isempty(noMat)%If reference constant file has no constants , below message will be written in excel sheet
  Message=strcat('No constants in   ',base,'file');
 Message
  data1={'No constants in base file'};
xlswrite(char(ReportName),data1,sheetname,'D1');
else % else constant name and dataype are extracted in below code

[~,noMatch] = regexp(name,' ','match','split');% Splits dataype and constant name of reference separately and stored in noMatch array
k=1;
for i=1:length(noMatch) 
 
const_datatypes_refer{k}=noMatch{1,i}{2};%2nd index of noMatch array conatains datatypes of reference constants
const_names_refer{k}=noMatch{1,i}{3};%3rd index of noMatch array contains constant names of reference
finding=strfind(refer,'Variant');%
 if isempty(noMatch{1,i}{3})&& isempty(finding) %Some *const*.c file have extra space .so constant names will be in 4th index of noMatch array
 const_names_refer{k}=noMatch{1,i}{4}; %constant names present in 4th index in some cases is extracted and stored in const_names_refer array
 end
k=k+1;   
end
[~,noMatch] = regexp(name1,' ','match','split');% Splits dataype and constant name of base separately and stored in noMatch array
k=1;
for i=1:length(noMatch) 
 
const_datatypes_base{k}=noMatch{1,i}{2};%2nd index of noMatch array conatains datatypes of base constants
const_names_base{k}=noMatch{1,i}{3};%3rd index of noMatch array contains constant names of base
finding=strfind(base,'Variant');
 if isempty(noMatch{1,i}{3})&& isempty(finding) %Some *const*.c file have extra space .so constant names will be in 4th index of noMatch array
 const_names_base{k}=noMatch{1,i}{4};%constant names present in 4th index in some cases is extracted and stored in const_names_base array
 end
k=k+1;   
end
n=1;
for i=1:length(const_names_refer)
    f=0;
for j=1:length(const_names_base)
if strcmp(const_names_refer{1,i},const_names_base{1,j})%comparing constant names of reference and base
    
    const_names_base_final{1,i}=const_names_base{1,j};
    const_dataypes_base_final{1,i}=const_datatypes_base{1,j};
    const_values_base_final{1,i}=const_values_base{1,j};
 

   if strcmp(const_values_refer{1,i},const_values_base{1,j})&& strcmp(const_datatypes_refer{1,i},const_datatypes_base{1,j})%if names and dataypes are same status is 'OK'
       f=1;
      status{1,i}='OK';
   end 
   
break;
else

continue;
end
end
if f==0 % if names and dataypes of base and reference are different status goes to "NG"
    status{1,i}='NG';
     
end
end
i=i+1;
for j=1:length(const_names_base)% Additonal constants in base components are extracted 

if ismember(const_names_base{1,j},const_names_refer)
  continue;
else
     const_names_base_final{1,i}=const_names_base{1,j};
      const_dataypes_base_final{1,i}=const_datatypes_base{1,j};
    const_values_base_final{1,i}=const_values_base{1,j};


const_names_refer{1,i}='-';
const_datatypes_refer{1,i}='-';
const_values_refer{1,i}='-';

    status{1,i}='NG';
   i=i+1;
   
end
    
end 
% m=1;
% for i=1:length(status)
%     if strcmp(status{1,i},'NG')  
%         if isempty(const_names_base_final{1,i})
%        continue;
%         else
%              Displaybasenames{m,1}=const_names_base_final{1,i};
%              Displaybasedatatypes{m,1}=const_dataypes_base_final{1,i};
%              Displaybasevalues{m,1}=const_values_base_final{1,i};
%              Displayrefernames{m,1}=const_names_refer{1,i};
%              Displayreferdatatypes{m,1}=const_datatypes_refer{1,i};
%              Displayrefervalues{m,1}=const_values_refer{1,i};
%              Status{m,1}=status{1,i};
%              m=m+1;
%         end
%     end
% end


%Transposing horizontal to vertical array
const_datatypes_refer=const_datatypes_refer.'; 
const_names_refer=const_names_refer.';
 const_values_refer=const_values_refer.';
status=status.';


for i=1:length(const_datatypes_refer)
    
   x=strfind(const_datatypes_refer{i,1},'VariantROM'); 

if ~isempty(x)
    const_datatypes_refer{i,1}=strcat('st_variant_const_',ReportNam);
end    
end

% Below code writes extracted constant names,datatypes , values and comparison status of base and reference component in validation report
% cd(present)
 data1=const_names_refer;
 xlswrite(char(ReportName),data1,sheetname,'A6');

for i=1:length(const_values_refer)
if ~isempty(const_values_refer{i})
const_values_refer{i}=regexprep(const_values_refer{i},'(','"(');
const_values_refer{i}=regexprep(const_values_refer{i},')',')"');
end
end
data2=const_values_refer;
xlswrite(char(ReportName),data2,sheetname,'C6');


data1=const_datatypes_refer;
xlswrite(char(ReportName),data1,sheetname,'E6');

data1={'FileName'};
xlswrite(char(ReportName),data1,sheetname,'A1');
data1={refer};
xlswrite(char(ReportName),data1,sheetname,'A2');
data1={base};
 xlswrite(char(ReportName),data1,sheetname,'A3');
  data1={'ConstantName_Ref'};
 xlswrite(char(ReportName),data1,sheetname,'A5');
data1={'ConstantName_Base'};
xlswrite(char(ReportName),data1,sheetname,'B5');


data1={'Value of Reference'};
xlswrite(char(ReportName),data1,sheetname,'C5');
data1={'Value of Base'};
xlswrite(char(ReportName),data1,sheetname,'D5');
data1={'Datatype of Reference'};
xlswrite(char(ReportName),data1,sheetname,'E5');
data1={'Datatype of Base'};
xlswrite(char(ReportName),data1,sheetname,'F5');
data1={'Status'};
xlswrite(char(ReportName),data1,sheetname,'G5');

const_names_base_final=const_names_base_final.';
const_dataypes_base_final=const_dataypes_base_final.';
const_values_base_final=const_values_base_final.';

for i=1:length(const_dataypes_base_final)
    
   x=strfind(const_dataypes_base_final{i,1},'VariantROM'); 

if ~isempty(x)
    const_names_base_final{i,1}=const_dataypes_base_final{i,1};
    const_dataypes_base_final{i,1}=strcat('st_variant_const_',ReportNam);
end    
end





data1=const_names_base_final;
xlswrite(char(ReportName),data1,sheetname,'B6');


for i=1:length(const_values_base_final)
if ~isempty(const_values_base_final{i})
const_values_base_final{i}=regexprep(const_values_base_final{i},'(','"(');
const_values_base_final{i}=regexprep(const_values_base_final{i},')',')"');
end
end
data1=const_values_base_final;
xlswrite(char(ReportName),data1,sheetname,'D6');


data1=const_dataypes_base_final;
xlswrite(char(ReportName),data1,sheetname,'F6');
data1=status;
xlswrite(char(ReportName),data1,sheetname,'G6');


  
  
end

  end
  
  % function diffversionsss has similar working process of diffversions but it extracts only base constants to validation report when reference file is not present
  function diffversionsss(base,sheetname,ReportName,ReportNam)
  
  
            str1 = fileread([base]);

Parameters1=strsplit(str1, {'const', ',*;'});
for i = 2:length(Parameters1)
    Temp1=Parameters1{1,i};
    parameter1 = regexprep(Temp1,';.*','');
    Parameters1{1,i}=parameter1;
end



k=1;
Parameters1=Parameters1(2:end);
[~,noMatch] = regexp(Parameters1,'=','match','split');
for i=1:length(noMatch) 
    a=size(noMatch{1,i});
    if a(2)==2
name1{k}=noMatch{1,i}{1};
base1{k}=noMatch{1,i}{2};
const_values_base{k} = regexprep(num2str(base1{k}),';.*','');
k=k+1;
    end
end


[~,noMatch] = regexp(name1,' ','match','split');
k=1;
for i=1:length(noMatch) 
 
const_datatypes_base{k}=noMatch{1,i}{2};



const_names_base{k}=noMatch{1,i}{3};
finding=strfind(base,'Variant');
 if isempty(noMatch{1,i}{3})&& isempty(finding) 
 const_names_base{k}=noMatch{1,i}{4};
 end
k=k+1;   
end
n=1;

for j=1:length(const_names_base)
 
      status{1,j}='NG';
 end 

status=status.';


data1={'FileName'};
xlswrite(char(ReportName),data1,sheetname,'A1');
data1={' '};
xlswrite(char(ReportName),data1,sheetname,'A2');
data1={base};
 xlswrite(char(ReportName),data1,sheetname,'A3');
  data1={'ConstantName_Ref'};
 xlswrite(char(ReportName),data1,sheetname,'A5');
data1={'ConstantName_Base'};
xlswrite(char(ReportName),data1,sheetname,'B5');


data1={'Value of Reference'};
xlswrite(char(ReportName),data1,sheetname,'C5');
data1={'Value of Base'};
xlswrite(char(ReportName),data1,sheetname,'D5');
data1={'Datatype of Reference'};
xlswrite(char(ReportName),data1,sheetname,'E5');
data1={'Datatype of Base'};
xlswrite(char(ReportName),data1,sheetname,'F5');
data1={'Status'};
xlswrite(char(ReportName),data1,sheetname,'G5');

const_names_base=const_names_base.';
const_datatypes_base=const_datatypes_base.';
const_values_base=const_values_base.';

data1=const_names_base;
xlswrite(char(ReportName),data1,sheetname,'B6');


for i=1:length(const_values_base)
if ~isempty(const_values_base{i})
const_values_base{i}=regexprep(const_values_base{i},'(','"(');
const_values_base{i}=regexprep(const_values_base{i},')',')"');
end
end
data1=const_values_base;
xlswrite(char(ReportName),data1,sheetname,'D6');


data1=const_datatypes_base;
xlswrite(char(ReportName),data1,sheetname,'F6');
data1=status;
xlswrite(char(ReportName),data1,sheetname,'G6');

  
  end
  end
  end