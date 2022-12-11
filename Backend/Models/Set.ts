export class Set {
    id: string;
    howmuch: number;
    howlong: number;
    workoutID: string;
  

    constructor(id: string, howmuch: number, howlong: number ,workoutID: string) {
        this.id = id;
        this.howmuch = howmuch
        this.howlong = howlong
        this.workoutID = workoutID;
        
    }
}