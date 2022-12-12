import {Category} from "./Category";
import {Workout} from "./Workout";

export class Exercise {
    id: string;
    name: string;
    category: Category;
    sizeUnit: number;
    lengthUnit: number;
    workouts: Array<Workout>
  

    constructor(id: string, name: string, category: Category, sizeUnit: number, lengthUnit: number, workouts: Workout[] = []) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.workouts = workouts;
        this.sizeUnit = sizeUnit;
        this.lengthUnit = lengthUnit;
    }
}