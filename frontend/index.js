function unpack(rows, key) {
  return rows.map(function (row) {
    return row[key];
  });
}

const colors = [
  "#00ff00",
  "#2e8b57",
  "#8b0000",
  "#00ced1",
  "#000080",
  "#ff0000",
  "#ff8c00",
  "#ffd700",
  "#ba55d3",
  "#00ff7f",
  "#0000ff",
  "#f08080",
  "#adff2f",
  "#ff00ff",
  "#1e90ff",
  "#dda0dd",
  "#add8e6",
  "#ff1493",
  "#7fffd4",
  "#ffdead",
];

async function createWorldChart(dataUrl, element, title, z = "ANZAHL") {
  const questionData = await (await fetch(dataUrl)).json();

  var data = [
    {
      type: "choropleth",
      locationmode: "country names",
      locations: unpack(questionData.rows, "NAME"),
      z: unpack(questionData.rows, z),
      text: unpack(questionData.rows, "NAME"),
      autocolorscale: false,
      colorscale: [
        [0, "hsl(238, 100%, 99%)"],
        [0.01, "hsl(238, 100%, 90%)"],
        [0.2, "hsl(238, 100%, 80%)"],
        [0.5, "hsl(238, 100%, 70%)"],
        [0.75, "hsl(238, 100%, 60%)"],
        [1, "hsl(238, 100%, 50%)"],
      ],
    },
  ];

  var layout = {
    title: {
      text: title,
      font: {
        size: 30,
      },
    },
    legend: {
      font: {
        size: 30,
      },
    },
    geo: {
      projection: {
        type: "robinson",
      },
    },
  };

  Plotly.newPlot(element, data, layout, { showLink: false });
}

async function createBarChart(
  dataUrl,
  options = {
    element,
    title,
    xValues,
    xTitle,
    yValues,
    yTitle,
    mutate,
  }
) {
  const rawData = await (await fetch(dataUrl)).json();
  const questionData = options.mutate(rawData);

  var data = [
    ...questionData.map((row) => ({
      x: unpack(row, options.xValues),
      y: unpack(row, options.yValues),
      type: "bar",
    })),
  ];

  var layout = {
    title: {
      text: options.title,
      font: {
        size: 25,
      },
    },
    barmode: "stack",
    xaxis: {
      title: options.xTitle,
      titlefont: {
        size: 20,
      },
      tickfont: {
        size: 20,
      },
    },
    yaxis: {
      title: options.yTitle,
      titlefont: {
        size: 20,
      },
      tickfont: {
        size: 20,
      },
    },
    legend: {
      x: 0,
      y: 1.0,
      bgcolor: "rgba(255, 255, 255, 0)",
      bordercolor: "rgba(255, 255, 255, 0)",
    },
  };

  Plotly.newPlot(options.element, data, layout);
}
async function createPieChart(
  dataUrl,
  element,
  title,
  labelsName,
  valuesName,
  labelPosition = "inside",
  mutate = (rawData) => rawData.rows
) {
  const rawData = await (await fetch(dataUrl)).json();
  const questionData = mutate(rawData);

  var data = [
    {
      values: unpack(questionData, labelsName),
      labels: unpack(questionData, valuesName),
      textinfo: "label+value",
      textposition: labelPosition,
      // hoverinfo: "none",
      automargin: true,
      type: "pie",
    },
  ];

  var layout = {
    title: {
      text: title,
      font: {
        size: 35,
      },
    },
    uniformtext: {
      mode: "hide",
      minsize: 30,
    },
    showlegend: false,
  };

  Plotly.newPlot(element, data, layout);
}

async function createLineChart(
  dataUrl,
  options = {
    element,
    title,
    labelsName,
    valuesName,
    type,
    mutate,
    xTitle,
    yTitle,
  }
) {
  const rawData = await (await fetch(dataUrl)).json();
  const questionData = options.mutate(rawData);
  console.log(questionData);
  const asd = Array.from(questionData);
  console.log(Object.entries(questionData));
  var data = [
    ...Object.entries(questionData).map((row, i) => ({
      y: unpack(row[1], options.valuesName),
      x: unpack(row[1], options.labelsName),
      mode: options.type,
      marker: {
        size: 20,
        color: colors[i],
      },
      name: row[0],
    })),
  ];

  var layout = {
    title: {
      text: options.title,
      font: {
        size: 25,
      },
    },
    legend: {
      font: {
        size: 20,
      },
    },
    xaxis: {
      title: options.xTitle,
      titlefont: {
        size: 20,
      },
    },
    yaxis: {
      title: options.yTitle,
      titlefont: {
        size: 20,
      },
    },
  };

  Plotly.newPlot(options.element, data, layout);
}
