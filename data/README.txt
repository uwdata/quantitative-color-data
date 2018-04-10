Experimental data for "Somewhere Over the Rainbow: An Empirical Assessment of Quantitative Colormaps", ACM CHI 2018.

Here are all the experimental raw data, in CSV format.

/multi
  - data for assorted palettes group: viridis, jet, blues, blueorange

/ramp
  - data for single-hue palettes group: blues, greens, greys, oranges

/ucs
  - data for multi-hue UCS palettes group: viridis, magma, plasma

====================================================================

subject.csv contains information for a subject

- subject: internal database subject ID
- gender: self-reported gender
- age: self-reported age
- palette_order: the order in which palettes were presented
- os: operating system parsed from user-agent
- browser: browser parsed from user-agent

====================================================================

results.csv contains information for a trial record

- subject: internal database subject ID
- palette: the palette from which this trial is sampled
- user_answer: the user’s answer
- time: response time in milliseconds
- ref: reference stimulus, in data domain
- left: left stimulus (choice “a”), in data domain
- right: right stimulus (choice “b”), in data domain
- true_answer: the correct answer
- correct: if the user answer is correct
- incorrect: if the user answer is incorrect
- baseline: the distance between reference and the closer choice
- lab_left: LAB(ref, left), where LAB is the CIELAB delta E (76)
- lab_right: LAB(ref, right)
- lab_total: LAB(left, right)
- lab_diff: signed difference between lab_left and lab_right (see paper)
- ucs_left: UCS(ref, left), where UCS is the CAM02-UCS distance
- ucs_right: UCS(ref, right)
- ucs_total: UCS(left, right)
- ucs_diff: signed difference between ucs_left and ucs_right (see paper)
- name_left: Name(ref, left), where Name is the naming cosine distance
- name_right: Name(ref, right)
- name_total: Name(left, right)
- name_diff: signed difference between name_left and name_right (see paper)
- sal_left: naming saliency score of the left stimulus
- sal_right: naming saliency score of the right stimulus
- sal_ref: naming saliency score of the reference stimulus
- l_left: CIELAB L* value of the left stimulus
- l_right: CIELAB L* value of the right stimulus
- l_ref: CIELAB L* value of the ref stimulus
- a_left: CIELAB a* value of the left stimulus
- a_right: CIELAB a* value of the right stimulus
- a_ref: CIELAB a* value of the ref stimulus
- b_left: CIELAB b* value of the left stimulus
- b_right: CIELAB b* value of the right stimulus
- b_ref: CIELAB b* value of the ref stimulus
- create_time: time when the record is created

