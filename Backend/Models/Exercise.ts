import {Category} from "./Category";

export class Exercise {
    id: string;
    name: string;
    category: Category;
    eSet: []
  

    constructor(id: string, name: string, category: Category) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.eSet = []

    }
}