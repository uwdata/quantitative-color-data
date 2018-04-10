var d3 = require('d3-array');
var bs = require('./bootstrap');

function CI(samples) {
  if (samples.dims) {
    for (var name in samples.dims) {
      this[name] = samples.dims[name];
    }
  }

  samples.sort(function(a, b) { return a - b; });
  var mean = d3.mean(samples),
      dev = d3.deviation(samples);
  this.mean = mean;
  this.z0 = mean - 1.96 * dev;
  this.z1 = mean + 1.96 * dev;
  this.q0 = d3.quantile(samples, 0.025);
  this.q1 = d3.quantile(samples, 0.975);
  this.f0 = d3.quantile(samples, 0.25);
  this.f1 = d3.quantile(samples, 0.75);
}

CI.prototype.toString = function() {
  return this.key + ':\n  ['
    + this.z0.toFixed(3) + ', '
    + this.z1.toFixed(3) + '] '
    + this.mean.toFixed(3);
};

function confint(data, subject, type, value) {
  var s = bs(data, subject, type, function(x) {
    return d3.mean(x, value);
  });
  return Object.keys(s)
    .map(function(id) { return new CI(s[id]); })
    .sort(function(a, b) { return d3.ascending(a.key, b.key); });
}

module.exports = confint;
