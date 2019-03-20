use store;


#Выведите все позиций списка товаров принадлежащие какой-либо
#категории с названиями товаров и названиями категорий. Список должен быть
#отсортирован по названию товара, названию категории. 
#Для соединения таблиц необходимо использовать оператор 

# У нас есть средняя таблица через которую мы будем связывать наш запрос
# два джойна к двум таблицам


SELECT good.name, category.name 
			FROM category_has_good 
            INNER JOIN good ON category_has_good.good_id = good.id
			INNER JOIN category on category_has_good.category_id = category.id
            order by good.name, category.name;
                             
                             