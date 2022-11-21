import * as mysql from "mysql"
import {Exercise} from "./Exercise";
import {Category} from "./Category";
import {Connection, OkPacket} from "mysql";

export class DbContext {
    dbHost: string = "localhost";
    dbUsername: string = "root";
    dbPassword: string = "password";
    dbName: string = "WorkoutTracker";

    exercises: Array<Exercise> = new Array<Exercise>();
    categories: Array<Category> = new Array<Category>();
    connection: Connection;

    constructor() {
        this.connection = mysql.createConnection({
            host: this.dbHost,
            user: this.dbUsername,
            password: this.dbPassword,
            database: this.dbName
        })
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

    async executeInDb(sql: string, values: Array<any>): Promise<OkPacket> {
        return new Promise<OkPacket>((resolve, reject) => {
            this.connection.query(sql, values, function (err: any, data: OkPacket) {
                if (err) {
                    reject(err);
                } else {
                    resolve(data);
                }
            });
        })
    }

}