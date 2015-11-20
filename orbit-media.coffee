# stub orbit if it's included without the orbit main package
unless Orbit?
  @Orbit =
    RegisterBlock: -> return null

  if Meteor.isClient
    # general template helpers
    UI.registerHelper 'OrbitFormatDateTime', (dateObj) ->
      thisDate = new Date(dateObj)
      return "#{thisDate.toLocaleDateString()} - #{thisDate.toLocaleTimeString()}"

    UI.registerHelper 'OrbitFormatFilesize', (bytes, si) ->

      thresh = if si then 1000 else 1024

      if Math.abs(bytes) < thresh
        return bytes + ' B'

      units = if si then [
        'kB','MB','GB','TB','PB','EB','ZB','YB'
      ] else [
        'KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB'
      ]
      u = -1
      loop
        bytes /= thresh
        ++u
        unless Math.abs(bytes) >= thresh and u < units.length - 1
          break

      return bytes.toFixed(1) + ' ' + units[u]

Orbit.RegisterBlock
  type: "mediaManager"
  name: "Media Manager"
  description:  "Interface for uploading and editing files"
  template: "OrbitMedia"
  spaces: ['admin']

# filters for conversion

# images
  # all images should have, convert to jpeg
  # original size
  # large (1024)
  # dafault (350)
  # thumb (80)

# ttf, otf, mp3, wav, mp4 (no converting)

storeSettings = (storeName, imageOnly, transformFn) ->

  settings =
    maxTries: 3 # optional, default 1 max 5
    transformWrite: (fileObj, readStream, writeStream) ->
      if fileObj.original.type.indexOf('image') is 0
        transformFn(fileObj,readStream,writeStream)
      else if imageOnly
        return false
      else
        readStream.pipe writeStream

  return new FS.Store.GridFS storeName, settings


# define media collection
Orbit.Media = new FS.Collection "OrbitMedia",
  stores: [
    storeSettings "default", false, (fileObj,readStream,writeStream) ->
      gm(readStream, fileObj.name()).autoOrient().resize("450", "450>^").stream().pipe(writeStream)

    storeSettings "large", true, (fileObj,readStream,writeStream) ->
      gm(readStream, fileObj.name()).autoOrient().resize("1024", "1024>^").stream().pipe(writeStream)

    storeSettings "thumb", true, (fileObj,readStream,writeStream) ->
      gm(readStream, fileObj.name()).autoOrient().resize("80", "80>").stream().pipe(writeStream)
  ]
  filter:
    maxSize: 1024 * 1024 * 500 # 500 mb
    allow:
      extensions: ['pdf', 'png', 'jpg', 'gif', 'jpeg', 'mp3', 'wav', 'mp4', 'ttf', 'otf']

    onInvalid: (message) ->
      if Meteor.isClient
        alert message
      else
        console.log message


if Meteor.isServer

  Meteor.publish null, -> Orbit.Media.find()

if Meteor.isClient

  Template.OrbitMedia.helpers
    allFiles: -> Orbit.Media.find({},{sort:{uploadedAt:-1}})

  Template.OrbitMedia.events
    'change .orbit-media-upload': (e) ->
      FS.Utility.eachFile e, (file) -> Orbit.Media.insert file

    'click .orbit-media-delete' : -> Orbit.Media.remove @_id