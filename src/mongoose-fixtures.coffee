
fs = require 'fs'
path = require 'path'
mongoose = require 'mongoose'
async =require 'async'

class MongooseFixtures
    load: (data, db, callback) =>
        console.log 'load'
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
        console.log 'loadObject', data
        iterator = (modelName, next) =>
            @_insertCollection modelName, data[modelName], db, next
        async.forEach Object.keys(data), iterator, callback

    loadFile: (file, db, callback) =>
        console.log 'loadFile'
        data = require file
        @load data, db, callback

    loadDir: (dir, db, callback) =>
        console.log 'loadDir'
        fs.readdir dir, (err, files) =>
            if (err)
                callback err
            else
                iterator = (file, next) =>
                    absolutePath = path.join dir, file
                    @loadFile absolutePath, db, next
                async.forEach files, iterator, callback

    _insertCollection: (modelName, data, db, callback) =>
        console.log '_insertCollection'
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
                async.forEach items, iterator, callback

    _removeCollection: (modelName, db, callback) =>
        console.log '_removeCollection'
        Model = db.model modelName
        Model.collection.remove callback

module.exports = new MongooseFixtures()
