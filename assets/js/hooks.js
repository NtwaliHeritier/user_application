let Hooks = {}

Hooks.Plots = {
  mounted() {
  this.handleEvent("show", (data) => {
    displayGraph(data)
  })
}}

displayGraph = (reply) => {
    reply.response.map((res) => {
        if(res.csv !== "error") {
          Papa.parse(res.csv, {
            header: true,
            complete: (results) => {
              const dataArray = results.data;
              const operator = res.expression.match(/[+\-*/]/g)
              let selectedColumn = []
  
              if(operator) {
                const [operation] = operator
                const expressions = res.expression.split(operation).map((expression) => expression.trim())
                if(operation == "+") {
                  selectedColumn = dataArray.map(row => row[expressions[0]] + row[expressions[1]])
                } else if(operation == "-") {
                  selectedColumn = dataArray.map(row => row[expressions[0]] - row[expressions[1]])
                } else if(operation == "*") {
                  selectedColumn = dataArray.map(row => row[expressions[0]] * row[expressions[1]])
                } else if(operation == "/") {
                  selectedColumn = dataArray.map(row => row[expressions[0]] / row[expressions[1]])
                }
              }
              else {
                selectedColumn = dataArray.map(row => row[res.expression])
              }
  
      const trace = {
          x: selectedColumn,
          type: 'histogram',
        };
      const data = [trace];
      const layout = {
        title: res.name,
        xaxis: {title: res.expression},
        yaxis: {title: 'Count of Records'}
      };
      Plotly.newPlot(`plot_${res.id}`, data, layout);
            }
          });
        }
      }
    )
}


export default Hooks