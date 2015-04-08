'use strict'

mongooes = require 'mongoose'
passportLocal = require 'passport-local-mongoose'
Schema = mongooes.Schema

UserSchema = new Schema
  userName:
    type: String
    unique: true
    require: true

  email:
    type: String
    unique: true

  firstName:
    type: String

  lastName:
    type: String

  birthday:
    type: Date

  avatar:
    type: String

  role:
    type: String

  createdDate:
    type: Date
    default: Date.now

UserSchema.plugin passportLocal

module.exports = mongooes.model 'User', UserSchema
