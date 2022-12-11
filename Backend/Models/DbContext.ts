import * as mysql from "mysql"
import {Exercise} from "./Exercise";
import {Category} from "./Category";
import {Workout} from "./Workout";
import {Set} from "./Set";
import {Connection, OkPacket} from "mysql";

export class DbContext {
    private dbHost: string = "localhost";
    private dbUsername: string = "root";
    private dbPassword: string = "password";
    private dbName: string = "WorkoutTracker";

    private exercises: Array<Exercise> = new Array<Exercise>();
    private categories: Array<Category> = new Array<Category>();
    private workouts: Array<Workout> = new Array<Workout>();
    private sets: Array<Set> = new Array<Set>();
    private connection: Connection;

    constructor() {
        this.connection = mysql.createConnection({
            host: this.dbHost,
            user: this.dbUsername,
            password: this.dbPassword,
            database: this.dbName
        })
    }

  
    async get(): Promise<Array<Exercise>> {
        
        if(this.exercises.length > 0) {
            return this.exercises;
        }

        this.categories = await this.getCategories();
       // TODO: getWorkouts to be implemented, also get them in reverse order, so last workout is first
       //get all workouts with foreign key=excercise.id and add them
        let exercisesDb = await this.getExercises();
        let workoutsDb = await this.getWorkouts();
        this.exercises = exercisesDb.map((value) => {
            let category = this.categories.find(c => c.id == value.CategoryId);
            if (!category) {
                throw TypeError();
            }
            return new Exercise(value.Id, value.Name, category, value.SizeUnit, value.LengthUnit);
        });
            return this.exercises;
    }

    async save(exercise: Exercise): Promise<boolean> {
        let isSuccess = false;

        if (!await this.handleCategory(exercise)) {
            return isSuccess;
        }

        let sql = `INSERT INTO Exercises
                       (Id, Name, CategoryId, SizeUnit, LengthUnit)
                   VALUES (?, ?, ?, ?, ?)`

        try {
            await this.executeInDb(sql, [exercise.id, exercise.name, exercise.category.id,
                exercise.sizeUnit, exercise.lengthUnit]);
            this.exercises.push(exercise);
            isSuccess = true;
        } catch (e) {
            console.log(e)
            isSuccess = false;
        }

        return isSuccess
    }

    async update(exercise: Exercise): Promise<boolean> {
        let isSuccess = false;

        if (!await this.handleCategory(exercise)) {
            return isSuccess;
        }
        let setSql = 'INSERT INTO Sets (Id, HowMuch, HowLong , WorkoutID) VALUES(?, ?, ?, ?)'
        let workoutSql = 'INSERT INTO Workouts (Id, Name, ExerciseID) VALUES(?, ?, ?)'
        
        for (var w of exercise.workouts){
            let ww: Workout = w
            if((this.workouts.findIndex((value) => value.id == ww.id)==-1)){
                this.workouts.push(ww)
                try{
                    await this.executeInDb(workoutSql, [ww.id, ww.name,
                        ww.exerciseID]);
                }
                catch (e) {
                    console.log(e);
                    
                }

            }
            for (var s of ww.sets){
                let ss: Set = s
                if((this.sets.findIndex((value) => value.id == ss.id))==-1){
                    this.sets.push(ss)
                    try{
                        await this.executeInDb(setSql,[ss.id, ss.howmuch, ss.howlong, ss.workoutID])
                    }
                    catch (e) {
                        console.log(e);
                    }
                }
                

            }
            
        }



        let sql = `UPDATE Exercises
                      SET Name=?, CategoryId=?, SizeUnit=?, LengthUnit=?
                      WHERE Id=?;`

        try {
            await this.executeInDb(sql, [exercise.name, exercise.category.id,
                exercise.sizeUnit, exercise.lengthUnit, exercise.id]);
            let index = this.exercises.findIndex((value) => value.id == exercise.id);
            this.exercises[index] = exercise;
            isSuccess = true;
        } catch (e) {
            console.log(e);
            isSuccess = false;
        }

        return isSuccess
    }

    async delete(id: string): Promise<boolean> {
        let sqlCategoryId = `SELECT CategoryId FROM Exercises 
                    WHERE Id = ?`
        let categoryResult = await this.executeInDb(sqlCategoryId, [id]);

        let sqlDeletion = `DELETE FROM Exercises 
                    WHERE Id = ?`
        let result = await this.executeInDb(sqlDeletion, [id]);

        if(result.affectedRows === 0) {
            throw Error();
        }
        let index = this.exercises.findIndex((value: Exercise) => value.id == id);
        this.exercises.splice(index, 1);

        return await this.tryDeleteCategory(categoryResult[0].CategoryId);
    }

    async tryDeleteCategory(id: string): Promise<boolean> {
        let sql = `DELETE FROM Categories 
                    WHERE Id = ? AND Id not IN 
                    (
                        SELECT  CategoryId 
                        FROM    Exercises
                    )`

        let result = await this.executeInDb(sql,[id]);
        return !(result.affectedRows === 0); //have to do this rather than > 0 as type wasn't compared that way
    }

    async handleCategory(exercise: Exercise): Promise<boolean> {
        let isSuccess = false;

        if (this.categories.indexOf(exercise.category) >= 0) {
            return !isSuccess;
        }

        let sql = `INSERT IGNORE INTO Categories
                       (Id, Name)
                   VALUES (?, ?);`

        try {
            await this.executeInDb(sql, [exercise.category.id, exercise.category.name]);
            this.categories.push(exercise.category);
            isSuccess = true;
        } catch (e) {
            console.log(e);
            isSuccess = false;
        }

        return isSuccess;
    }

    private async executeInDb(sql: string, values: Array<any>): Promise<OkPacket | any> {
        return new Promise<OkPacket>((resolve, reject) => {
            this.connection.query(sql, values, function (err: any, data: OkPacket | any) {
                if (err) {
                    reject(err);
                } else {
                    resolve(data);
                }
            });
        });
    }

    private async getCategories(): Promise<Array<Category>> {
        return new Promise<Array<Category>>((resolve, reject) => {
            this.connection.query(`SELECT * FROM Categories`,
                function (err: any, data: Array<{Id: string, Name: string}>) {
                if (err) {
                    reject(err);
                } else {
                    let categoryList: Array<Category> = data.map(value => {
                        return new Category(value.Id, value.Name);
                    })
                    resolve(categoryList);
                }
            });
        });
    }

    private async getExercises(): Promise<Array<{Id: string, Name: string, CategoryId: String,
                                                SizeUnit: number, LengthUnit: number}>> {
        return new Promise<Array<{Id: string, Name: string, CategoryId: String,
            SizeUnit: number, LengthUnit: number}>>((resolve, reject) => {
            this.connection.query(`SELECT * FROM Exercises`,
                (err: any, data: Array<{
                    Id: string, Name: string, CategoryId: String,
                    SizeUnit: number, LengthUnit: number
                }>) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(data);
                    }
                });
        });
    }

    private async getWorkouts(): Promise<Array<{Id: string, Name: string, ExerciseId: String
                                               }>> {
        return new Promise<Array<{Id: string, Name: string, ExerciseId: String
            }>>((resolve, reject) => {
            this.connection.query(`SELECT * FROM Workouts`,
                (err: any, data: Array<{
                    Id: string, Name: string, ExerciseId: String
                }>) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(data);
                    }
                });
        });
    }




    // --- WORKOUTS ---
    async saveWorkout(workout: Workout): Promise<boolean> {
        let isSuccess = false;
      

        let sql = `INSERT INTO Workouts
                       (Id, Name, ExerciseId)
                   VALUES (?, ?, ?)`

        try {
            await this.executeInDb(sql, [workout.id, workout.name, workout.exerciseID]);
            this.workouts.push(workout);
            isSuccess = true;
        } catch (e) {
            console.log(e)
            isSuccess = false;
        }

        return isSuccess
    }


}