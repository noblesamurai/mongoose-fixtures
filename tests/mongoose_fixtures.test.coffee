
require "coffee-script"

async = require 'async'
path = require 'path'
expect = require 'expect.js'
mongoose = require 'mongoose'
fixturesLoader = require '../src/mongoose-fixtures'
MongooseInitializer = require('openifyit-commons').MongooseInitializer;

describe 'mongoose-fixtures test', () =>
    before (done) =>
        @mongooseInitializer = new MongooseInitializer(process.env.MONGODB_URL, path.join(__dirname, './models'))

        functions = [
            @mongooseInitializer.openConnection,
            @mongooseInitializer.loadModels
        ]
        async.series functions, done

    after (done) =>
        done()

    it 'should load fixtures from a directory', (done) =>
        fixturesLoader.load './fixtures', (err) =>
            expect(err).not.to.be.ok()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).not.to.be.ok()
                expect(countries).to.be.ok()
                expect(countries).to.be.an(Array)
                expect(countries.length).to.be.eql(2)
                done()

    it 'should load fixtures from a file', (done) =>
        fixturesLoader.load './fixtures/countries.coffee', (err) =>
            expect(err).not.to.be.ok()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).not.to.be.ok()
                expect(countries).to.be.ok()
                expect(countries).to.be.an(Array)
                expect(countries.length).to.be.eql(2)
                done()

    it 'should load fixtures from an object', (done) =>
        data = require './fixtures/countries'
        fixturesLoader.load data, (err) =>
            expect(err).not.to.be.ok()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).not.to.be.ok()
                expect(countries).to.be.ok()
                expect(countries).to.be.an(Array)
                expect(countries.length).to.be.eql(2)
                done()
