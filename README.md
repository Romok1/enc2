# NCFA

The Node version for this project (last known by checking staging server) is `12.18.3`. I do recommend using NVM to manage your Node versions and ensuring that you are using the correct Node version the project was initially developed under.

I have a script maintained [here](https://gist.github.com/defaye/58921f409536948b6b7fa1e3ea777303). 

Use Node v12.18.3

```
nvm install 12.18.3
nvm use 12.18.3
```

If `.nvmrc` is present in the project (not at the time of writing)(with contents e.g. `12.18.3`) you could then do `nvm use` to pick up the version for the project rather than figure it out yourself.


This project uses a `config/credentials.yml.enc` file. This is a Rails 5.1-2 change from secrets.yml. This requires a key specified in a file that does not come with the repo that you must create e.g. `touch config/master.key`. You can acquire the key from the shared LastPass under `NCFA Encore Project Development Environment`.

```
echo "GET_CREDENTIALS_KEY_FROM_LASTPASS" > config/master.key
```
Ensure that your `~/.profile` (or related) home environment file has an `EDITOR` specified e.g. `export EDITOR='nano'` in order to use the `bin/rails credentials:edit` command once you have the master key.


Yarn is installed with npm e.g. `npm install -g yarn`.
```
yarn install
```

Always check that you are using the right Ruby version specified in `.ruby-version`. In rbenv, the command `rbenv version` should list the version. Otherwise compare:

```
cat .ruby-version
ruby -v # do not proceed if the Ruby version is not the same
```

Check the version of bundler. E.g. `awk "/BUNDLED WITH/{getline; print}" Gemfile.lock`
It's specified at the bottom of the `Gemfile.lock` - at the time of writing this is `v1.17.3`.

```
gem install bundler -v 1.17.3
bundle _1.17.3_ install
```

Finally:

```
rails db:create db:migrate
rails s
```

**We are not ready yet - don't test localhost:3000**

If you have issues creating the DB, it may be that your user isn't set up with a PostgreSQL role. You can resolve this with e.g. `sudo -u postgres createuser "$USER" --no-password --superuser` -- this assumes you have no password authentication setup. You will need to edit your `pg_hba.conf` for that e.g. `sudo sed -i -E "s/^(local\s+all\s+all\s+)md5$/\1trust/" /etc/postgresql/10/main/pg_hba.conf; sudo service postgresql restart`

The script above updates one of the authentication rules for local from md5 to trust so you don't need to authenticate in this particular case. If you still struggle to get beyond this, you should update other lines for local and host and restart the PostgreSQL service.

In a separate window...


```
nvm use 12.18.3 # sanity check / if .nvmrc is present in the project dir - you could just do nvm use
./bin/webpack-dev-server /or you can use `yarn dev` as a shortcut
```

Also in separate windows run `redis-server` and `bundle exec sidekiq`

If you don't have redis installed, you can install with brew `brew install redis`. 

Make sure the redis service is running. E.g. With brew you can run `brew services start redis`

**We are not ready yet - don't test localhost:3000**

Use ./bin/webpack-dev-server as it has the dependencies loaded from `package.json` that includes Webpack.

**Keep reading**

## Seeding the DB

Now seed the database (this could take a few minutes):

```
rails c
Importer.import_all
```

Browse to:
```
http://localhost:3000/admin
```

The username and password is specified in the credentials e.g. `rails credentials:show`. Development credentials may be `username: username, password: password`.

When you first start the site with an empty db, you'll get a `Site not found` error. This is resolved by creating a new site with the label and identifier: `ncfa` (lowercase). In development, the seeding will happen automatically once this is done.

For more info on seeding the db...

`RAILS_ENV=staging bundle exec rails comfy:cms_seeds:import[ncfa,ncfa]`

https://github.com/comfy/comfortable-mexican-sofa/wiki/Docs:-CMS-Seeds

## A note on CMS use

Comfortable Mexican Sofa can be a bit tricky to get your head around, especially considering it can be used in many different ways due to its flexibility. In its simplist form; comfy is made up of one *site* (ncfa), several layouts (similar to rails layouts), and many pages.

Instead of putting all the design in comfy, I have opted for the use of reusable partials, kept mainly in the rails view (`views/cms/shared/_hero.html` for example).

Inside these partials, you can call attributes of the page like so (shown here grabbing the label of a page for a title, and a custom description field, which we'll get to later on)...

```
<h1><%= @cms_page.label %></h1>
<h3><%= cms_fragment_content("description", @cms_page) %></h3>
```
_views/cms/shared/hero.html.erb_

```
{{ cms:partial "cms/shared/hero" }}
{{ cms:text description, render: false }}
{{ cms:wysiwyg content }}
```
_layout in comfy being used by the page in question_

By using a combination of `{{cms:text description, render: false}}` and `cms_fragment_content("description", @cms_page)`, we can create attributes in the cms which aren't rendered out, and can be picked up to render elsewhere in a partial. This means we don't have to store everything in comfy, just declare the fields and pull in the relevant partials.
