import React, { Component } from 'react';

class HtmlToPdf extends Component {
  convertHtmlToPdf(e) {
    fetch('https://v2018.api2pdf.com/chrome/html', {
      method: 'post',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': '36d76f48-96c2-4dbc-9e2a-4197f04b2819'
      },
      body: JSON.stringify({html: '<p>Aqui va el form de compra para hacerlo luego generarlo en pdf</p>', inlinePdf: true, fileName: 'test.pdf' })
    }).then(res=>res.json())
      .then(res => console.log(res.pdf));
  }
  render() {
    return (
      <div className="App">
        <button onClick={this.convertHtmlToPdf.bind(this)}>Generar PDF</button>
      </div>
    );
  }
}
//otra forma de generar el PDF es generar toda la pagina en un pdf (como lo hace amazon con sus invoices)
//https://v2018.api2pdf.com/wkhtmltopdf/url?url='colocar aqui la direccion del la pagina a convertir a pdf'&apikey=36d76f48-96c2-4dbc-9e2a-4197f04b2819
//Lo que hace es convertir es pagina usando el api desde su origen, entonces le das la llave de acceso *(ya le puse la mia) y con te permite hacer get o post.
//La llave por si acaso: 36d76f48-96c2-4dbc-9e2a-4197f04b2819
export default HtmlToPdf; 