
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

## Production Environment Information

URL: https://www.secretsanta.website/
