# WorkoutTracker
WorkoutTracker is an IOS group project completed as part of IOS development lecture at HSLU.
## Setup
The backend component uses [node.js](https://nodejs.org/en/) with a mysql database connection.

1. To install the necessary packages, run

    ```bash
    npm install
    ```
    in the Backend directory.

2. Run the sql create script in Backend/create_scripts/schema.sql 
to create the schema necessary for running the backend.

3. Change the following values in Backend/Models/DbContext.ts to fit your db installation:

    ```typescript
    9:  readonly DB_HOST: string = "localhost";
    10: readonly DB_USERNAME: string = "<USERNAME>"; //change to your sql user
    11: readonly DB_PASSWORD: string = "<PASSWORD>"; //change to your sql user password
    12: readonly DB_SCHEMA_NAME: string = "WorkoutTracker";
    ```
## Usage
For production mode, run
```bash
npm start
```

For dev mode, where server restarts on change, run
```bash
npm run dev
```
Then deploy app or run simulator in XCode and you're good to go.


## Contributors
- Samuel Nussbaumer
- Lenny Budliger

## License

[MIT](https://choosealicense.com/licenses/mit/)