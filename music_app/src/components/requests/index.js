/*

            REQUESTS

    Requiests a REST API.

*/
const axios = require('axios');

const makeRequest = (values, requestInfo, res) => {

    switch(requestInfo.type){
        case 'GET':
            axios.get(requestInfo.uri)
                .then(function (response) {
                    res(response.data)
                })
                .catch(function (error) {
                    res(error.data)
                });
            break;

        case 'POST':
            axios.post(requestInfo.uri, values)
                .then(function (response) {
                    res(response.data)
                })
                .catch(function (error) {
                    res(error.data)
                });
            break;

        case 'PUT':
            axios.put(requestInfo.uri, values)
                .then(function (response) {
                    res(response.data)
                })
                .catch(function (error) {
                    res(error.data)
                });
            break;
            
        case 'DELETE':
            axios.delete(requestInfo.uri)
                .then(function (response) {
                    res(response.data)
                })
                .catch(function (error) {
                    res(error.data)
                });
            break;
        default:
            break;
    }
}

export default makeRequest;