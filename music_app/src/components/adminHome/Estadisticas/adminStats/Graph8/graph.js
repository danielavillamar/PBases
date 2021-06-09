import React from 'react'; 
import Chart from 'react-apexcharts';
import { connect } from 'react-redux';

import * as selectors from '../../../../../reducers/index';
// import * as actions from '../../../actions/stats';
// import makeRequest from '../../requests/index';

const Graph8 = ({ stats }) =>{
    const cat = [];
    const info = [];

    stats.map(stat => {
        cat.push(stat.name);
        info.push(stat.count);
    })

    console.log(cat, info)

    const options = {
        plotOptions: {
            bar: {
                size: 200
            }
            },
        chart: {
            background: "#f4f4f4",
            foreColor: "#333"
        },
        xaxis: {
            fill: {
                colors: ["#F44336"]
            },
            dataLabels: {
                enabled: false
            },
            categories: [
                ...cat
                ]
        }
    }
    
    const series = [{
        name: "Population",
        data: [
            ...info
        ]   
    }]

    return(
            <Chart
                options={options}
                series={series}
                type='bar'
                height='450'
                width='100%'
            />
    )
}

export default connect(
    state => ({
        stats: selectors.getStats(state, 'graph8'),
    })
)(Graph8)