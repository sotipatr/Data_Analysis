 proc iml;
mat2=j(15,15,0);
 mat2[1,{2 14 15}]=1;
 mat2[2,{1 15 13 10}]=1;
 mat2[3,{12 11 10}]=1;
 mat2[4,{9 5 8 6 15}]=1;
 mat2[5,{4 8 9 10 7}]=1;
 mat2[6,{4 8 7}]=1;
 mat2[7,{6 5}]=1;
 mat2[8,{6 4 9 5}]=1;
 mat2[9,{4 8 5 10}]=1;
 mat2[10,{5 9 2 12 3 11}]=1;
 mat2[11,{3 12 10}]=1;
 mat2[12,{3 14 13 10 11}]=1;
 mat2[13,{2 12}]=1;
 mat2[14,{1 15 12}]=1;
 mat2[15,{1 14 2 4}]=1;
print mat2;
create mat from mat2;
append from mat2;
run;
