require "coffee-script"

path = require 'path'
fs = require 'fs'
async = require 'async'
path = require 'path'
expect = require 'expect.js'
mongoose = require 'mongoose'
fixturesLoader = require '../main'

describe 'mongoose-fixtures test', () =>
    before (done) =>
        mongoose.connect process.env.MONGODB_URL
        mongoose.connection.on 'error', done
        mongoose.connection.on 'open', () ->
            modelsFolder = path.join(__dirname, './models')
            models = fs.readdirSync modelsFolder
            for model in models
                require(path.join(modelsFolder, model))
            done()

    after (done) =>
        done()

    it 'should load fixtures from a directory', (done) =>
        fixturesLoader.load path.join(__dirname, './fixtures'), (err) =>
            expect(err).not.to.be.ok()
            CountrySchema = mongoose.connection.model 'Country'
            CountrySchema.find {}, (err, countries) =>
                expect(err).not.to.be.ok()
                expect(countries).to.be.ok()
                expect(countries).to.be.an(Array)
                expect(countries.length).to.be.eql(2)
                done()

    it 'should load fixtures from a file', (done) =>
        fixturesLoader.load path.join(__dirname, './fixtures/countries.coffee'), (err) =>
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
