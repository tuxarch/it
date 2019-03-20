use store;

#Выведите список товаров с названиями товаров и названиями категорий, в том числе товаров,
#не принадлежащих ни одной из категорий.

select good.name, category.name from good left outer join category_has_good on good.id = category_has_good
                             .good_id left outer join category on category_has_good.category_id = category.id;

#вся соль в том, что могут быть выведены значения null, которые не вошли в таблицу категорий