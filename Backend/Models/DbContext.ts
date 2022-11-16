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
        let success = false;

        if (!await this.handleCategory(exercise)) {
            return success;
        }

        let sql = `INSERT INTO Exercises
                       (Id, Name, CategoryId)
                   VALUES (?, ?, ?)`

        try {
            await this.executeInDb(sql, [exercise.id, exercise.name, exercise.category.id]);
            this.exercises.push(exercise);
            success = true;
        } catch (e) {
            console.log(e)
            success = false;
        }

        return success
    }

    async update(exercise: Exercise): Promise<boolean> {
        let success = true;
        // TODO: update incoming exercise on DB
        return success
    }

    async handleCategory(exercise: Exercise): Promise<boolean> {
        let success = false;

        if (this.categories.indexOf(exercise.category) >= 0) {
            return success;
        }

        let sql = `INSERT IGNORE INTO Categories
                       (Id, Name)
                   VALUES (?, ?)`

        try {
            await this.executeInDb(sql, [exercise.category.id, exercise.category.name]);
            this.categories.push(exercise.category);
            success = true;
        } catch (e) {
            console.log(e);
            success = false;
        }

        return success;
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