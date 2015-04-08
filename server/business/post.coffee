'use strict'

GeoPoint = require 'geopoint'
PostModel = require '../models/post'

create = (data) ->
  # create function always return a promise
  PostModel.create(data)

update = (id, data) ->
  PostModel.findByIdAndUpdate(id, data).exec()

getById = (id) ->
  PostModel.findById(id).exec()

getAll = ->
  PostModel.find({}).sort({modified: -1}).exec()

getByType = (type) ->
  PostModel.find({type: type}).sort({modified: -1}).exec()

countAll = (type) ->
  PostModel.count({type: type}).exec()

getByLocation = (lat, lon, distance) ->
  curLocation = new GeoPoint(lat, lon)
  bounding = curLocation.boundingCoordinates(distance, null, true)
  area =
    sw: bounding[0]
    ne: bounding[1]

  return PostModel.find({})
    .where('latitude').gt(area.sw._degLat).lt(area.ne._degLat)
    .where('longitude').gt(area.ws._degLon).lt(area.ne._degLon)
    .exec()


module.exports = {
  create, update,
  getById, getAll, getByType,
  countAll,
  getByLocation
}
