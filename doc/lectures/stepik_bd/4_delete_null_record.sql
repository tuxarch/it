CREATE TABLE IF NOT EXISTS `billing_simple`.`billing` (
  `payer_email` VARCHAR(255) NULL,
  `recipient_email` VARCHAR(255) NULL,
  `sum` DECIMAL(18,2) NULL,
  `currency` VARCHAR(3) NULL,
  `billing_date` DATE NULL,
  `comment` TEXT NULL)
ENGINE = InnoDB;

#создать запись с выборочными полями

insert into billing  
	(recipient_email, sum, currency, billing_date, comment)
	values ('ash@gmail.com', '99.00', 'CNY', '2019-03-18', 'Hi,there');

#Удалите из таблицы записи, где адрес плательщика или адрес получателя установлен в неопределенное
#значение или пустую строку.
#Не работает на дефолтной базе тк удаление отключенно

delete from billing where payer_email is NULL or payer_email=''
					or recipient_email is NULL or recipient_email='';
    
use billing_simple;
select * from billing;



