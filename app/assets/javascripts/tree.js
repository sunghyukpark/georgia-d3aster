$(document).ready(function(){
  initTreeFromCsv();
})

function initTreeFromCsv(){
  // setup canvas
  var margin = { top: 20,
      right: 120,
      bottom:20,
      left:250 },
      width = 1500- (margin.right + margin.left),
      height = 1000 - (margin.top + margin.bottom);

  var i = 0

  // set duration for update
  var duration = 500;

  // set tree
  var tree = d3.layout.tree()
      .size([height, width])
  var root = {};

  // diagonal generator
  var diagonal = d3.svg.diagonal()
      .projection(function(d){ return [d.y, d.x];});


  // d3 svg
  var svg = d3.select("body").append("svg")
      .attr("width", width + margin.right + margin.left)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


  // parse data
  d3.csv("/disasters.csv", function(d) {
    return {
      hazard_id : +d.hazard_id,
      beginDate : new Date(d.HAZARD_BEGIN_DATE),
      endDate : new Date(d.HAZARD_END_DATE),
      year : new Date(d.HAZARD_BEGIN_DATE).getFullYear(),
      typeCombo : d.HAZARD_TYPE_COMBO,
      key  : d.NAME, // key is displayed as text in chart
      postalCode : d.POSTAL_CODE,
      fipsCode : +d.FIPS_CODE,
      injuries : +d.INJURIES,
      fatalities : +d.FATALITIES,
      propDamage : +d.PROPERTY_DAMAGE,
      cropDamage : +d.CROP_DAMAGE,
      remarks : d.REMARKS
    };
  }, function(data) {

    jsonData = jsonStringifyData(data);
    saveHazardData(jsonData);

    // Generate nested data
    // 1st grouping by year
    // 2nd grouping by typeCombo
    var treeData = d3.nest()
        .key(function(d){ return d.year; })
        .key(function(d){ return d.typeCombo; })
        .entries(data)

    changeValuesToChildren(treeData);

    // Add root
    root.children = treeData;
    root.key = "Disasters in Georgia 2010-2013";
    root.x0 = height / 2;
    root.y0 = 0;

    console.log(root)

    function collapse(d) {
      if (d.children) {
        d._children = d.children;
        d._children.forEach(collapse);
        d.children = null;
      }
    }

    root.children.forEach(collapse);
    update(root);
    d3.select(self.frameElement).style("height", "500px");
  });

  // given an array, replace object.values with object.children
  // This is to use "children" accessor of d3
  function changeValuesToChildren(arr){
    for (var i=0; i < arr.length; i++){
      if (Array.isArray(arr[i].values)){
        arr[i].children = arr[i].values
        delete arr[i].values
        changeValuesToChildren(arr[i].children)
      }
    }
  }

  function jsonStringifyData(data){
    var jsonData = {};
    for(var i=0; i<data.length; i++){
      jsonData[i] = data[i]
    };
    return JSON.stringify(jsonData);
  }

  // given a JSON data, store it as objects in Rails
  function saveHazardData(data){
    var request = $.ajax({
      url: '/hazards',
      method: 'POST',
      data: data,
      dataType: 'JSON'
    });

    request.done(function(msg){
      console.log("ajax success")
    })

    request.fail(function(msg){
      console.log("ajax fail")
    })
  }


  function update(source) {
    // Compute the new tree layout.
    var nodes = tree.nodes(root).reverse(),
    links = tree.links(nodes);

    // Normalize for fixed-depth.
    nodes.forEach(function(d) { d.y = d.depth * 300; });

    // Update the nodes…
    var node = svg.selectAll("g.node")
        .data(nodes, function(d) { return d.id || (d.id = ++i); });

    // Enter any new nodes at the parent's previous position.
    var nodeEnter = node.enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
        .on("click", click);

    nodeEnter.append("circle")
             .attr("r", 1e-6)
             .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

    nodeEnter.append("text")
             .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
             .attr("y", -20)
             .attr("dy", ".35em")
             .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "end"; })
             .text(function(d) { return d.key; })
             .style("fill-opacity", 1e-6);

    // Transition nodes to their new position.
    var nodeUpdate = node.transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

    nodeUpdate.select("circle")
        .attr("r", 4.5)
        .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

    nodeUpdate.select("text")
        .style("fill-opacity", 1);

    // Transition exiting nodes to the parent's new position.
    var nodeExit = node.exit().transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
        .remove();

    nodeExit.select("circle")
            .attr("r", 1e-6);

    nodeExit.select("text")
            .style("fill-opacity", 1e-6);

    // Update the links…
    var link = svg.selectAll("path.link")
        .data(links, function(d) { return d.target.id; });

    // Enter any new links at the parent's previous position.
    link.enter().insert("path", "g")
        .attr("class", "link")
        .attr("d", function(d) {
          var o = {x: source.x0, y: source.y0};
          return diagonal({source: o, target: o});
        });

    // Transition links to their new position.
    link.transition()
        .duration(duration)
        .attr("d", diagonal);

    // Transition exiting nodes to the parent's new position.
    link.exit().transition()
        .duration(duration)
        .attr("d", function(d) {
          var o = {x: source.x, y: source.y};
          return diagonal({source: o, target: o});
        })
        .remove();

    // Stash the old positions for transition.
    nodes.forEach(function(d) {
      d.x0 = d.x;
      d.y0 = d.y;
    });
  }

  // Toggle children on click.
  function click(d) {
    if (d.children) {
      d._children = d.children;
      d.children = null;
    } else {
      d.children = d._children;
      d._children = null;
    }
    update(d);
  }
}


