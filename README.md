# Pantry Service

A pantry service backend application built on Ruby on Rails (with linting and testing)

## Installation

To setup the application, follow these steps - 

1. for each of the services, go to respective folder.
2. do ``` bundle install```.
3. setup enviornment variables used in database.yml file.
4. do ``` rails db:setup```.
5. do ``` rails db:migrate```.
6. Run the following services on the corresponding ports -
    - pro-backend - ``` rails s ```
    - Auth - ``` rails s -p 3001 ```
    - Notification - ``` rails s -p 3002 ``` 
7. For notification, we also need to keep sidekick running as - 
    ``` bash 
    bundle exec sidekiq -C config/sidekiq.yml 
    ```
