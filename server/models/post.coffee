'use strict'

mongooes = require 'mongoose'
Schema = mongooes.Schema

PostSchema = new Schema
  # creator
  _user:
    type: Schema.Types.ObjectId
    ref: 'User'

  content:
    type: String

  latitude:
    type: Number

  longitude:
    type: Number

  locationData:
    type: Schema.Types.Mixed

  createdDate:
    type: Date
    default: Date.now

module.exports = mongooes.model 'Post', PostSchema
