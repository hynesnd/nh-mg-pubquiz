# MG's pub quiz app

## Project summary

This project is a prototype of a pub quiz web app.

- Users will access the site and be presented with a set of quiz questions fetchd from the back end api.
- The user can then click buttons to select their answers and submit their answers.
- The answers will be checked in the backend and a score returned to the user in the front end.

It is written using:

- [Elm](https://elm-lang.org/) with [Elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/1.1.8/) for Frontend & Styling
- [Node.js](https://nodejs.org/en/)
- [Express](https://expressjs.com/) as api server framework.
- [Jest](https://jestjs.io/) & [supertest](https://www.npmjs.com/package/supertest) for back end testing.


## Minimum prerequisites for running this project

You will need to have the following software installed to download and work with this project:

- Node.js v17.4.0 - Install instructions [Here](https://nodejs.dev/learn/how-to-install-nodejs)
- A code editor such as [VSCode](https://code.visualstudio.com/)

## Running this project

<br>

#### 1. To begin, run the following bash command in the directory you would like the repo to be located:

```bash
git clone https://github.com/hynesnd/nh-mg-pubquiz.git
```

<br>

#### 2. Open the repo folder in VSCode or your code editor of choice. Next, open a terminal in your code editor and run the following commands:

```bash
npm install
npm install --dev
```

#### This will install all node packages required for normal running of the repo, including dev dependencies such as the testing modules.

<br>

#### 3. To start the backend server run this command:

```bash
npm start
```

#### By default the server will run on `localhost:9090`

<br>

#### 4. To open the front end run the following command:

```bash
npm run fe-start
```

Or, to run with debug tools enabled:

```bash
npm run fe-dev
```

By default elm-live will run the front end from `localhost:8000`
