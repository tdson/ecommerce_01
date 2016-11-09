# ecommerce_01

Framgia DN Edu - Training Project 2

## License

All source code in this blog is available jointly under the MIT License
and the Beerware License. See [LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, after clone the repo:

First, you'll need the `database.yml` to run the app, just copy and rename `config/database.yml.example`:

```
mv config/database.yml.example config/database.yml
```

Then, the application needs gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Then, run the server

```
$ rails server
```

We’ll be resizing images using the image manipulation program ImageMagick,
which we need to install on the development environment.

```
$ sudo apt-get update
$ sudo apt-get install imagemagick --fix-missing
```
