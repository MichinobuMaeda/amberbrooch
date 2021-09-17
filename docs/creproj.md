# Creating this project

https://console.firebase.google.com/

- Add project
    - Project nane: amberbrooch
    - Configure Google Analytics
        - Create a new account: amberbrooch
        - Analytics location: Japan
- Project settings
    - Your apps
        - Select a platform to get started: </> (Web)
            - App nickname: Amber brooch
    - Your project
        - Default GCP resource location: asia-northeast1 (Tokyo)
        - Public-facing name: amberbrooch
        - Support email: my address
    - Usage and billing
        - Detailes & settings
            - Modify plan: Blaze 
- Authentication
    - Sign-in providers
        - Email/Password: Enable
            - Email link (passwordless sign-in): Enable
    - Templates
        _ Template language: Japanese
- Firestore Database
    - Create Database: Start in production mode

https://github.com/MichinobuMaeda

- Repositories
    - New
        - Repository name: amberbrooch

```
$ flutter --version
Flutter 2.5.0

$ flutter create --platforms=web amberbrooch
$ cd amberbrooch
$ git init
$ git add .
$ git commit -m "first commit"
$ git branch -M main
$ git remote add origin git@github.com:MichinobuMaeda/amberbrooch.git
$ git push -u origin main
$ firebase init functions
? Please select an option: Use an existing project
? Select a default Firebase project for this directory: amberbrooch (amberbrooch)
? What language would you like to use to write Cloud Functions? TypeScript
? Do you want to use ESLint to catch probable bugs and enforce style? Yes
? Do you want to install dependencies with npm now? No

$ cd functions/
$ yarn
$ cd ..
$ firebase init firestore
? What file should be used for Firestore Rules? firestore.rules
? What file should be used for Firestore indexes? firestore.indexes.json

$ firebase init storage
? What file should be used for Storage Rules? storage.rules

$ firebase init hosting
? What do you want to use as your public directory? build/web
? Configure as a single-page app (rewrite all urls to /index.html)? No
? Set up automatic builds and deploys with GitHub? No

$ firebase init emulators
? Which Firebase emulators do you want to set up?
 Authentication Emulator,
 Functions Emulator,
 Firestore Emulator,
 Hosting Emulator,
 Storage Emulator
? Which port do you want to use for the auth emulator? 9099
? Which port do you want to use for the functions emulator? 5001
? Which port do you want to use for the firestore emulator? 8080
? Which port do you want to use for the hosting emulator? 5000
? Which port do you want to use for the storage emulator? 9199
? Would you like to enable the Emulator UI? Yes
? Which port do you want to use for the Emulator UI (leave empty to use any available port)? 4040
? Would you like to download the emulators now? No

$ firebase init hosting:github
? For which GitHub repository would you like to set up a GitHub workflow? (format: user/repository) MichinobuMaeda/amberbrooch
? Set up the workflow to run a build script before every deploy? Yes
? What script should be run before every deploy? yarn install --frozen-lockfile && yarn build
? Set up automatic deployment to your site's live channel when a PR is merged? Yes
? What is the name of the GitHub branch associated with your site's live channel? main
i  Action required: Visit this URL to revoke authorization for the Firebase CLI GitHub OAuth App:
https://github.com/settings/connections/applications/89cf50f02ac6aaed3484
i  Action required: Push any new workflow file(s) to your repo

$ mv build/web/404.html web/
$ rm build/web/index.html 
```
