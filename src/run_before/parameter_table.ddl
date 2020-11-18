DROP TABLE IF EXISTS `ppicha`.`anti_pattern_properties` ;

CREATE TABLE IF NOT EXISTS `ppicha`.`anti_pattern_properties` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(255) NOT NULL,
  `value` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

INSERT INTO `anti_pattern_properties` (`id`, `key`, `value`)
VALUES (NULL, 'max_sprint_length', '14');
