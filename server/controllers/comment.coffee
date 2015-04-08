'use strict'

CommentBLL = require '../business/comment'

create = (req, res) ->
  data = req.body
  CommentBLL.create(data).then (data) ->
    res.send data

getByPostId = (req, res) ->
  postId = req.query.postId
  CommentBLL.getByPostId(postId).then (data) ->
    res.send data

module.exports = (app) ->
  app.post '/comment/create', create
  app.get '/comment/getByPostId', getByPostId
