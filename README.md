# SeaRouter Application

## Overview

In developing the code, I aimed to prioritize readability and simplicity to ensure it remains straightforward and easy to understand. While I recognize there is room for improvement in terms of dependency injection, I opted to avoid adding complexity to maintain the code's approachability and ease of maintenance. 

You can also check for app.rb file to see the implementation of the endpoints.


## Technologies used
```
ruby 3.2.2
sinatra
rubocop
ruby-lsp
rspec
```


## Running the tests

```bash
rspec
```

## Building the Docker Image

```bash
docker build -t sea_router .
docker run -p 9292:9292 sea_router
```

Access the application at 
`http://localhost:9292/`



#### PLS-0001
```bash
http://localhost:9292/cheap_direct_route?origin=CNSHA&destination=NLRTM
```

The return of this endpoint in json should be:

```json
  {
    origin_port: "CNSHA",
    destination_port: "NLRTM",
    departure_date: "2022-01-30",
    arrival_date: "2022-03-05",
    sailing_code: "MNOP",
    rate: 456.78,
    rate_currency: "USD"
  }
```

#### WRT-0002
```bash
http://localhost:9292/cheapest_direct_or_indirect_route?origin=CNSHA&destination=NLRTM
```

The return of this endpoint in json should be:

```json
[
  {
    origin_port: "CNSHA",
    destination_port: "ESBCN",
    departure_date: "2022-01-29",
    arrival_date: "2022-02-12",
    sailing_code: "ERXQ",
    rate: 261.96,
    rate_currency: "EUR"
  },
  {
    origin_port: "ESBCN",
    destination_port: "NLRTM",
    departure_date: "2022-02-15",
    arrival_date: "2022-03-29",
    sailing_code: "ETRF",
    rate: 70.96,
    rate_currency: "USD"
  }
]
```


#### TST-0003
```bash
http://localhost:9292/fastest_sailing_leg?origin=CNSHA&destination=NLRTM
```

The return of this endpoint in json should be:

```json
  {
    origin_port: "ESBCN",
    destination_port: "NLRTM",
    departure_date: "2022-02-16",
    arrival_date: "2022-02-20",
    sailing_code: "ETRG",
    rate: 69.96,
    rate_currency: "USD"
  }
```