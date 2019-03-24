
# создаем таблицу если она не создана
CREATE TABLE IF NOT EXISTS `billing_simple`.`billing` (
  `payer_email` VARCHAR(255) NULL,
  `recipient_email` VARCHAR(255) NULL,
  `sum` DECIMAL(18,2) NULL,
  `currency` VARCHAR(3) NULL,
  `billing_date` DATE NULL,
  `comment` TEXT NULL)
ENGINE = InnoDB;

#Добавьте в таблицу одну запись о платеже со следующими значениями:
#email плательщика: 'pasha@mail.com'
#email получателя: 'katya@mail.com'
#сумма: 300.00
#валюта: 'EUR'
#дата операции: 14.02.2016
#комментарий: 'Valentines day present)'

use billing_simple;
#проблемы с датой могут быть
insert into billing values('pasha@mail.com', 'katya@mail.com', '300.00', 'EUR', '14.02.2016', 'Valentines day present)');

use billing_simple;
select * from billing where recipient_email='katya@mail.com'

