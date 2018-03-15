# Webster

A distributed S3 based personal music streaming app.

## Overview

The application is hosted in pieces. These are :-

* The static frontend application. This is hosted on S3.
* The backend. This is implemented as an Elixir/Phoenix HTTP accessible API.
* A backend database for storage of Metadata
* An additional S3 bucket used to host media files.

## In order to be able to access S3, you will need to create a credentials file. This file sits in ~/.aws/credentials and has the format

[default]
aws_access_key_id=xxxx
aws_secret_access_key=yyyy

## Commands

The static frontend application is uploaded via an NPM task