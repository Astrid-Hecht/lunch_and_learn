<div id="header" align="center">

<h1 align="center"> Lunch and Learn v1</h1>
<h2 align="center"> Mod 3 BE Final Project </h2>

</div>

<br/>

## Table of Contents
---
<table style="
           margin-left: auto;
           margin-right: auto;
           width: 50%;
           text-align: center;
           padding: 10px;
           padding-top: 15px;
           border-radius: 4px;
           background-color: rgb(21, 21, 21);">
<tr><td style="padding-top: 17px;"> 

[Project Overview](#project-overview) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Setup](#setup) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Learning Goals](#learning-goals) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Planning Documents](#planning-documents) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Endpoints and Illustrations](#illustrations) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Technologies and Tools](#technologies-and-tools) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Possible future features or improvements](#possible-future-features-or-improvements) 
</td></tr>
<tr><td style="padding-top: 17px;"> 

[Contributors](#contributors) 
</td></tr>

</table>
<br/>

## Project Overview
---

  This repo was a final project at the Turing School of Software and Design that was intended to demonstrate depth of knowledge on principles like SOA, API consumption, API exposure, and more. 
  
  Specifically, this is a back end service of a proposed project built to given imaginary front end specifications and endpoints. Its purpose is to allow a user to search an external recipe database for recipes that come from a user selected country, allow the user to favorite those recipes, and display educational pictures and a video to watch as the user eats the recipe they sourced from this app. It draws from a total of 4 APIs (listed below) and exposes 5 endpoints that use the consumed APIs data, as well as local data, to fulfill the intended functionality. 
  
  This app is fully tested and covers many possible edge cases.


<br/>

## Setup
---

1. Fork and clone this repository.
2. Open in your editor of choice.
3. Run `bundle install`
4. Run `rails db:{create,migrate}` to setup the database
5. Run `bundle exec install figaro`, copy and paste the following into your new config/application.yml file. Replace the links to the API registration with the relevant keys (restcountries API doesn't need a key):
<br/>
<div style="display: block; 
           margin-left: auto;
           margin-right: auto;
           margin-bottom: 10px;
           width: 70%;
           padding: 10px;
           padding-top: 15px;
           border-radius: 4px;
           background-color: rgb(21, 21, 21);">

edamam_recipe_id: [Edamam Recipes API](https://developer.edamam.com/edamam-recipe-api) \
edamam_recipe_key: [Edamam Recipes API](https://developer.edamam.com/edamam-recipe-api) \
youtube_data_key: [YouTube Data API](https://developers.google.com/youtube/v3/docs) \
unsplash_access_key: [Unsplash API](https://unsplash.com/documentation)
</div>

6. To run this server, run `rails s` in the terminal and rails will start the development server. To stop the local server, use command `Control + C`.
7. Open a browser window and go to http://localhost:3000 to view the endpoints given above.


<br/>

## Learning Goals
---

- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Expose an API for CRUD functionality
- Determine completion criteria based on the needs of other developers
- Test both API consumption and exposure, making use of at least one mocking tool (VCR, Webmock, etc).

<br/>

## Planning Documents
---

- [Planned API Implementation Spreadsheet](https://docs.google.com/spreadsheets/d/1-pY07Wr4nqspK1gy-gvMFhBLcfUIrjz3d2NkboAxBiU/edit?usp=sharing)
- [Assigned Project Specifications](https://backend.turing.edu/module3/projects/lunch_and_learn/requirements)

<br/>

## Endpoints and Illustrations
---
  This section will map out the all of this app's endpoints, their response model, and match them with theoretical front end wireframes that each were built for.

<br/>

### 1. Get Recipes for a particular country
#### Wireframe
<img width="762" alt="Get recipes by country wireframes" src="https://backend.turing.edu/module3/projects/lunch_and_learn/images/recipes-show.png">

<br/>

#### Request Example
```
GET /api/v1/recipes?country=thailand
Content-Type: application/json
Accept: application/json
```

<br/>

#### Response Model Example
```
{
    "data": [
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)",
                "url": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com..."
            }
        },
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Sriracha",
                "url": "http://www.jamieoliver.com/recipes/vegetables-recipes/sriracha/",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/."
            }
        },
        {...},
        {...},
        {...},
        {etc},
    ]
}
```

<br/>

#### Notes
- If the country parameter is missing, the app will randomly generate a country and render results from there instead.
- If the country doesn't exist, or the name isn't correctly matched, renders an error.
- If the country is an empty string or has no recipes, renders an empty array.
- The country API currently can generate special characters that can break the processing. If this happens, try again with a simplified name.
---
<br/>

### 2. Get Recipes for a particular country

#### Wireframe
<img width="762" alt="Get learning resource by country wireframe" src="https://backend.turing.edu/module3/projects/lunch_and_learn/images/country-show.png">

<br/>

#### Request Example
```
GET /api/v1/learning_resources?country=laos
Content-Type: application/json
Accept: application/json
```
<br/>

#### Response Model Example
```
{
    "data": {
        "id": null,
        "type": "learning_resource",
        "attributes": {
            "country": "laos",
            "video": {
                "title": "A Super Quick History of Laos",
                "youtube_video_id": "uw8hjVqxMXw"
            },
            "images": [
                {
                    "alt_tag": "standing statue and temples landmark during daytime",
                    "url": "https://images.unsplash.com/photo-1528181304800-259b08848526?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwxfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "five brown wooden boats",
                    "url": "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwyfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "orange temples during daytime",
                    "url": "https://images.unsplash.com/photo-1563492065599-3520f775eeed?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwzfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {...},
                {...},
                {...},
                {etc},
              ]
        }
    }
}
```
<br/>

#### Notes
- This endpoint pulls videos exclusively from the "@MrHistory1" YouTube channel. The query specifies to only return embeddable videos as well, to ensure the FE has no problem displaying them.
- If no video or images are found for a given country, will return that attribute as an empty hash/array.

---
<br/>

### 3. User Registration

#### Wireframe
<img width="762" alt="Register a user wireframe" src="https://backend.turing.edu/module3/projects/lunch_and_learn/images/register-fake.png">

<br/>

#### Request Example
```
POST /api/v1/users
Content-Type: application/json
Accept: application/json

{
  "name": "Athena Dao",
  "email": "athenadao@bestgirlever.com"
}
```
<br/>

#### Response Model Example
```
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "name": "Athena Dao",
      "email": "athenadao@bestgirlever.com",
      "api_key": "jgn983hy48thw9begh98h4539h4"
    }
  }
}
```
<br/>

#### Notes
- This app uses auto-generated UUID strings as api keys for each user. They still have internal IDs, but this streamlines access through FE requests.
- If any fields are missing or the given email is already in the database, returns relevant error instead.

---
<br/>

### 4. Add favorites

#### Wireframe
<img width="762" alt="Add favorite wireframe" src="https://backend.turing.edu/module3/projects/lunch_and_learn/images/recipes-show.png">

<br/>

#### Request Example
```
POST /api/v1/favorites
Content-Type: application/json
Accept: application/json

{
    "api_key": "jgn983hy48thw9begh98h4539h4",
    "country": "thailand",
    "recipe_link": "https://www.tastingtable.com/.....",
    "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
}
```
<br/>

#### Response Model Example
```
{
    "success": "Favorite added successfully"
}
```
<br/>

#### Notes
- This wireframe is the same as 1, but the right side shows how the favorites would be implemented.
- The api_key sent in the request is used to find a user with the same key stored in the database, if no user has a matching key, or if the key(or any other field) is absent, it will return an error.
- The api_key is not stored in the favorites table in the database, favorites belong to users.

---
<br/>

### 5. Add favorites

#### Wireframe
<img width="762" alt="Get a user's favorites wireframe" src="https://backend.turing.edu/module3/projects/lunch_and_learn/images/favorites.png">

<br/>

#### Request Example
```
GET /api/v1/favorites?api_key=jgn983hy48thw9begh98h4539h4
Content-Type: application/json
Accept: application/json
```
<br/>

#### Response Model Example
```
{
    "data": [
        {
            "id": "1",
            "type": "favorite",
            "attributes": {
                "recipe_title": "Recipe: Egyptian Tomato Soup",
                "recipe_link": "http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....",
                "country": "egypt",
                "created_at": "2022-11-02T02:17:54.111Z"
            }
        },
        {
            "id": "2",
            "type": "favorite",
            "attributes": {
                "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)",
                "recipe_link": "https://www.tastingtable.com/.....",
                "country": "thailand",
                "created_at": "2022-11-07T03:44:08.917Z"
            }
        }
    ]
 }    
```
<br/>

#### Notes
- The api_key sent in the request is used to find a user with the same key stored in the database, if no user has a matching key, or if the key is absent, it will return an error.
- If matching user exists but doesn't have any favorites, data object points to an empty array:
```
{
    "data": []
}
```
<br/>

## Technologies and Tools
---

#### Built With: 
- [Rails v5.2.8](https://guides.rubyonrails.org/v5.2/)
- [Ruby 2.7.2](https://www.ruby-lang.org/en/news/2021/07/07/ruby-2-7-4-released/)

#### Tested With:
- [RSpec](https://github.com/rspec/rspec-rails)
- [PostMan](https://www.postman.com/)
- [SimplCov](https://github.com/simplecov-ruby/simplecov)
- [Pry](https://github.com/pry/pry)
- [Faker](https://github.com/faker-ruby/faker)
- [Factorybot](https://github.com/thoughtbot/factory_bot)
- [Webmock](https://github.com/bblimke/webmock)
- [VCR](https://github.com/vcr/vcr)

#### Other Gems Used: 
- [Figaro](https://github.com/laserlemon/figaro)
- [Faraday](https://github.com/lostisland/faraday)
- [JSONAPI-Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)

#### APIs Consumed:
- [Edamam Recipes API](https://developer.edamam.com/edamam-recipe-api)
- [RESTCountries API](https://restcountries.com/)
- [YouTube Data API](https://developers.google.com/youtube/v3/docs)
- [Unsplash API](https://unsplash.com/documentation)

<br/>

## Possible future features or improvements
---

- Implementing front end.
- Special character handling.
- Secure user registration and authentication with password and bcrypt.
- Delete favorite endpoint.
- Utilize caching/background workers to optimize API calls.
- Call a maps API to return info on the country's outline and location through the learning resources endpoint.
- Return demographics or other country stats through the learning resources endpoint.

<br/>

## Contributors
---

<p>Astrid Hecht</p>
<a href="https://github.com/Astrid-Hecht">GitHub</a><br>
<a href="https://www.linkedin.com/in/astrid-hecht/">LinkedIn</a>
