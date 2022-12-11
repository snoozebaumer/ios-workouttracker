import {Request, Response, Application} from "express";
// @ts-ignore
import express from "express";
import {Exercise} from "./Models/Exercise";
import {DbContext} from "./Models/DbContext";
import {Workout} from "./Models/Workout";
import * as bodyParser from "body-parser";

const PORT = 3000;

const APP: Application = express();
APP.use(bodyParser.urlencoded({extended: true}))

const db = new DbContext();

APP.post("/exercise/", (req: Request, res: Response): void => {
    let exercise: Exercise = JSON.parse(req.body.exercise);
    db.save(exercise).then((success) => {
        if (success) {
            res.status(200).json({
                message: "Saved successfully!"
            });
        } else {
            res.status(500).json({
                message: "An error occurred while saving changes. Please try again later."
            });
        }
    });
});

APP.put("/exercise/:id", (req: Request, res: Response): void => {
    console.log(req.body)
    let exercise: Exercise = JSON.parse(req.body.exercise);
    db.update(exercise).then((success) => {
        if (success) {
            res.status(200).json({
                message: "Edited successfully!"
            });
        } else {
            res.status(500).json({
                message: "An error occurred while saving changes. Please try again later."
            });
        }
    });
});

APP.delete("/exercise/:id", (req: Request, res: Response): void => {
    let id: string = req.params.id;
    console.log(id)
    db.delete(id).then((categoryIncluded) => {
        res.status(200).json({
            categoryIncluded: categoryIncluded
        });
    }).catch(() => {
        res.status(500).json({
            message: "An error occurred while deleting exercise. Please try again later."
        });
    });
});

APP.delete("/workout/:id", (req: Request, res: Response): void => {
    let id: string = req.params.id;
    console.log(id)
    //Anpassen
    db.deleteWorkout(id).then((success) => {
        if (success) {
            res.status(200).json({
                message: "Workout deleted successfully!"
            });
        } else {
            res.status(500).json({
                message: "An error occurred while deleting workout. Please try again later."
            });
        }
    });
});


APP.get("/exercises/", (req: Request, res: Response): void => {
    db.get().then((exercises) => {
        res.status(200).json(exercises);
    }).catch(() => {
        res.status(500).json({
            message: "An error occurred while fetching exercises. Please try again later."
        });
    });
});


APP.listen(PORT, (): void => {
    console.log(`Server Running here -> http://localhost:${PORT}`);
});
