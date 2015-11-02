Package.describe({
    name: 'orbit:media',
    summary: 'A Generic Media Upload Form for Orbit',
    version: '0.1.0'
});

Package.onUse(function(api) {

    api.versionsFrom('1.1.0.2');

    api.use([
      'coffeescript',
      'templating',
      'cfs:standard-packages@0.5.9',
      'cfs:gridfs@0.0.33',
      'cfs:graphicsmagick@0.0.18',
      'cfs:ui@0.1.3',
      'raix:handlebar-helpers@0.2.5'
    ], ['client', 'server']);

    api.addFiles([
      'orbit-media.html',
      'orbit-media.coffee',
      'orbit-media.css'
    ], ['client', 'server']);


});
