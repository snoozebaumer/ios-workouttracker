ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
flush privileges;

CREATE SCHEMA `WorkoutTracker` ;

CREATE TABLE `WorkoutTracker`.`Categories` (
                                               `Id` VARCHAR(36) NOT NULL,
                                               `Name` VARCHAR(255) NULL,
                                               PRIMARY KEY (`Id`));

CREATE TABLE `WorkoutTracker`.`Exercises` (
                                              `Id` VARCHAR(36) NOT NULL,
                                              `Name` VARCHAR(255) NULL,
                                              `CategoryId` VARCHAR(36) NOT NULL,
                                              `SizeUnit` INT NOT NULL,
                                              `LengthUnit` INT NOT NULL,
                                              PRIMARY KEY (`Id`),
                                              INDEX `FK_Category_idx` (`CategoryId` ASC) VISIBLE,
                                              CONSTRAINT `FK_Category`
                                                  FOREIGN KEY (`CategoryId`)
                                                      REFERENCES `WorkoutTracker`.`Categories` (`Id`)
                                                      ON DELETE cascade
                                                      ON UPDATE NO ACTION);

 CREATE TABLE `WorkoutTracker`.`Workouts` (
                                              `Id` VARCHAR(36) NOT NULL,
                                              `Name` DATETIME NULL,
                                              `ExerciseId` VARCHAR(255) NULL,
                                              PRIMARY KEY (`Id`),
                                              INDEX `FK_Exercise_idx` (`ExerciseId` ASC) VISIBLE,
                                              CONSTRAINT `FK_Exercise`
                                                  FOREIGN KEY (`ExerciseId`)
                                                      REFERENCES `WorkoutTracker`.`Exercises` (`Id`)
                                                      ON DELETE cascade
                                                      ON UPDATE NO ACTION);

 CREATE TABLE `WorkoutTracker`.`Sets` (
                                              `Id` VARCHAR(36) NOT NULL,
                                              `HowMuch` FLOAT NULL,
                                              `HowLong` FLOAT NULL,
                                              `WorkoutId` VARCHAR(255) NULL,
                                              PRIMARY KEY (`Id`),
                                              INDEX `FK_Workout_idx` (`WorkoutId` ASC) VISIBLE,
                                              CONSTRAINT `FK_Workout`
                                                  FOREIGN KEY (`WorkoutID`)
                                                      REFERENCES `WorkoutTracker`.`Workouts` (`Id`)
                                                      ON DELETE cascade
                                                      ON UPDATE NO ACTION);                                        




