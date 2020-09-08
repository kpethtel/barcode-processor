# Setup

The Dockerfile expects your local user to have uid 1000 and gid 1000. If they are different update the Dockerfile accordingly. 

Initial setup:
* mkdir -p tmp/bundle
* docker-compose up
* docker-compose exec web bundle --jobs=8
* docker-compose exec web rails db:setup

Then, for developing:
* docker-compose up
* docker-compose exec web rails s -b 0.0.0.0
* docker-compose exec web rails c

The website can be opened at http://localhost:3000. The docker-compose.yml is mounting your host folder in the container. So changes you make on the app will automatically be reflected in the container.


# Your tasks

#### 1. As a user I want to upload an excel file of barcodes in order to let the system know which barcodes have already been printed from another system

  * Implement new view/ form with one file input field and submit button (barcodes#import)
  * The uploaded excel contains the barcodes in the first column, one barcode per row. Skip the first row.
  * In case upload is missing or is not an excel file, highlight input and redirect to upload page
  * In case of any invalid barcodes (invalid ean8 or duplicate)
    * don't store anything in the database
    * display the error "Invalid barcodes found: xxx, xxx,  xxx, ..." (ex: "Invalid barcodes found: 4545455, 0235433.")
  * In case of only valid barcodes
    * redirect to root page
    * display notice "xxx barcodes imported!" (ex: "5 barcodes imported!")
  * The barcodes should have source "excel" in the database

#### 2. As a user I want to upload the raw excel we get from our partner in order to have less manual work for preparation
  * Enhance existing barcode upload from task one
  * If the barcode has more than 8 digits it's invalid
  * If the barcode has less than 8 digits
    * left pad with zeros to 8 digits and check if the barcode is a valid EAN8
      * if it's not a valid EAN8
        * left pad to only to 7 digits,
        * calculate the checksum and append it to the right

#### 3. As a user I want to generate a certain amount of barcodes manually in order to give the programmer some work
  * Add button "Generate new barcodes"
  * Clicking on the button
    * generates a random number (1 - 100) of new barcodes
    * displays a notice "xxx barcodes generated"
    * redirects to root
  * The generation should start with the lowest possible number and respect any existing barcodes in the database
    * example, dbs contains: 00000017, 000000024, 00000055
    * after generating 3 new barcodes, dbs contains: 00000017, 000000024, 00000031 (new), 00000048 (new), 00000055, 00000062 (new)
  * The barcodes should have source "generator" in the database


# Hints / rules

* Use can use the excel files in the doc folder for testing
* Use gems already present in Gemfile (ean8, rubyXL)
* See doc/code_snippets.rb for some hints (no need to use it)
* Use form and service objects where it makes sense
* Code should be clean, well structured and self-documentating (proper method naming, etc.)
* Write down in keywords what problems/ difficulties you faced
* Write down in keywords what could be improved/ refactored in your code
* Bonus points for: write some unit and controller specs for your tasks

Good luck and happy coding! :)

keywords:
* Problems faced:
  * Docker: I'm currently on an ubuntu machine (but I traditionally use mac and will get a new mac upon hire to avoid switching keyboards between work and personal), which lead to some issues. Docker also makes debugging more tedious at times. I had some issues with docker-pry not being able to connect to the server, which made it challenging to figure out the file upload/rubyXL interactions.
  * Understanding the task: there's some ambiguity built into the assignment, and it took several close readings of the README as well as reading through the EAN8 documentation to better understand how EAN8 works.
  * Setting up tests: I don't set up rspec very often so there are always little issues I encounter that need to be debugged. For example, I realized the tests were using the dev database and had to change the rails helper to fix the issue.
  * Error handling: error handling for the file upload required some care because there are multiple ways it can fail.
* Areas for improvement:
  * Unit tests: I would generally prefer unit tests for service objects, but request specs are more valuable and in this case the unit tests would be completely redundant, so I skipped them.
  * More nuanced feedback: the feedback to the user does not indicate what the problems are with uploaded codes and also doesn't tell the user how many records were created when there are any failures in the upload.
  * Separation of concerns: I think you could make an argument for breaking up the barcode import service into separate file processing and code processing. This would allow for unit tests instead of fixture tests.
  * Navigation: it would be nice for the import page to have a link to navigate to the home or barcode pages