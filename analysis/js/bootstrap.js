module.exports = function(data, subject, type, measure, numSamples) {
  var subjectPool = [],
      n = numSamples || 1000,
      groups = {},
      samples = {},
      id, sid, i, j, n, m, s;

  // extract subject pool
  data.reduce(function(pool, d) {
    var id = subject(d);
    if (!pool[id]) {
      subjectPool.push(id);
      pool[id] = 1;
    }
    return pool;
  }, {});

  m = subjectPool.length;

  // partition data by type
  data.forEach(function(d) {
    var tid = type(d),
        sid = subject(d);

    if (!groups[tid]) {
      groups[tid] = {};
      samples[tid] = [];
      samples[tid].dims = type.annotate({}, d);
    }
    var g = groups[tid];
    (g[sid] || (g[sid] = [])).push(d);
  });

  for (i=0; i<n; ++i) {
    // sample subjects with replacement
    for (subjects=[], j=0; j<m; ++j) {
      subjects.push(subjectPool[~~(m * Math.random())]);
    }
    // for each group, consolidate subject data & compute measure
    for (id in groups) {
      var g = groups[id],
          s = [];
      for (j=0; j<m; ++j) {
        s = s.concat(g[subjects[j]]);
      }
      samples[id].push(measure(s));
    }
  }

  return samples;
}
