fs = require 'fs'
path = require 'path'
mongoose = require 'mongoose'
async =require 'async'

class MongooseFixtures
    load: (data, db, callback) =>
        if typeof db == 'function'
            callback = db
            db = mongoose.connection

        if typeof data == 'object'
            @loadObject data, db, callback
        else if typeof data == 'string'
            stat = fs.statSync data
            if stat.isDirectory()
                @loadDir data, db, callback
            else
                @loadFile data, db, callback
        else
            callback(new Error('data must be an object, array or string (file or dir path)'))

    loadObject: (data, db, callback) =>
        iterator = (modelName, next) =>
            @_insertCollection modelName, data[modelName], db, next
        async.each Object.keys(data), iterator, callback

    loadFile: (file, db, callback) =>
        data = require file
        @load data, db, callback

    loadDir: (dir, db, callback) =>
        fs.readdir dir, (err, files) =>
            if (err)
                callback err
            else
                iterator = (file, next) =>
                    absolutePath = path.join dir, file
                    @loadFile absolutePath, db, next
                async.each files, iterator, callback

    _insertCollection: (modelName, data, db, callback) =>
        @_removeCollection modelName, db, (err) =>
            if err
                callback err
            else
                items = new Array()
                if Array.isArray(data)
                    items = data
                else
                    for i in data
                        items.push data[i]

                Model = db.model modelName
                iterator = (item, next) =>
                    doc = new Model(item)
                    doc.save (err) =>
                        if err
                            next err
                        else
                            next()
                async.each items, iterator, callback

    _removeCollection: (modelName, db, callback) =>
        Model = db.model modelName
        Model.collection.remove callback

module.exports = new MongooseFixtures()
