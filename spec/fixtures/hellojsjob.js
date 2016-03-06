window.jsJobRun = function(inputdata, options, callback) {
  var err = null;
  var result = {'hello': 'jsjob'};
  var details = {'meta': 'data'}; // Can be used for information about the execution or results
  return callback(err, result, details);
};
