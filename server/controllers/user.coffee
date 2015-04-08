'use strict'

UserBLL = require '../business/user'

create = (req, res) ->
  data = req.body
  UserBLL.create(data).then ->
    res.send 'created'

getAll = (req, res) ->
  UserBLL.getAll().then (data) ->
    res.send data

module.exports = (app) ->
  app.post '/user/create', create
  app.get '/user/getAll', getAll
