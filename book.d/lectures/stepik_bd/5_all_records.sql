CREATE TABLE IF NOT EXISTS `project_simple`.`project` (
  `project_name` VARCHAR(255) NULL,
  `client_name` VARCHAR(255) NULL,
  `project_start` DATE NULL,
  `project_finish` DATE NULL,
  `budget` DECIMAL(18,2) NULL)
ENGINE = InnoDB;

#Выведите общее количество заказов компании.
#Те общее количество записей


use project_simple;
select count(1) from project;

