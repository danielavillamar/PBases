import React from 'react'; 
import { Provider } from 'react-redux';
import './admin.module.css'
// // import '../../bootstrap/bootstrap.css';
// import './pages.css';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

class Dashboard extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
            active: 1,
            search: ''
        };
        this.toggleClass= this.toggleClass.bind(this);
        this.searchHandler = this.searchHandler.bind(this);
    }
    toggleClass(i) {
    //   const currentState = this.state.active;
      this.setState({ active: i });
    };
    searchHandler(event){
      this.setState({ search: event.target.value})
    }
    
    render() {
        var state = this.state;
        var toggleClass = this.toggleClass;
        var searchHandler = this.searchHandler;
        var list_reports= [
            {name:'Area', link:'#'}, 
            {name:'Genre', link:'#'}, 
            {name:'Album by Artist', link:'#'}, 
            {name:'Long Songs', link:'#'}, 
            {name:'Users', link:'#'}, 
            {name:'Average', link:'#'}, 
            {name:'Recent Albums', link:'#'}, 
            {name:'Collaborative', link:'#'}, 
        ];
        // const { pathname } = this.props.location;
        return (
            <div className="dashboard" style={{
                overflow: 'auto'
              }}>
            <div className="dashboard-page ui-view"> 
              <div className="container-fluid"> 
                <div className="row"> 
                  <div className="col-sm-3 col-md-2 sideba"> 
                    <div className="text-center"> 
                      <h3 className="brand"><small>Admin Andreas</small></h3> 
                      <img alt="" src={process.env.PUBLIC_URL + '/avatar-user.png'} className="user-avatar" />
                      <br /> 
                      <a href="/login" className="btn btn-black btn-outline btn-rounded btn-sm">Logout</a> 
                    </div> 
                    <hr></hr>
                    <div className="">
                      <input className="form-control form-control" placeholder="Search User" onChange={(e) => searchHandler(e)}></input>
                    </div>
                    <hr></hr>
                    <h2 className=""><small>Reports by:</small></h2>
                    <ul className="list-grou nav flex-column nav-sidebar justify-content-start"> 
                    {list_reports.map(function(item, i){
                        return(<li key={i} className={( state.active === i) ? 'list-group-item active': ''} >
                            <a href={item.link} className="btn" onClick={() => toggleClass(i)}>{item.name}</a>
                        </li> 
                        )
                    })}
                    </ul> 
                  </div>
    
                  <div className="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 mai ui-view ng-enter-active">
                  {React.Children.map(this.props.content, child => {
                    return React.cloneElement(child, {searchText: state.search}, null);
                  })}
                  </div>
                </div> 
              </div> 
            </div>
          </div>
        );
    }
};

export default Dashboard