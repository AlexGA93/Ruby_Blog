# Basic commands to understand Ruby on Rails



## Index

- [Installation](#Installing-the-next-technologies)
- [1. New Project](#1-Create-a-new-Project)
- [2. Hello, Rails!](#2-create-a-route-to-render-a-page-saying-hello-rails)
    - [2.1 Adding a Route](#21-adding-a-route)
    - [2.2 Controller + Action](#22-adding-a-controller-and-action)
    - [2.3 View](#23-creating-our-view)
- [How to Init Ruby Server](#to-init-server)
- [3. Setting Home Page](#3-setting-the-application-home-page)
- [4. MVC Model](#4-mvc-model)
    - [4.1 Generating a Model 'Article'](#41-generating-a-model-article)
    - [4.2 Database Migration](#42-database-migrations)
    - [4.3 Interact with DB](#43-using-a-model-to-interact-with-the-database)
    - [4.4 List of Articles](#44-showing-a-list-of-articles)
- [5. CRUD](#5-crud-create-read-update-delete)

---

## Installing the next technologies
- Node.js

We install nvm (Node Version Manager) to install latest LTS version:
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm --version
npm --version
```

### NVM Commands
See  list all available node.js versions:
```
nvm ls-remote
```
Install latest LTS version of node:
```
nvm install --lts
node --version
```

- Yarn
```
npm install --global yarn
```
- SQLite3
```
sudo apt update
sudo apt install sqlite3
sqlite3 --version
```
- Ruby
```
sudo apt-get install ruby-full
sudo apt install gem

gem -v

sudo gem update --system
apt-get install libsqlite3-dev

dpkg -r --force-depends  ruby-thor
gem install thor

```

## Warning: Make sure that your programming folder has full permissions
---
## 1. Create a new Project

we'll create a project called 'blog'
```
sudo rails new blog
```
If There is a problem or any error with Gemfile, install ruby-bundler:

```
cd blog/
```
---
## 2. Create a Route to render a page saying "Hello, Rails!"

We'll need the next components:

    - 2.1 A route
    - 2.2 A controller + action
    - 2.3 A view


### 2.1 Adding a Route 
Adding new route on route's file **config/routes.rb**

```
Rails.application.routes.draw do
  get "/articles", to: "articles#index"
end
```

### 2.2 Adding a Controller and Action
We've created a route but we need to map the GET request into a 'index' action of a controller named 'ArticlesController'. To create them we have to put this command:

Note: ```--skip-routes``` option because we already have an appropiate route.

 ```
 bin/rails generate controller Articles index --skip-routes

 ```
Controller created at:
```
/blog/app/controllers/articles_controller.rb
```
```
class ArticlesController < ApplicationController
  def index
  end
end

```
### 2.3 Creating our View

Let's open 'app/views/articles/index.html.erb' replacing the content with:
 ```
 <h1>Hello, Rails!</h1>
 ```

 If you previously stopped the web server to run the controller generator, restart it with bin/rails server. Now visit http://localhost:3000/articles, and see our text displayed!

  ### To init server:
 ```
 bin/rails server
 ```

---
 ## 3. Setting the Application Home Page

 If we want to designate a route as home page at the main url, confirm that the root is also mapped ti the index action of controller created (in this case at **/blog/config/routes.rb**).

 ```
 Rails.application.routes.draw do
  root "articles#index" #<-----

  get "/articles", to: "articles#index"
end

 ```
 ---

 ## 4. MVC Model
  
 ### 4.1 Generating a Model 'Article'
 A model is a Ruby class used to represent data. Models can interact with the app's database through a feature called 'Active Record'.

 ```
 bin/rails generate model Article title:string body:text

 ```
### WARNING:
 Model names are singular, because an instantiated model represents a single data record. To help remember this convention, think of how you would call the model's constructor: we want to write Article.new(...), not Articles.new(...).

It'll create the next instances:
```
invoke  active_record
create    db/migrate/<timestamp>_create_articles.rb
create    app/models/article.rb
invoke    test_unit
create      test/models/article_test.rb
create      test/fixtures/articles.yml
```
### 4.2 Database MIgrations
Migrations are used to alter the structure of an app's database. In Rails, migrations are written in Ruby so that the can be database-agnostic. 

On **/blog/db/migrate/20210727094918_create_articles.rb**:
```
class CreateArticles < ActiveRecord::Migration[6.1]
  def change

    # how articles table show be constructed
    create_table :articles do |t| 

      # columns defined added by generator in command above
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end

```

To run our migration we have to put this command:
```
bin/rails db:migrate
```
Now we can interact with the table using our model.

### 4.3 Using a Model to Interact with the Database

Using a feature named 'console':
```
bin/rails console
```
and we can set upo a new article object:
```
article = Article.new(
    title: "Hello Rails", 
    body: "I am on Rails!"
)
```
It's not saved yet, so:
```
article.save
```
```
irb(main):002:0> article.save
  TRANSACTION (0.1ms)  begin transaction
  Article Create (0.6ms)  INSERT INTO "articles" ("title", "body", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "Hello Rails"], ["body", "I am on Rails!"], ["created_at", "2021-07-27 10:28:48.975212"], ["updated_at", "2021-07-27 10:28:48.975212"]]
  TRANSACTION (11.1ms)  commit transaction
=> true
```
### - 4.3.1 Find an element on the model
When we want to fetch this article from the database, we can call find on the model and pass the id as an argument:

```
Article.all
#or
Article.find(1) #being 1 an id
```

### 4.4 Showing a List of Articles

First of all we need to fetch all articles from the database:
**app/controllers/articles_controller.rb**
```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all # <-----
  end
end

```
And reference @articles in **app/views/articles/index.html.erb**
```
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= article.title %>
    </li>
  <% end %>
</ul>

```
---
## 5. CRUD (Create, Read, Update, Delete)

### 5.1 Showing a Single Article [READ]
We want a new view that shows the title and body of a single article

- Adding a new route that maps to a new controller action at **config/routes.rb**

```
Rails.application.routes.draw do
  #setting /articles home page
  root "articles#index"
  
  # We  want a route for '/articles'
  get "/articles", to: "articles#index"
  ######################################################
  # New route to show title and body of a single article
  get "/articles/:id", to: "articles#show"
  ######################################################
end
```
A route parameter captures a segment of the request's path: :id.

THis designatesa route parameter, capturing a segment os the request's path into 'params'. For example: 
- "GET http://localhost:3000/articles/1"
1 would be captured as the value :id, accesible as params[:id] in the show action of 'ArticlesController'

**app/controllers/articles_controller.rb**
```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end
end
```

Now we have to crateour html to show the content like app/articles/index.html.erb

**app/views/articles/show.html.erb**
```
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>
```

Visible at  http://localhost:3000/articles/1

Rails provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. So before we proceed to the "C", "U", and "D" sections, let's replace the two get routes in config/routes.rb with resources:
```
Rails.application.routes.draw do
  root "articles#index"

  resources :articles   #<--
end
```
```
$ bin/rails routes
```
| Prefix Verb      |  URI Pattern    |  
|------------------|-----------------|            
| controller#Action|                 |
| articles#index   |root GET        /|
| articles#index   |articles GET    /articles(.:format)|
| articles#new     |new_article GET    /articles/new(.:format)|
| articles#show    |article GET    /articles/:id(.:format)|
|articles#create   |POST   /articles(.:format)|
|articles#edit     |edit_article GET    /articles/:id/edit(.:format)|
|articles#update   |PATCH  /articles/:id(.:format)|
|articles#destroy  |DELETE /articles/:id(.:format)|


However, we will take this one step further by using the link_to helper. The link_to helper renders a link with its first argument as the link's text and its second argument as the link's destination. If we pass a model object as the second argument, link_to will call the appropriate path helper to convert the object to a path. 

```
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>

```
### 5.2 Creating a new Article [CREATE]

At this point we have every function created at articles_controller.rb to operate with each request type

---
Rails provides a feature called **validations** to help us deal with invalid user input. 

Validations are rules that are checked before a model object is saved. If any of the checks fail, the save will be aborted, and appropriate error messages will be added to the errors attribute of the model object.

Let's add some validations to our model in **app/models/article.rb**:

```
class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```
- The first validation declares that a title value must be present. Because title is a string, this means that the title value must contain at least one non-whitespace character.

- The second validation declares that a body value must also be present. Additionally, it declares that the body value must be at least 10 characters long.

At this point we've a newarticle page with a form to enter a new post with display error logic.

```
<h1>New Article</h1>

<!-- Declare a form -->
<%= form_with model: @article do |form| %>

    <div>
        <%= form.label :title %> <!-- Form title label-->
        <br>
        <%= form.text_field :title %> <!-- Form text field -->

        <!-- Display errors -->
        <% @article.errors.full_messages_for(:title).each do |message| %>
        <div>
            <%= message %>
        </div>
        <% end %>
    </div>

  <div>
        <%= form.label :body %><br>
        <%= form.text_area :body %><br>
        <% @article.errors.full_messages_for(:body).each do |message| %>
        <div>
            <%= message %>
        </div>
        <% end %>
  </div>

  <div>
    <%= form.submit %>
  </div>
<% end %>

```

We can now create an article by visiting http://localhost:3000/articles/new. To finish up, let's link to that page from the bottom of app/views/articles/index.html.erb:

```
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>

<%= link_to "New Article", new_article_path %>

```
### 5.3 Updating an Article [Update]

We've covered the 'Create' and 'Read' of CRUD. Now let's move on to the 'Update' one.
  - The user requests a form to edit the data.
  - User submits the form.
  - Resource updqated (if there is not any errors).

These steps are conventionally handled by a controller's edit and update actions on **app/controllers/articles_controller.rb**, below **create** action:

```
def edit
    @article = Article.find(params[:id])
  end
```
'edit' action fetches the article from our database and stores it in @article so that it can be used when building a form


```
def update
  @article = Article.find(params[:id])

  if @article.update(article_params)

    redirect_to @article

  else

    render :edit

  end
end
```
'update' action re-fetches the article from the database and attemps to update it with the submited form data filtered by 'article_params'.

If no validations fail and the update is successful, the action redirects the browser to the article's page. Else, the action redisplays the form, with error messages, by rendering **app/views/articles/edit.html.erb**.

Because our edit form will look the same as our new form, we're going to factor it out into a shared view called 'partial'. Let's create **app/views/articles/_form.html.erb** with the following contents:

```
<%= form_with model: article do |form| %>
  <div>
    <%= form.label :title %><br>
    <%= form.text_field :title %>
    <% article.errors.full_messages_for(:title).each do |message| %>
      <div><%= message %></div>
    <% end %>
  </div>

  <div>
    <%= form.label :body %><br>
    <%= form.text_area :body %><br>
    <% article.errors.full_messages_for(:body).each do |message| %>
      <div><%= message %></div>
    <% end %>
  </div>

  <div>
    <%= form.submit %>
  </div>
<% end %>
```

The above code is the same as our form in app/views/articles/new.html.erb, except that all occurrences of @article have been replaced with article. Because partials are shared code, it is best practice that they do not depend on specific instance variables set by a controller action. 

---
### 5.3.1 Updating Views to use Partial via Render

- Let's update **new.html.erb** to use partial via render.
  ```
  <h1>New Article</h1>

  <%= render "form", article: @article %>
  ```

- And now apply the same logic to a new component **app/views/articles/edit.html.erb**
  ```
  <h1>Edit Article</h1>

  <%= render "form", article: @article %>
  ```
- Finally, we can update **app/views/articles/show.html.erb** to display the same logic:
  ```
  <h1><%= @article.title %></h1>

  <p><%= @article.body %></p>

  <ul>
    <li><%= link_to "Edit", edit_article_path(@article) %></li>
  </ul>
  ```
### 5.4 Deleting an Article [Delete]

We only need to know the steps to follow:

- Find article from database
- Remove the article
- Redirect to main page

We can now add this function into our article's controller
```
def destroy
  @article = Article.find(params[:id])
  @article.destroy

  redirect_to root_path
end
```

---
## 6. Dealing with Comments

### 6.1 Comments Model

We're going to add to our project comments in every article. For that , we'll need to create a second model, running the following command at our terminal:

```
bin/rails generate model Comment commenter:string body:text article:references
```
This will generate four files:

| File | Purpose |
|------|---------|
| db/migrate/20140120201010_create_comments.rb | Migration to create the comments table in your database (your name will include a different timestamp) |
| app/models/comment.rb       | The Comment model |
| test/models/comment_test.rb | Testing harness for the comment model |
| test/fixtures/comments.yml  | Sample comments for use in testing |

```
class Comment < ApplicationRecord
  belongs_to :article
end
```

```
class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
```

And we'll migrate the database

```
dpkg -r --force-depends  ruby-thor
gem install thor

bin/rails db:migrate
```

Modify our article model to have them:
```
class Article < ApplicationRecord
  has_many :comments, dependent: :delete_all

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```

And our routes script: 
```
Rails.application.routes.draw do
  root "articles#index"

  resources :articles do
    resources :comments
  end
end
```

### 6.1 Comments Controller

```
bin/rails generate controller Comments
```

And edit our 'show' file:
```
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>

<ul>
  <li><%= link_to "Edit", edit_article_path(@article) %></li>
  <li><%= link_to "Destroy", article_path(@article),
                  method: :delete,
                  data: { confirm: "Are you sure?" } %></li>
</ul>

<h2>Add a comment:</h2>
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>

```

Let's wire up the create in app/controllers/comments_controller.rb:
```
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
```

## 7. Refactoring
Now that we have articles and comments working, take a look at the app/views/articles/show.html.erb template. It is getting long and awkward. We can use partials to clean it up.

### 7.1 Rendering Partial Collections
First, we will make a comment partial to extract showing all the comments for the article. Create the file app/views/comments/_comment.html.erb.Then you can change app/views/articles/show.html.erb to look like the following:

```
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>

<ul>
  <li><%= link_to "Edit", edit_article_path(@article) %></li>
  <li><%= link_to "Destroy", article_path(@article),
                  method: :delete,
                  data: { confirm: "Are you sure?" } %></li>
</ul>

<h2>Comments</h2>
<%= render @article.comments %>

<h2>Add a comment:</h2>
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>

```
### 7.2 Rendering Partial Form

We're going to make a couple of changes.

- **app/views/comments/_form.html.erb**
```
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>
```
### 7.3 Using Concerns
Concerns are a way to make large controllers or models easier to understand and manage. This also has the advantage of reusability when multiple models (or controllers) share the same concerns. 

Concerns are implemented using modules that contain methods representing a well-defined slice of the functionality that a model or controller is responsible for. In other languages, modules are often known as mixins.

You can use concerns in your controller or model the same way you would use any module. When you first created your app with rails new blog, two folders were created within app/ along with the rest:

- app/controllers/concerns
- app/models/concerns

A given blog article might have various statuses:
   - For instance, it might be visible to everyone (i.e. public), or only visible to the author (i.e. private). 
   - It may also be hidden to all but still retrievable (i.e. archived). 
   - Comments may similarly be hidden or visible. 

This could be represented using a status column in each model.

Within the article model, after running a migration to add a status column, you might add:
```
class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
end

```
and in the Comment model:
```
class Comment < ApplicationRecord
  belongs_to :article

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
end

```
Then, in our index action template (app/views/articles/index.html.erb) we would use the archived? method to avoid displaying any article that is archived:

```
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <% unless article.archived? %>
      <li>
        <%= link_to article.title, article %>
      </li>
    <% end %>
  <% end %>
</ul>

<%= link_to "New Article", new_article_path %>
```
However, if you look again at our models now, you can see that the logic is duplicated. If in the future we increase the functionality of our blog - to include private messages, for instance - we might find ourselves duplicating the logic yet again. This is where concerns come in handy.

A concern is only responsible for a focused subset of the model's responsibility; the methods in our concern will all be related to the visibility of a model. Let's call our new concern (module) Visible. We can create a new file inside app/models/concerns called visible.rb , and store all of the status methods that were duplicated in the models.

app/models/concerns/visible.rb
```
module Visible
  def archived?
    status == 'archived'
  end
end
```

We can add our status validation to the concern, but this is slightly more complex as validations are methods called at the class level. The ActiveSupport::Concern (API Guide) gives us a simpler way to include them:

```
module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = ['public', 'private', 'archived']

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  def archived?
    status == 'archived'
  end
end
```

Now, we can remove the duplicated logic from each model and instead include our new Visible module:
In app/models/article.rb:

```
class Article < ApplicationRecord
  include Visible
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```

and in app/models/comment.rb

```
class Comment < ApplicationRecord
  include Visible
  belongs_to :article
end
```

Class methods can also be added to concerns. If we want a count of public articles or comments to display on our main page, we might add a class method to Visible as follows:

```
module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = ['public', 'private', 'archived']

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  class_methods do
    def public_count
      where(status: 'public').count
    end
  end

  def archived?
    status == 'archived'
  end
end
```
Then in the view, you can call it like any class method:

```
<h1>Articles</h1>

Our blog has <%= Article.public_count %> articles and counting!

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>

<%= link_to "New Article", new_article_path %>
```

There are a few more steps to be carried out before our application works with the addition of status column. First, let's run the following migrations to add status to Articles and Comments:

```
bin/rails generate migration AddStatusToArticles status:string
bin/rails generate migration AddStatusToComments status:string
```

We also have to permit the :status key as part of the strong parameter, in app/controllers/articles_controller.rb:
```
private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end

```
and in app/controllers/comments_controller.rb:
```
private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :status)
    end

```

To finish up, we will add a select box to the forms, and let the user select the status when they create a new article or post a new comment. We can also specify the default status as public. In app/views/articles/_form.html.erb, we can add:

```
<div>
  <%= form.label :status %><br>
  <%= form.select :status, ['public', 'private', 'archived'], selected: 'public' %>
</div>
```

## 8. Deleting Comments

So first, let's add the delete link in the app/views/comments/_comment.html.erb partial:

```
<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>

<p>
  <%= link_to 'Destroy Comment', [comment.article, comment],
              method: :delete,
              data: { confirm: "Are you sure?" } %>
</p>

```

Clicking this new "Destroy Comment" link will fire off a DELETE
/articles/:article_id/comments/:id to our CommentsController, which can then use this to find the comment we want to delete, so let's add a destroy action to our controller (app/controllers/comments_controller.rb):

```
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end

```
If you delete an article, its associated comments will also need to be deleted, otherwise they would simply occupy space in the database. Rails allows you to use the dependent option of an association to achieve this. Modify the Article model, app/models/article.rb, as follows:

```
class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```
