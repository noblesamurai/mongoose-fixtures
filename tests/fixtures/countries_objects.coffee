mongoose = require 'mongoose'
ObjectID = mongoose.mongo.BSONPure.ObjectID

countries =
  country1:
    _id: new ObjectID(),
    countryCode: "CA",
    countryName: "Canada",
  country2:
    _id: new ObjectID(),
    countryCode: "SE",
    countryName: "Sweden",

module.exports.Country = countries
