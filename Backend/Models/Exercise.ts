import {Category} from "./Category";

export class Exercise {
    id: string;
    name: string;
    category: Category;
    sizeUnit: number;
    lengthUnit: number;
    workouts: []
  

    constructor(id: string, name: string, category: Category, sizeUnit: number, lengthUnit: number) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.workouts = [];
        this.sizeUnit = sizeUnit;
        this.lengthUnit = lengthUnit;
    }
}