$(document).on('shiny:connected', function(event) {
  Shiny.addCustomMessageHandler('applyZoom', function(message) {
    var chart = Highcharts.charts[0]; // Adjust index if multiple charts
    if (chart) {
      var svgElement = chart.container.querySelector('svg');
      if (svgElement) {
        svgPanZoom(svgElement, {
          zoomEnabled: true,
          controlIconsEnabled: true,
          fit: true,
          center: true,
          minZoom: 0.5,
          maxZoom: 20
        });
      }
    }
  });
});
