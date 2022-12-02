

export class Workout {
    id: string;
    name: string;
    exerciseID: string;
    sets: []
  

    constructor(id: string, name: string, exerciseID: string) {
        this.id = id;
        this.name = name;
        this.exerciseID = exerciseID;
        this.sets = []
    }
}