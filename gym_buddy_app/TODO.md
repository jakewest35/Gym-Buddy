# TODO List

## Version 1.0
- [x] Fix the state managament bug on the new_workout_screen
- [x] Implmement state management feature on diet log screen once the above has been fixed
- [x] Add backlog of data for previous dates
    - Extensive meal log
    - Comprehensive workouts
    - Realistic journal entries

## Version 2.0
- [ ] Redesign logic flow
  - **General**:
    - [x] Create consistent data entry formats
    - [ ] Give the user the option to append to a data entry if it has already been posted to the database
  - **Dashboard Page**
    - [x] Change date picker from wheel to calendar format
  - **Workout Log**:
    - [x] Remove "View previous workouts" button in workout log (this data will be made available in the overall data retrieval feature)
    - [x] Only have 1 screen: workout data entry
    - [x] Give user the option to edit entries
    - [ ] Add support for non-weight lifting workouts (cardio, hockey, etc.)
  - **Meal Log**:
    - [ ] Look into MyFitnessPal API integration?
    - [ ] Add a "Save to favorites" feature that will allow the user to save meals that are frequently consumed
      - Could just be a flag and, when checked, will add the meal to a list of favorites for the current user.
    - [x] Give user the option to edit entries
    - [x] Add an a summary of their total calories and macros to the page
      - Style the info
    - [ ] Auto complete?
  - **Journal Log**
    - [x] Add field for bodyweight entry in journal log (this data will be made available in the overall data retrieval)
- [ ] **Redesign UI**
  - Add a "see your progress" type of button to the home screen and present the user with the following options:
    - Get all data for a previous day
    - See visualization of their progress on a particular lift
      - This could also be expanded to track progress on non-weight focused exercises (ex. mile times)
    - See visualization of their bodyweight over time
- **Research**
  - [ ] Research graphing libraries for visualizing user progress over time
    - Look into [SyncFusion](https://www.syncfusion.com/blogs/post/introducing-data-viz-widgets-for-flutter.aspx) more.
  - [ ] Also look into syncing the data from Apple watch
      - Flutter health package
      - Could get steps, fitness data, etc.