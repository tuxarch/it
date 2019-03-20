#База данных магазина `store_simple` состоит из одной таблицы `store` следующей структуры:

CREATE TABLE IF NOT EXISTS `store_simple`.`store` (
  `product_name` VARCHAR(255) NULL,
  `category` VARCHAR(255) NULL,
  `price` DECIMAL(18,2) NULL,
  `sold_num` INT NULL)
ENGINE = InnoDB;

#Задание
#Выведите количество товаров в каждой категории. Результат должен содержать два столбца: 
#название категории, количество товаров в данной категории.

use store_simple;
select category, count(1) from store group by category;

