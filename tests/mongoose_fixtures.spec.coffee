path = require 'path'
fs = require 'fs'
async = require 'async'
path = require 'path'
mongoose = require 'mongoose'
fixturesLoader = require '../'

describe 'mongoose-fixtures test', () =>
    beforeEach (done) =>
        mongoose.connect process.env.MONGODB_URL
        mongoose.connection.on 'error', (err) ->
          console.log(err)
          done()
        mongoose.connection.on 'open', () ->
            modelsFolder = path.join(__dirname, './models')
            models = fs.readdirSync modelsFolder
            for model in models
                require(path.join(modelsFolder, model))
            done()

    afterEach (done) =>
        mongoose.connection.close done

    it 'should load fixtures from a directory', (done) =>
        fixturesLoader.load path.join(__dirname, './fixtures'), (err) =>
            expect(err).toBeNull()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).toBeNull()
                expect(countries).toBeTruthy()
                expect(countries).toEqual jasmine.any(Array)
                expect(countries.length).toEqual 2
                done()

    it 'should load fixtures from a file', (done) =>
        fixturesLoader.load path.join(__dirname, './fixtures/countries.coffee'), (err) =>
            expect(err).toBeNull()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).toBeNull()
                expect(countries).toBeTruthy()
                expect(countries).toEqual jasmine.any(Array)
                expect(countries.length).toEqual 2
                done()

    it 'should load fixtures from an object', (done) =>
        data = require './fixtures/countries'
        fixturesLoader.load data, (err) =>
            expect(err).toBeNull()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).toBeNull()
                expect(countries).toBeTruthy()
                expect(countries).toEqual jasmine.any(Array)
                expect(countries.length).toEqual 2
                done()
