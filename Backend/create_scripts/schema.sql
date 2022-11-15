CREATE SCHEMA `WorkoutTracker` ;

CREATE TABLE `WorkoutTracker`.`Categories` (
                                               `Id` VARCHAR(36) NOT NULL,
                                               `Name` VARCHAR(255) NULL,
                                               PRIMARY KEY (`Id`));

CREATE TABLE `WorkoutTracker`.`Exercises` (
                                              `Id` VARCHAR(36) NOT NULL,
                                              `Name` VARCHAR(255) NULL,
                                              `CategoryId` VARCHAR(36) NOT NULL,
                                              PRIMARY KEY (`Id`),
                                              INDEX `FK_Category_idx` (`CategoryId` ASC) VISIBLE,
                                              CONSTRAINT `FK_Category`
                                                  FOREIGN KEY (`CategoryId`)
                                                      REFERENCES `WorkoutTracker`.`Categories` (`Id`)
                                                      ON DELETE NO ACTION
                                                      ON UPDATE NO ACTION);