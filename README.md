
# Secret Santa [![Build Status](https://travis-ci.org/jgunnink/secret-santa.svg?branch=master)](https://travis-ci.org/jgunnink/secret-santa) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/88410e3257554feb8975ed749e8ddf22)](https://www.codacy.com/app/jgunnink/vigilant-octo-happiness)

Rails application which handles the secret santa operations for an organiser of a secret santa.

## Developer

[JK Gunnink](http://twitter.com/jgunnink)

## Related Projects

The Frontier Group's [Rails Template](https://github.com/thefrontiergroup/rails-template)

## Dependencies

- Redis
- Sidekiq
- PostgreSQL

## Getting Started

This project now requires docker. So install that, along with docker-compose, if your OS doesn't
come with the docker-compose toolchain.

After cloning the repo, cd into the project and run:
`docker build -t secretsanta-web .`
Once built, execute `docker-compose up`.

The application should now be running and available on http://localhost:5000

## Running the tests

Similar to getting the environment up for development, testing follows a similar pattern.

Setup your testing docker container:
`docker build --file Dockerfile-tests -t secretsanta-testing .`

Run the compose file:
`docker-compose --file docker-compose-testing.yml run rspec`

The above will run your entire test suite, so you can use it, for example on CI.

Note (20th March 2019): there is a known issue at the moment with the test runner failing on the create list tests.
Specifically, this file: ./spec/features/member/santas/member_can_add_santas_to_list_spec.rb

I am currently looking into this, however I have a feeling it's something around PhantomJS and
running it in an alpine linux container.
