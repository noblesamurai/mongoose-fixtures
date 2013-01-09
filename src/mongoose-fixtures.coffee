
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
            absolutePath = path.resolve(path.join(path.dirname(module.parent.filename), data))
            stat = fs.statSync absolutePath
            if stat.isDirectory()
                @loadDir absolutePath, db, callback
            else
                @loadFile absolutePath, db, callback
        else
            callback(new Error('Data must be an object, array or string (file or dir path)'))

    insertCollection: (modelName, data, db, callback)=>
        Model = db.model modelName
        Model.collection.remove (err) =>
            if err
                callback err
            else
                items = new Array()
                if Array.isArray(data)
                    items = data
                else
                    for i in data
                        items.push data[i]

                iterator = (item, next) =>
                    doc = new Model(item)
                    doc.save (err) =>
                        if err
                            next err
                        else
                            next()
                async.forEach items, iterator, callback

    loadObject: (data, db, callback) =>
        iterator = (modelName, next) =>
            @insertCollection modelName, data[modelName], db, next
        async.forEach data, iterator, callback

    loadFile: (file, db, callback) =>
        absolutePath = path.resolve file
        data = require absolutePath
        @load data, db, callback

    loadDir: (dir, db, callback) =>
        absolutePathDir = path.resolve dir
        fs.readdir absolutePathDir, (err, files) =>
            if (err)
                callback err
            else
                iterator = (file, next) =>
                    absolutePath = path.join absolutePathDir, file
                    @loadFile absolutePath, db, next
                async.forEach files, iterator, callback

module.exports = new MongooseFixtures()
