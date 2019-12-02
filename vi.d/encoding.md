## enca 
(если есть информация о дабл кодировани то гг)

encov 
самостоятельно найдет кодировку и преобразует по текущей локали

iconv -f CP866 -t UTF-8 -o out.txt cofface_and_Alka_recovery_twrp_kenzo.bat
iconv -f WINDOWS-1251 -t UTF-8 -o output_file.txt original_file.txt 
где: 
-f WINDOWS-1251 - исходная кодировка,
-t UTF-8 - конечная
-o output_file.txt - куда выводить результат
original_file.txt - исходный файл

## vim

e ++enc=cp-1215      Редактирование файла в ??? кодировке
w ++enc=      Сохранить файл в новой кодировке
set fileencodings=utf-8,koi8-r приоритет работы с кодировками

## file
file file.txt
инфо по кодировке

## online services
http://www.online-decoder.com/ru
http://foxtools.ru/Text

## убрать ^M 
perl -p -i -e "s/\r//g" filename
sed -i 's/^M//' filename.txt
