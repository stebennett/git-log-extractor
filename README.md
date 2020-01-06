# Git Reader
A simple Ruby script to read the log of a git repository and create a csv file representing the changes in the following format.

````text
    timestamp, sha, author name, author email, commit message, file changed
````

Each file that is changed has a new row.

## Dependencies

* Ruby 2.6.x

## Running

    $> bundle install
    $> ./gitextractor.rb -h

## Options
The supported options are:

````text
    "-d", "--directory DIRECTORY": The cloned repository to scan
    "-s", "--since TIMESTAMP": A timestamp to fetch items from (default 1970-01-01)
    "-c", "--count COUNT": The number of commits to fetch (default 1000)
    "-f", "--file FILE": The output file (default output.csv)
    "-h", "--help": "Shows help"
````
