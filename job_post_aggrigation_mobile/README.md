# job_post_aggrigation_mobile

## Project Goals
    - Look into available Job board API's to use
        - ~~Linkedin (through [rapidAPI](https://rapidapi.com/jaypat87/api/linkedin-jobs-search/))~~
          - hard limit of 25 requests/month
        - ~~Indeed (through [rapidAPI](https://rapidapi.com/indeed/api/indeed/))~~
          - Completely free, unlimited requests
        - ~~[Official Ziprecruiter API](https://www.ziprecruiter.com/zipsearch)~~
          - This probably isn't an option though, need to be a partner to access it 😢
        - [**JSearch API**](https://rapidapi.com/letscrape-6bRBa3QguO5/api/jsearch/details)
          - This might be the most viable option. 
          - Queries Linkedin, Indeed, GlassDoor, Ziprecruiter, Dice, etc.
          - hard limit of 200 requests/month
- [ ] User can sign in/out with email/password or google account
- [ ] User can search for jobs by selecting from available Job boards
- [ ] User can only search for jobs if authenticated
- User profile will contain:
  - [ ] ability to edit their profile
  - [ ] list qualifications/previous experience
  - [ ] links to relevant materials(resume website, linkedin, etc)
  - [ ] list their job preferences
- [ ] Jobs are presented in order of relevance to the users query

## Project Structure
- Component for authentication
  - will communicate with firebase
- Component for user profile/information
  - This will handle diplaying/storing/updating user information
  - will also communicate with firebase
- Component for handling the API requests/formatting (see Fetching data from the internet using Dart)

## User Flow
- On initial launch, user will be prompted to either sign in or sign up
- Once authenticated, user will be presented with the search screen and available filters to select from
- On successful query, user will be presented with a list of available jobs returned from the API
- Application will have a side drawer to navigate between the job search module and the user profile module, along with a sign out button

## Resources

- [Fetching data from the internet using Dart](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [Flutter dotenv](https://pub.dev/packages/flutter_dotenv)
