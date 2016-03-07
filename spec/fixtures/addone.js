window.jsJobRun = function(inputdata, options, callback) {
  var err = null;
  var result = {};
  var details = {};
  for (var key in inputdata) {
    result[key] = inputdata[key] + 1;
  }
  return callback(err, result, details);
};

