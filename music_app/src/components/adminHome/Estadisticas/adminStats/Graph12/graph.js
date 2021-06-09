import React from "react"; 
import Chart from "react-apexcharts";
import { connect } from "react-redux";

import * as selectors from "../../../../../reducers/index";
// import * as actions from '../../../actions/stats';
// import makeRequest from '../../requests/index';

const Graph12 = ({ stats }) => {
  const cat = [];
  const info = [];

  stats.map((stat) => {
    cat.push(stat.track);
    info.push(stat.reproductions);
  });

  const options = {
    plotOptions: {
      bar: {
        size: 200,
      },
    },
    chart: {
      background: "#f4f4f4",
      foreColor: "#333",
      height: 350,
      type: "line",
      zoom: {
        enabled: false,
      },
    },
    xaxis: {
      fill: {
        colors: ["#F44336"],
      },
      dataLabels: {
        enabled: false,
      },
      categories: [...cat],
    },
  };

  const series = [
    {
      name: "Sales",
      data: [...info],
    },
  ];

  return (
    <Chart
      options={options}
      series={series}
      type="bar"
      height="450"
      width="100%"
    />
  );
};

export default connect((state) => ({
  stats: selectors.getStats(state, "graph12"),
}))(Graph12);
