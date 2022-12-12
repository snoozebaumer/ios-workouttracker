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

    // Response Cache
    private exercises: Array<Exercise> = new Array<Exercise>();
    private categories: Array<Category> = new Array<Category>();

    // Delta Comparison Cache
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
        if (this.exercises.length > 0) {
            return this.exercises;
        }

        this.categories = await this.getCategories();
        let exercisesDb = await this.getExercises();
        let workoutsDb = await this.getWorkouts();
        this.sets = await this.getSets();

        this.workouts = workoutsDb.map((workout: Workout) => {
            workout.sets = <Set[]>this.sets.filter((set) => {
                return set.workoutID === workout.id;
            });
            return workout;
        })

        this.exercises = exercisesDb.map((value) => {
            let category = this.categories.find(c => c.id == value.CategoryId);
            if (!category) {
                throw TypeError();
            }
            return new Exercise(value.Id, value.Name, category, value.SizeUnit, value.LengthUnit,
                <Workout[]>this.workouts.filter((workout) => {
                return workout.exerciseID === value.Id;
            }));
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
        let updatedSets: Array<Set> = []
        let deltaSets: Array<Set> = []

        for (let ws of this.workouts) {
            if (ws.exerciseID == exercise.id) {
                for (let ds of this.sets) {
                    if (ds.workoutID == ws.id) {
                        deltaSets.push(ds)
                    }
                }
            }
        }

        if (!await this.handleCategory(exercise)) {
            return isSuccess;
        }

        let setSql = 'INSERT IGNORE INTO Sets (Id, HowMuch, HowLong , WorkoutID) VALUES(?, ?, ?, ?)'
        let workoutSql = 'INSERT INTO Workouts (Id, Name, ExerciseID) VALUES(?, FROM_UNIXTIME(?), ?)'
        let deleteSetSql = `DELETE FROM Sets
                            WHERE Id = ?`

        for (let workout of exercise.workouts) {
            if ((this.workouts.findIndex((value) => value.id == workout.id) == -1)) {
                this.workouts.unshift(workout)
                try {
                    await this.executeInDb(workoutSql, [workout.id, new Date(workout.name).getTime() / 1000,
                        workout.exerciseID]);
                } catch (e) {
                    console.log(e);
                }
            }

            for (let set of workout.sets) {
                updatedSets.push(set)
                if ((this.sets.findIndex((value) => value.id == set.id)) == -1) {
                    this.sets.push(set)
                    try {
                        await this.executeInDb(setSql, [set.id, set.howmuch, set.howlong, set.workoutID])
                    } catch (e) {
                        console.log(e);
                    }
                }
            }
        }

        for (let deltaSet of deltaSets) {
            if ((updatedSets.findIndex((value) => value.id == deltaSet.id)) == -1) {
                let index = this.sets.findIndex((value: Set) => value.id == deltaSet.id);
                this.sets.splice(index, 1);
                try {
                    await this.executeInDb(deleteSetSql, [deltaSet.id]);
                } catch (e) {
                    console.log(e);

                }
            }
        }


        let sql = `UPDATE Exercises
                   SET Name=?,
                       CategoryId=?,
                       SizeUnit=?,
                       LengthUnit=?
                   WHERE Id = ?;`

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

    async deleteWorkout(id: string): Promise<boolean> {
        let sqlDeletion = `DELETE
                           FROM Workouts
                           WHERE Id = ?`
        let result = await this.executeInDb(sqlDeletion, [id]);

        let isSuccess = result.affectedRows !== 0;

        if (isSuccess) {
            let index = this.workouts.findIndex((value: Workout) => value.id == id);
            let deletedWorkout = this.workouts[index];

            if (deletedWorkout && this.exercises.length > 0) {
                let exerciseIndex = this.exercises.findIndex((exercise) => exercise.id === deletedWorkout.exerciseID);
                let indexInExercisesWorkouts = this.exercises[exerciseIndex].workouts.findIndex((value: Workout) => value.id == id);
                this.exercises[exerciseIndex].workouts.splice(indexInExercisesWorkouts, 1);
                this.sets = this.sets.filter((set) => {return set.workoutID != deletedWorkout.id});
            }
            this.workouts.splice(index, 1);
        }

        return isSuccess;
    }

    async delete(id: string): Promise<boolean> {
        let sqlCategoryId = `SELECT CategoryId
                             FROM Exercises
                             WHERE Id = ?`
        let categoryResult = await this.executeInDb(sqlCategoryId, [id]);

        let sqlDeletion = `DELETE
                           FROM Exercises
                           WHERE Id = ?`
        let result = await this.executeInDb(sqlDeletion, [id]);

        if (result.affectedRows === 0) {
            throw Error();
        }
        let index = this.exercises.findIndex((value: Exercise) => value.id == id);
        this.exercises.splice(index, 1);

        return await this.tryDeleteCategory(categoryResult[0].CategoryId);
    }

    async tryDeleteCategory(id: string): Promise<boolean> {
        let sql = `DELETE FROM Categories
                   WHERE Id = ?
                     AND Id not IN
                         (SELECT CategoryId
                          FROM Exercises)`

        let result = await this.executeInDb(sql, [id]);
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
            this.connection.query(`SELECT *
                                   FROM Categories`,
                function (err: any, data: Array<{ Id: string, Name: string }>) {
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

    private async getExercises(): Promise<Array<{
        Id: string, Name: string, CategoryId: String,
        SizeUnit: number, LengthUnit: number }>> {
        return new Promise<Array<{
            Id: string, Name: string, CategoryId: String,
            SizeUnit: number, LengthUnit: number }>>((resolve, reject) => {
            this.connection.query(`SELECT *
                                   FROM Exercises`,
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

    private async getWorkouts(): Promise<Array<Workout>> {
        return new Promise<Array<Workout>>((resolve, reject) => {
            this.connection.query(`SELECT *
                                   FROM Workouts
                                   ORDER BY Name DESC`,
                (err: any, data: Array<{
                    Id: string, Name: Date, ExerciseId: string
                }>) => {
                    if (err) {
                        reject(err);
                    } else {
                        let workouts: Array<Workout> = data.map((value) => {
                            return new Workout(value.Id, value.Name, value.ExerciseId);
                        });
                        resolve(workouts);
                    }
                });
        });
    }

    private async getSets(): Promise<Array<Set>> {
        return new Promise<Array<Set>>((resolve, reject) => {
            this.connection.query(`SELECT *
                                   FROM Sets`,
                (err: any, data: Array<{
                    Id: string, HowMuch: number, HowLong: number, WorkoutId: string
                }>) => {
                    if (err) {
                        reject(err);
                    } else {
                        let sets: Array<Set> = data.map((value) => {
                            return new Set(value.Id, value.HowMuch, value.HowLong, value.WorkoutId);
                        });
                        resolve(sets);
                    }
                });
        });
    }
}