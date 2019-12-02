Для создания проекта:  
sudo easy_install PasteScript
paster create mynewpackage
answer the questions!
cd mynewpackage
python setup.py sdist
python setup.py register

Для публикации используем twine
twine upload dist/*
