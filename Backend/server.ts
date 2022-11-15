import { Request, Response, Application } from "express";
// @ts-ignore
import express from "express";

const PORT = 3000;

const APP: Application = express();

APP.post("/", (req: Request, res: Response): void => {
  res.status(200).json({
    message: "This is a test"
  });
});

APP.listen(PORT, (): void => {
  console.log(`Server Running here -> http://localhost:${PORT}`);
});
