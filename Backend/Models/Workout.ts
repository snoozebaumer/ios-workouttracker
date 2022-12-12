import {Set} from "./Set";

export class Workout {
    id: string;
    name: Date;
    exerciseID: string;
    sets: Array<Set>
  

    constructor(id: string, name: Date, exerciseID: string) {
        this.id = id;
        this.name = name;
        this.exerciseID = exerciseID;
        this.sets = []
    }
}