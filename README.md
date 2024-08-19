# metaCRISPRs

## JGI Data

### JGI Query
Using JGI’s metagenome portal, set the search query filters to match the desired data. For our project, we selected projects with Gold Classification (Ecosystem Field) that were Public (Genome Field). From here, we filtered by Ecosystem: Environmental. This yielded ~20,000 projects. The query results were downloaded directly from JGI into the ```orgs.txt``` file. 

### Web Scraping
Scrape the portal names (different from project names) using the Taxon IDs in orgs.txt using ```portal_scraping.ipynb```. JGI doesn’t report the portal name in any of the project’s metadata, so we use Selenium Webdriver to navigate to the website and search the HTML for the portal name. Outputs ```portals.csv```, which contains all taxon OIDs and their corresponding portal names, for use in data download.

Metadata was also scraped from JGI’s website using metadata_scraping.ipynb. Outputs metadata.csv, which contains all metadata for each project including project name, taxon OID, etc. 

### Data Download
Use curl to request a bulk data download (via Globus):

First, authenticate the user by providing credentials:
```
curl 'https://signon.jgi.doe.gov/signon/create' --data-urlencode 'login=USER_NAME' --data-urlencode 'password=PASSWORD' -c cookies > /dev/null
```

Then, download the data (portals= should be a comma separated list of portal names)
```
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/bulk/request' -b cookies --data-urlencode 'portals=MayberrySE_Catta_2_FD,IMG_3300064906' -b cookies --data-urlencode 'filePattern=.*contigs\.fna|.*contigs\.fasta' --data-urlencode 'sendMail=true’ --data-urlencode 'globusName=USER_NAME'
```

Phylogeny files are downloaded similarly:
```
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/bulk/request' -b cookies --data-urlencode 'portals=MayberrySE_Catta_2_FD,IMG_3300064906' --data-urlencode 'filePattern=Table_8_-_.*\.taxonomic_composition\.txt' --data-urlencode 'sendMail=true' --data-urlencode 'globusName=USER_NAME'
```

To prepare files for CCTyper, use ```merge_directories.sh``` to restructure directories.

#### Filter Reads <500bp
Filter out undesired reads from contigs in all files using filter500.pl

```
perl filter500.pl
```
# MGnify and Self-Assembled Data

ADD NICK STUFF

# CRISPR-Cas System Identification and Analysis

## CCTyper
Download CCTyper by following the instructions on GitHub (https://github.com/Russel88/CRISPRCasTyper). The base install directions will only download version 1.5, so upgrade to version 1.8. After following the instructions, a conda environment, cctyper, will be created. Use ```batch_cct_parallel.sh``` to run cctyper on the downloaded files.

```
./batch_cct_parallel.sh
```

## Compile CRISPR-Cas Systems
All data is merged in ```mgnify_antarctic_merge.ipynb```. Two separate files are created: ```jgi_mgnify_AQ_crisprs.csv```, which contains all CRISPRs found in all samples, and ```all_samples.csv```, which contains the metadata for all samples.

## Sample Cluster Assignments
Coordinates are not readily available in the original JGI metadata, so location information is scraped from a branch of the original website. Use TaxonIDs scrape each of the websites using ```latlon_scraping.ipynb```. Once scraped, map them to their continent of origin using geopandas in ```continents.ipynb```. Certain locations (specifically oceans and Antarctica) are generally not available using geopandas, so the remaining locations can be determined using ```oceans.ipynb```.

KMeans clustering is used on the Latitude and Longitude of each file to obtain a geographic cluster. Once all clusters have been created, matrices are created for each that contain all of the samples in that cluster, broken down into their respective CRISPR subtype counts. Any samples that have no CRISPRs are still included with all values set to 0. Several types of matrices are created: all crisprs, high confidence crisprs, super high confidence crisprs, and US crisprs.

Once all locations have been collected, analysis on CRISPRs was performed. This includes merging the CCTyper identified CRISPR data frame with the metadata dataframe, clustering points by region (different from their continents of origin), and further data exploration. All analysis can be found in ```crisprs.ipynb```







