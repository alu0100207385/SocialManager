# Sistemas y Tecnologías Web: Proyecto SocialManager

**Integrantes**
  - Jazer Abreu Chinea (alu0100595727)
  - Javier Clemente Rodriguez Gomez (alu0100505023)
  - Aarón Socas Gaspar (alu0100207385)
  - Aarón José Vera Cerdeña (alu0100537451)


##Descripción

SocialManager es una aplicación web para gestionar redes sociales. A través de ésta se podrá postear 
directamente a las redes sociales asociadas a la aplicación.


##Aplicación en Heroku

Podemos acceder a la aplicación subida a heroku desde [AQUI](http://socialmanager.herokuapp.com/).


##Tests

[![Build Status](https://travis-ci.org/alu0100207385/SocialManager.svg)](https://travis-ci.org/alu0100207385/SocialManager)

Para ejecutar `$ rake local_tests` o arranque el servidor y ejecute `$ rake tests`.


##Coveralls

[![Coverage Status](https://coveralls.io/repos/alu0100207385/SocialManager/badge.png?branch=testing)](https://coveralls.io/r/alu0100207385/SocialManager?branch=testing)
```
Para ejecutar tiene varias opciones:
$ rake coveralls (pruebas spec + tests)
$ coveralls report (pruebas spec + tests)
$ rake rspec (pruebas spec)
```

##Instalación



##Ejecución

Con el comando `$ rake -T` podemos ver las opciones posibles.
Las opciones posibles son:

```
rake coveralls    # Run coveralls
rake heroku       # Open app in Heroku
rake local_tests  # Run tests in local machine
rake rackup       # Run the server via rackup
rake repo         # Open repository
rake rubocop      # Run Rubocop static code analyzer
rake server       # Run the chat server
rake sinatra      # Run the server via Sinatra
rake spec         # Run tests with rspec
rake tests        # Run tests

```

##Recursos

* [Apuntes](http://nereida.deioc.ull.es/~lpp/perlexamples/)
* [Gemas Ruby](https://rubygems.org/)
* [Sinatra](http://www.rubydoc.info/gems/sinatra)
* [Heroku dev center](https://devcenter.heroku.com/)
* [Omniauth](http://intridea.github.io/omniauth/)
* [Lista de estrategias](https://github.com/intridea/omniauth/wiki/List-of-Strategies)
* [Google API Console](https://code.google.com/apis/console)
* [Google Activity](https://developers.google.com/+/api/moment-types?hl=es)
* [Twitter Developers](https://dev.twitter.com/overview/documentation)
* [Registrar app en Twitter](https://apps.twitter.com/app/new)
* [Gema Twitter](http://sferik.github.io/twitter/)
* [Linkedin Developer](https://developer.linkedin.com/documents/authentication)
* [Linkedin Post](https://developer.linkedin.com/documents/share-api#toggleview:id=ruby)
* [DataMapper](http://datamapper.org/getting-started.html)
* [Haml](http://haml.info/)
* [Bootstrap](http://getbootstrap.com/css/)
* [jQuery API Documentation](http://api.jquery.com/)
* [Selenium](http://www.seleniumhq.org/)
* [Travis](https://travis-ci.org/)
* [Coveralls](https://coveralls.io/)
* [Capybara & PhantomJS example](http://nereida.deioc.ull.es/~lpp/perlexamples/node305.html#chapter:capybara)

-------------------------
*Sistemas y Tecnologías Web (Curso 2014-2015)*
