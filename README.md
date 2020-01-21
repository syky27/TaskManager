# Who The Fuck OpenSources TODO apps?

This initially started as a hiring asignment for one company, the was as follows:

- [ X ] The main screen will contain a list of tasks
- [ X ] Each task contains the name, date (not the date of creation, but the date that the user enters as a deadline) and category
- [ X ] Category includes the name and color (use only a simple system colors)
- [ X ] Within the task on the main screen, the name of the task, date and color of the respective category will also be displayed
- [ X ] There will be two buttons on the right in the navigation bar – “Settings” and “Add a New Task”
- [ X ] Tasks can be deleted by a swipe
- [ X ] Details about the task will be displayed after tapping on the task. Data can be edited. Users will be able to turn on the notification (based on the time and date specified in the task)
- [ X ] Users should be able to mark the task as done (on the main screen and in the detailed view too). Tasks that are done will be displayed on the main screen clearly separated from tasks that are not done.
- [ X ] In the settings, users will be able to add categories (there will be 4 categories available by default) and change their colors.
- [ X ] Categories cannot be deleted.
- [ X ] User will be also able to turn off all the notifications and set sorting of tasks (by the date or alphabetically)
- [ X ] It’s necessary to use Core Data for storage
- [ ] For the implementation of incompletely specified items (marking task as done, editing categories in settings, ...) use your own invention and creativity :)


# What is is now

This is just my test project now.

## Why is it interesting?

It uses MVVM with Core Data where updates are driven by Combine... BOOM.
