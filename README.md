---
Team: Bengler
Stack: Ruby

---
<!--(Maintained Duplo labels above. Read more on http://info.api.no/handbook/guidelines/GitHub-guidelines.html)-->

<!--(Maintained Duplo labels above. Read more on http://info.api.no/handbook/guidelines/GitHub-guidelines.html)-->

# Papertime Client Gem


## Usage


### Gemfile inclusion:

```
gem 'papertime_client', '~> 0.0.3', :git => 'git@github.com:origo/papertime_client.git'
```


### Methods

```
pc = PapertimeClient.new(paper_time_server_url)
```


#### get_publication_dates(params)
Get all viable publication dates after today given a required processing time 
of :production_days for the publication identified with the :domain
e.g. client.get_publication_dates(:domain => 'op.no', :production_days => 6)
returns a hash with the single key 'issues' which points to an array of Date-objects

#### get_deadline_date(params)
Compute the deadline for publication on :publication_date given a processing time
of :production_days for the publication identified with the :domain
e.g. client.get_deadline_date(:domain => 'amta.no', :publication_date => Date.today+9, :production_days => 4)
returns the Date

#### get_nearest_publication_date
Compute the nearest possible publication date from a :domain and :desired_publication_date
e.g. client.get_nearest_publication_date(:domain => 'amta.no', :desired_publication_date => Date.today+9)
returns the Date

#### find_publication_by_domain(domain)
Finds publication by domain name (both with and without www)

#### find_publications_by_lat_lon(lat,lon)
Finds publications by lat/lon (float)

#### coverage_areas
Returns all coverage areas in the database as GeoJSON.


## Development


### Build and install:

```
gem build papertime_client.gemspec
gem install papertime_client-0.0.1.gem
```

### Test:

```
bundle install
rspec spec
```
