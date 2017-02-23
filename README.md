# A Pokedex API based on the [vapor framework](https://vapor.codes/)


V0 : Display of some basics informations about each of the 718 firsts Pokemons.

- Vapor Toolbox v1.0.3
- Swift 3.0.1
- PostgreSQL 9.6.1


## Requests

### format

url/api/{version}/{filter}/{value}
https://pokedex-vapor.herokuapp.com/api/v0/{filter}/{value}

You can make request on 2 attributes: index or name


### exemples:

[https://pokedex-vapor.herokuapp.com/api/v0/index/002](https://pokedex-vapor.herokuapp.com/api/v0/index/002)

[https://pokedex-vapor.herokuapp.com/api/v0/name/pikachu](https://pokedex-vapor.herokuapp.com/api/v0/name/pikachu)

The API is hosted on a free Heroku account. Due to free account limitations,the first request to the API can take 15-20 secondes (Time for server instance to wake-up).
