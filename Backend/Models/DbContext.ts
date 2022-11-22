import * as mysql from "mysql"
import {Exercise} from "./Exercise";
import {Category} from "./Category";
import {Connection, OkPacket} from "mysql";

export class DbContext {
    private dbHost: string = "localhost";
    private dbUsername: string = "root";
    private dbPassword: string = "password";
    private dbName: string = "WorkoutTracker";

    private exercises: Array<Exercise> = new Array<Exercise>();
    private categories: Array<Category> = new Array<Category>();
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
        let exercisesDb = await this.getExercises();
        this.exercises = exercisesDb.map((value) => {
            let category = this.categories.find(c => c.id == value.CategoryId);
            if (!category) {
                throw TypeError();
            }
            return new Exercise(value.Id, value.Name, category);
        });

        return this.exercises;
    }

    async save(exercise: Exercise): Promise<boolean> {
        let isSuccess = false;

        if (!await this.handleCategory(exercise)) {
            return isSuccess;
        }

        let sql = `INSERT INTO Exercises
                       (Id, Name, CategoryId)
                   VALUES (?, ?, ?)`

        try {
            await this.executeInDb(sql, [exercise.id, exercise.name, exercise.category.id]);
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

        let sql = `UPDATE Exercises
                      SET Name=?, CategoryId=?
                      WHERE Id=?;`

        try {
            await this.executeInDb(sql, [exercise.name, exercise.category.id, exercise.id]);
            isSuccess = true;
        } catch (e) {
            console.log(e);
            isSuccess = false;
        }

        return isSuccess
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

    private async executeInDb(sql: string, values: Array<any>): Promise<OkPacket> {
        return new Promise<OkPacket>((resolve, reject) => {
            this.connection.query(sql, values, function (err: any, data: OkPacket) {
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

    private async getExercises(): Promise<Array<{Id: string, Name: string, CategoryId: String}>> {
        return new Promise<Array<{Id: string, Name: string, CategoryId: String}>>((resolve, reject) => {
            this.connection.query(`SELECT * FROM Exercises`,
                function (err: any, data: Array<{Id: string, Name: string, CategoryId: String}>) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(data);
                    }
                });
        });
    }
}