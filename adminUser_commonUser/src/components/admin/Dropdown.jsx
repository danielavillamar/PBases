import React from 'react';
import './styleDropdown.css'; 


class Dropdown extends React.Component {
constructor(){
 super();

 this.state = {
       displayMenu: false,
     };

  this.showDropdownMenu = this.showDropdownMenu.bind(this);
  this.hideDropdownMenu = this.hideDropdownMenu.bind(this);

};

showDropdownMenu(event) {
    event.preventDefault();
    this.setState({ displayMenu: true }, () => {
    document.addEventListener('click', this.hideDropdownMenu);
    });
  }

  hideDropdownMenu() {
    this.setState({ displayMenu: false }, () => {
      document.removeEventListener('click', this.hideDropdownMenu);
    });

  }

  render() {
    return (
        <div  className="dp dropdown" style = {{width:"10px"}} >
         <div className="dp button text-center" onClick={this.showDropdownMenu}><img style={{width: '40px'}} src={process.env.PUBLIC_URL + '/dot-icon.svg'}></img></div>

          { this.state.displayMenu ? (
          <ul>
         <li><a className="active" href="#Block User">Block User</a></li>
          </ul>
        ):
        (
          null
        )
        }

       </div>

    );
  }
}

export default Dropdown;