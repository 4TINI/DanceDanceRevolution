timerCounter = 105;
speed = 4;
fileID = fopen('Song21.txt','w');
fprintf(fileID,'[\n\r');
for i = 0 : timerCounter 
    fprintf(fileID,'{\n\r');
    fprintf(fileID,'"tempo":%d,\n\r', i * 30);
    fprintf(fileID,'"colonna":%d,\n\r', randi(4));
    fprintf(fileID,'"velocita":%d\n\r', speed);
    fprintf(fileID,'},\n\r');
end
fprintf(fileID,']');