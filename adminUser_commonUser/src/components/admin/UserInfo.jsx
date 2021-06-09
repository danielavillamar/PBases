import React from 'react'; 
import { Provider } from 'react-redux';
import ToggleButton from 'react-toggle-button'
import './UserInfo.css';
import { Button, Input, ButtonDropdown, DropdownItem } from 'reactstrap';
import Dropdown from './Dropdown';

class UserInfo extends React.Component{
    constructor(props) {
		super(props);
		console.log(props);
        this.state = {
			search: '',
			addMusic: true,
			changeMusic: true,
			blockMusic: false
		};
		this.AddtoggleHandler = this.AddtoggleHandler.bind(this);
		this.ChangetoggleHandler = this.ChangetoggleHandler.bind(this);
		this.BlocktoggleHandler = this.BlocktoggleHandler.bind(this);
	}
	componentDidMount(){
	}
	AddtoggleHandler(event){
		var addMusic = this.state.addMusic;
		this.setState({
			addMusic: !addMusic,
		})
	}
	ChangetoggleHandler(event){
		var changeMusic = this.state.changeMusic;
		this.setState({
			changeMusic: !changeMusic,
		})
	}
	BlocktoggleHandler(event){
		var blockMusic = this.state.blockMusic;
		this.setState({
			blockMusic: !blockMusic,
		})
	}
	
    render() {
		const {search, addMusic, changeMusic, blockMusic} = this.state;
		var AddtoggleHandler = this.AddtoggleHandler;
		var ChangetoggleHandler = this.ChangetoggleHandler;
		var BlocktoggleHandler = this.BlocktoggleHandler;
        var list_users= [
            {id: 1, name:'Andres Quinto', link:'#', img: 'https://scontent-mia3-1.xx.fbcdn.net/v/t1.0-9/87456612_2746584878710861_8020331240315944960_o.jpg?_nc_cat=104&_nc_sid=174925&_nc_oc=AQn5LKvMXbI8LZNp1eUUfnLoDdEAM4osj9MX8rFN7cdy3fc9K-upPdwwaAgKBCmlX9E&_nc_ht=scontent-mia3-1.xx&oh=a63b4fe7e351649c8867b019f923be80&oe=5EA11195'}, 
            {id: 2, name:'Mirka Monzon', link:'#', img: 'https://scontent.fgua3-2.fna.fbcdn.net/v/t1.0-9/42889964_2217162618356577_5662918859426889728_o.jpg?_nc_cat=103&_nc_sid=09cbfe&_nc_oc=AQkXplAk98ycWgxSbtnT_o8OAQ7Sv76tRRJtdZTBUv7PD5SQa9Z-hRaM0h6ZuuELte8&_nc_ht=scontent.fgua3-2.fna&oh=31ec5bad26d95d555e8632ba19047432&oe=5EA0656B'}, 
            {id: 3, name:'Daniela Villamar', link:'#', img: 'https://scontent-mia3-1.xx.fbcdn.net/v/t31.0-8/17547078_1421785984551188_7353318571981150256_o.jpg?_nc_cat=108&_nc_sid=09cbfe&_nc_oc=AQkOs_N-fiPVYR6ctTTVLZUfknUpilkuA45uzCxEzmI1O7gG-bespJdLV-Q4aSm_q94&_nc_ht=scontent-mia3-1.xx&oh=fd3e00f91f31a98b6400cb367052bd4e&oe=5EA1A53C'}, 
            {id: 4, name:'Paulina Perez', link:'#', img: 'https://randomuser.me/api/portraits/women/84.jpg'}, 
            {id: 5, name:'Mariana Aguirre', link:'#', img: 'https://randomuser.me/api/portraits/men/32.jpg'}, 
        ];
        // const { pathname } = this.props.location;
        return (
            <div className="reports">
			<div key="reports" className="row reports-page ui-view main" style={styles}>
				<div className="col"> 
					<a href="/user" className="pull-right btn btn-outline-secondary btn-outline btn-rounded">Back to User Mode</a> 
					<h2>Reports</h2> 

					<i className="fa fa-dashboard bg-fade"></i>
					{list_users.filter((list) => {return (list.name.toLowerCase().includes(this.props.searchText.toLowerCase()) || !this.props.searchText)}).map(function(item, i){
                        return(
					<div key={item.id} className="jumbotron media"> 
						<img src={item.img} className="align-self-center mr-3" alt="..." style={{maxHeight: '150px'}} />
						<div className="media-body">
						<h5 className="mt-0">{i+1}. {item.name} 
							<span className='float-right'>
								<Dropdown></Dropdown>
							</span>
						</h5>
						<hr></hr>
						<div className="ml-4 text-cente row align-self-end">
							<div className="col-7"> Roles:</div>
							<div className="col-4"><Input className="" value="Common User" onChange={() => {}}></Input> <Button className="btn-sm float-right">Modify</Button></div>
						</div>
						<hr></hr>
						<div className="ml-4 row">
							<div className="col"> Permissions:</div>
							<div className="col-5"> 
								<div className="row">
									<div className="col-6">Add Music:</div>
									<div className="col-6">
										<ToggleButton
											value={ addMusic || false }
											thumbStyle={{ borderRadius: 2 }}
											trackStyle={{ borderRadius: 2 }}
											onToggle={(value) => {
												AddtoggleHandler(value)
											}} />
										
									</div>
								</div>
								<div className="row">
									<div className="col-6">Change Music:</div>
									<div className="col-6">
										<ToggleButton
											value={ changeMusic || false }
											thumbStyle={{ borderRadius: 2 }}
											trackStyle={{ borderRadius: 2 }}
											onToggle={(value) => {
												ChangetoggleHandler(value)
											}} />
										
									</div>
								</div>
								<div className="row">
									<div className="col-6">Block Music:</div>
									<div className="col-6">
										<ToggleButton
											value={ blockMusic || false }
											thumbStyle={{ borderRadius: 2 }}
											trackStyle={{ borderRadius: 2 }}
											onToggle={(value) => {
												BlocktoggleHandler(value)
											}} />
										
									</div>
								</div>
							</div>
						</div>
							{/* EMPTY */}
						</div>
					</div> 
                        )
                    })}
				</div>
			</div>
		</div>
        );
    }
};

var styles = {
	width: '-webkit-fill-available'
}

export default UserInfo