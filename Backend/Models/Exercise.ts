import {Category} from "./Category";

export class Exercise {
    id: string;
    name: string;
    category: Category;
    sizeUnit: number;
    lengthUnit: number;
    eSet: []
  

    constructor(id: string, name: string, category: Category, sizeUnit: number, lengthUnit: number) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.eSet = [];
        this.sizeUnit = sizeUnit;
        this.lengthUnit = lengthUnit;
    }
}