# thrive_challenge
Small ruby file that consolidates user and company json into our desired file format

## Table of Contents

- [General Info](#general-information)
- [Technologies Used](#technologies-used)
- [Features](#features)
- [Setup](#setup)
- [Usage](#usage)

## General Information

Small ruby file that consolidates user and company json into our desired file format

## Technologies Used

- ruby

## Features

- Reads user and company json
- validate the data against a schema using json-schema. abort the app if the data is no good
- Filters and groups users based on the company they belong to and their email status
- Reshapes and writes data to a text file

See [challenge.txt](./challenge.txt) for more details

## Setup

- install ruby
- gem install json-schema

## Usage

```
ruby .\challenge.rb
```
