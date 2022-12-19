-- Delete present data
DELETE FROM Categories;
-- Categories
INSERT INTO Categories (Id, Name) VALUES ("c828d28c-36c5-4d3f-9e48-476ab887cd3b", "Brust");
INSERT INTO Categories (Id, Name) VALUES ("421ae4b3-bebd-4ff4-b58d-563aaaea74e7", "Bizeps");
INSERT INTO Categories (Id, Name) VALUES ("fff633bf-4dc1-4a61-80b9-b6ec90472f8e", "Schultern");
INSERT INTO Categories (Id, Name) VALUES ("8f4fa8ec-2889-4228-b00b-8bf9b124edf7", "Cardio");
INSERT INTO Categories (Id, Name) VALUES ("2ae19257-502c-4ebd-8127-2fbdfb2bcb5d", "Schwimmen");

-- Exercises
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("015ffbcf-8d58-4142-a54a-ffb7aaf8ec25", "Bankdrücken", "c828d28c-36c5-4d3f-9e48-476ab887cd3b", 0,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("1771dbc4-ea55-42eb-be29-86fc10d00835", "Guillotine Press", "c828d28c-36c5-4d3f-9e48-476ab887cd3b", 1,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("4f4666c9-5f31-4903-b5f1-50cca4c1cdbb", "Dips", "c828d28c-36c5-4d3f-9e48-476ab887cd3b", 0,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("8b958da2-4631-4d01-a234-2df01021d24e", "Kurzhantel-Curl", "421ae4b3-bebd-4ff4-b58d-563aaaea74e7", 0,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("44fbaa47-b0f0-4c67-91f2-b61e8022b646", "Hammer-Curl", "421ae4b3-bebd-4ff4-b58d-563aaaea74e7", 0,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("ffcd4298-9771-425f-98ee-691f1665e748", "Schulterdrücken", "fff633bf-4dc1-4a61-80b9-b6ec90472f8e", 1,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("e98cc70b-257f-48b3-895d-66fa87a3ff57", "Pike Push-Up", "fff633bf-4dc1-4a61-80b9-b6ec90472f8e", 0,0);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("576e382a-e5ab-4153-bc9f-66b076836f50", "Laufband", "8f4fa8ec-2889-4228-b00b-8bf9b124edf7", 2,1);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("3c120938-aed1-424d-8927-d2c5e854f26b", "Rennen", "8f4fa8ec-2889-4228-b00b-8bf9b124edf7", 4,2);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("63ea3082-e583-490d-9279-8406abe3a1dc", "Rückenschwimmen", "2ae19257-502c-4ebd-8127-2fbdfb2bcb5d", 3,1);
INSERT INTO Exercises (Id, Name, CategoryId, SizeUnit, LengthUnit) VALUES ("9e3166e5-a82e-454d-bb0f-0bda3fa14146", "Schmetterling-Stil", "2ae19257-502c-4ebd-8127-2fbdfb2bcb5d", 4,2);

-- Workouts
-- Bankdrücken:
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("e552d512-cef8-4106-825a-d97524e366a9", CURDATE(), "015ffbcf-8d58-4142-a54a-ffb7aaf8ec25");
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("e563d1a5-2a13-40b9-83d2-5ff43c6510cb", DATE_SUB(CURDATE(), INTERVAL 1 DAY), "015ffbcf-8d58-4142-a54a-ffb7aaf8ec25");
-- Guillotine Press
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("6db8d30a-3267-4adc-9ad2-a096f665c71c", CURDATE(), "1771dbc4-ea55-42eb-be29-86fc10d00835");
-- Dips
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("18f06727-1ae5-4981-9dec-215de2a8c8a5", CURDATE(), "4f4666c9-5f31-4903-b5f1-50cca4c1cdbb");
-- Kurzhantel-Curl
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("cfed3ece-05fa-48cc-8bef-4e474ef0c168", CURDATE(), "8b958da2-4631-4d01-a234-2df01021d24e");
-- Hammer-Curl
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("4d6f5848-1655-49d2-9188-543988a46f72", CURDATE(), "44fbaa47-b0f0-4c67-91f2-b61e8022b646");
-- Schulterdrücke 
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("9d0c9dbc-3e8b-4a59-8960-753f8e61d5e9", CURDATE(), "ffcd4298-9771-425f-98ee-691f1665e748");
-- Pike Push-Up
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("335955e6-fefe-4427-85eb-08faba7e1617", CURDATE(), "e98cc70b-257f-48b3-895d-66fa87a3ff57");
-- Laufband
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("0d52d0d2-1f9a-4d06-97b2-90f0d833987f", CURDATE(), "576e382a-e5ab-4153-bc9f-66b076836f50");
-- Rennen
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("80d61a05-61b0-42c3-925a-726290b351ca", CURDATE(), "3c120938-aed1-424d-8927-d2c5e854f26b");
-- Rückenschwimmen
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("af833df3-bede-4828-83e4-9c0fe14bfdda", CURDATE(), "63ea3082-e583-490d-9279-8406abe3a1dc");
-- Schmetterling-Stil
INSERT INTO Workouts (Id, Name, ExerciseId) VALUES ("9ce8c743-8fe9-453b-b704-c98a14a0e439", CURDATE(), "9e3166e5-a82e-454d-bb0f-0bda3fa14146");

-- Sets
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("51b723ed-1e3d-4ddd-b96a-e5a6a7702472", 70, 8, "e552d512-cef8-4106-825a-d97524e366a9");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("5cb6ad74-f3d3-4444-a9f2-0c641a22cc06", 65, 12, "e552d512-cef8-4106-825a-d97524e366a9");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("26819844-2be5-4a42-bc13-554f0efef819", 55, 12, "e563d1a5-2a13-40b9-83d2-5ff43c6510cb");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("79747f5f-c5dd-421e-85bd-09efb33bac0a", 140, 6, "6db8d30a-3267-4adc-9ad2-a096f665c71c");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("cb3628d1-87d9-41d6-8830-18ec82c7cab4", 73.5, 15, "18f06727-1ae5-4981-9dec-215de2a8c8a5");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("78f2b7da-8801-48d1-b0fa-5a4c1ed9e740", 20, 12, "cfed3ece-05fa-48cc-8bef-4e474ef0c168");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("ad9a8c5d-8ce7-40a4-878b-4e39fb5f8cbc", 20, 12, "4d6f5848-1655-49d2-9188-543988a46f72");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("24ae1bda-73bf-496e-a410-03dd07243b67", 140, 8, "9d0c9dbc-3e8b-4a59-8960-753f8e61d5e9");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("4e3673cc-07ed-43f5-8f19-d22c20ddc409", 73.5, 12, "335955e6-fefe-4427-85eb-08faba7e1617");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("042993a1-39bc-4fbd-86eb-c4f7c3709f9e", 20, 60, "0d52d0d2-1f9a-4d06-97b2-90f0d833987f");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("b80db104-79e6-4806-8750-a8f443352e7b", 100, 11.8, "80d61a05-61b0-42c3-925a-726290b351ca");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("ff28086c-b5e5-4076-afc9-02c4295d2e48", 1.2, 30, "af833df3-bede-4828-83e4-9c0fe14bfdda");
INSERT INTO Sets (Id, HowMuch, HowLong, WorkoutId) VALUES ("250e8a51-eb79-4467-bb09-89bfd80299b0", 50, 30, "9ce8c743-8fe9-453b-b704-c98a14a0e439");
