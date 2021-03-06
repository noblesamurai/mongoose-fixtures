# mongoose-fixtures

[![Build Status](https://travis-ci.org/OpenifyIt/mongoose-fixtures.png?branch=master)](https://travis-ci.org/OpenifyIt/mongoose-fixtures)

Simple fixture loader for Mongoose on NodeJS.

Fixtures can be in one file, or divided up into separate files for organisation 
(e.g. one file per model)

The fixture files must export objects which are keyed by the Mongoose model name, each
containing the data for documents within that.

NOTE: Loading fixtures will clear the existing contents of a collection!

## Installation

    npm install openifyit-mongoose-fixtures


## Usage

FOR EXAMPLE:
With the file below, 3 documents will be inserted into the 'User' collection and 2 into the 'Business' collection:

    //fixtures.js
    exports.User = [
        { name: 'Gob' },
        { name: 'Buster' },
        { name: 'Steve Holt' }
    ];

    exports.Business = [
        { name: 'The Banana Stand' },
        { name: 'Bluth Homes' }
    ];


You can also load fixtures as an object where each document is keyed, in case you want to reference another document:

    //users.js
    var ObjectId = require('mongodb').BSONNative.ObjectID;

    exports.User = {
        user1: {
            _id: new ObjectId(),
            name: 'Michael'
        },
        user2: {
            _id: new ObjectId(),
            name: 'George Michael',
            father: exports.User.user1._id
        }
    }

In your code

    var fixtures = require('openifyit-mongoose-fixtures');
    
    //Objects
    fixtures.load({
        User: [
            { name: 'Maeby' },
            { name: 'George Michael' }
        ]
    });

    //Files
    fixtures.load('./fixtures/users.js');

    //Directories (loads all files in the directory)
    fixtures.load('./fixtures');

## How to run tests

    npm test
