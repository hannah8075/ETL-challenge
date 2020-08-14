# ETL-challenge
Author: Hannah Wang, Amber Pizzo

## Project
This project pulls adoptable dogs data from PetFinder and Dogtime and loads the data in a relational database.

## Data Sources
Petfinder API
Dogtime.com

## Libraries Used
BeautifulSoup
requests
pymongo
splinter
time
json
pandas
pprint
sqlalchemy

## Extract
### Petfinder API
To obtain the data, you will first have to use the Petfinder API (Documentation: https://www.petfinder.com/developers/v2/docs/#api-calls).

After obtaining API Key (CLIENT-ID) and secret(CLIENT-KEY), this will be used in the terminal command below to obtain a token. Remember to replace {CLIENT-ID} and {CLIENT-SECRET}, including the {}.

curl -d "grant_type=client_credentials&client_id={CLIENT-ID}&client_secret={CLIENT-SECRET}" https://api.petfinder.com/v2/oauth2/token

Place the access token in your GET requests. Although not specified in Petfinder's documentation, you will want to use " " around the API request if using more than one parameters if you want to output the result. The results are returned as a JSON file, which can be outputted as a json using command -o (per curl documentation https://curl.haxx.se/docs/manpage.html#-o)

curl -H "Authorization: Bearer eyJ0....." "https://api.petfinder.com/v2/animals?type=dog&page=5&limit=100" -o "dogs1.json"

Given that the maximum number of results that can be called per page is 100, we made five API calls to obtain 500 results. 

The five JSON files are saved in the data folder so the steps outlined above are optional (unless you want to pull new or more data). 

### Scraping Dogtime.com
To retrieve data about dog characteristics, https://dogtime.com/dog-breeds was scraped using BeautifulSoup. This website was chosen because it contains information about a wide variety of dog breeds.

First, the website was scraped for all dog breeds listed, as well as the url to find details regarding each individual dog.

Next, we wanted to present specific information about each dog breed, including adaptability, all around friendliness, health and grooming needs, trainability, and physical needs (using a star rating of 1-5). However, there are 377 dog breeds listed on the site. In order to get information for each dog breed, our code would need to visit each individual dog breed browser. Based on resource constraints, we decided to only provide these additional details about the dog breeds found from our API call section. In order to search for only these specific dog breeds, we utilized the csv output from the Petfinder_data_cleaning jupyter notebook. However, in an ideal world, with unlimited resources, we would scrape these additional breed characteristics for every dog breed listed on the site. 

After finalizing the list of dog breeds to find additional characteristics for, BeautifulSoup was again used to scrape the characteristic star rating for adaptability, all around friendliness, health and grooming needs, trainability, and physical needs. Splinter was used to navigate to each individual dog breed url using a for loop. Please note: based on the number of urls to be visited, this process will take several minutes. This will depend on the resources available for your system.

It is also important to note that, when Splinter is being used, the path to the chromedriver must be specified. The syntax will be dependent on your operating system. We have included the syntax for both Windows and Mac users. When running the code, please comment out the syntax that is not applicable to your system.

## Transform
To transform the petfinder data (which is in five json files in the data folder), load the json into Jupyter Notebook. We created a function called petfinder() that inputs the json file number(1-5) to extract the data we want (id, name, primary breed, city, and state) as lists of dictionaries. These five lists are then concatenated and made into a dataframe using Pandas. 

In some rows of data, there were two breeds in the same field separated by a '/' (i.e. two breeds were listed as the primary breed). We used a split function to remove the secondary breed (i.e. kept the first listed breed) and deleted the secondary breed column. We also used the value_counts() function to check for duplicate IDs and found five duplicates. A function was written to create a list of indices of duplicate pet IDs so that we can drop these rows by their indices.

The dog breed and url information was placed into its own dataframe. The names of the columns for the dataframe were updated, but no special filtering or cleanup was needed for this step.

The next step was creating a dataframe for each breed and the additional characteristics. The data that was extracted from the dogtime webpage regarding the rating (counted in stars ranging from 1-5) was the entire \<div> tag where the rating was provided. This was because the rating was not set as text in the html file, but rather set by what class was used for the \<div> tag (example: \<div class="characteristic-star-block">\<div class="star star-2">\</div>\</div>). Once this data was loaded into the dataframe, the \<div> tag information was replaced with only the number of stars that was given in the class (as an integer). The dataframe columns were renamed to reflect the characteristics listed.

## Load
### Rationale
The data was loaded into a relational database (postgreSQL) because of the relationship that exist between the tables. The table schema is stored in the schema.sql file, which provides SQL code for creating the tables(with table names: petfinder_dogs, dog_links, and dog_traits). The primary key for the petdfinder_dogs table was pet_id, but this table contained breed information, which is a primary key for the dog_links and dog_traits table. Using a relational database allows a user to join the table to conduct data analysis (a query.sql file is created to provide some sample queries).

### Loading data
Create a database called 'petfinder_db'(or choose your own naming convention, but remember to assign this to the variable database_name). Run the schema.sql to create the tables in the database.

Since we scraped all 377 dog breeds and their urls, but only extracted additional characteristics for 56 dog breeds, we decided to create 2 separate tables : dog_links (which includes the breed and url for all dog breeds listed on the dogtime webpage) and dog_traits (which includes the breed and star ratings for adaptability, all around friendliness, health and grooming needs, trainability, and physical needs).

Code is provided to load all data into postgreSQL. However, we have also provided the csv outputs of the dataframes in the data folder if needed.

## Use Case
By storing data on adoptable dogs and their characteristics (based on breed), users will be able to determine what type of dog might be a good match for their family. The dog_links table also provides a link to a page with more information to help the user learn more about each dog breed. 


![Alt Text](https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/48752074/2/?bust=1597187863\u0026width=100)