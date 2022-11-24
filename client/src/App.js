import React, { Component } from "react";
import getWeb3 from "./getWeb3";
import "./App.css";

const CONTRACT_ADDRESS = "0x66Ea97Ea1a0d7fE39499Ba81C9b2D79EbEad75fA"
const CONTRACT_ABI = require("./contracts/Reserva.json").abi;

class App extends Component {

  state = { entradasDisp: 0, total: 0, precio: 0, cancelado: false,web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the network ID
      const networkId = await web3.eth.net.getId();

      // Create the Smart Contract instance
      const instance = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);
      console.log(instance)

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { contract } = this.state;
    // Get the value from the contract to prove it worked.
    const disp = await contract.methods.getentradasdisponibles().call();
    const afor = await contract.methods.aforo().call();
    const pric = await contract.methods.getPrice().call();
    // Update state with the result.
    this.setState({ entradasDisp: disp, total: afor, precio: pric });
  };

  //TODO: set method to interact with Storage Smart Contract
  compra = async () =>{
    const { accounts, contract } = this.state;
    await contract.methods.compra().send({ from: accounts[0], value: this.state.value });
  }

  /*
  cancelar = async () =>{
    const { accounts, contract } = this.state;
    await contract.methods.cancelar();
  }
  withdraw = async () =>{
    const { accounts, contract } = this.state;
    await contract.methods.withdraw().send({ from: accounts[0], value: this.state.value });
  }
  sacarfondos = async () =>{
    const { accounts, contract } = this.state;
    await contract.methods.compra().send({ from: accounts[0], value: this.state.value });
  }
  

  //TODO: get function to interact with Storage Smart Contract
  getcancelar = async () =>{
    const { contract } = this.state;
    const actstate = await contract.methods.getactive().call();
    this.setState({ cancelado: actstate });
  }
  */

  render() {
    return (
      <div className="container">
        <div className="main">
          <div className="title">Dapp: Compra de entradas</div>
          <div className="wallet">{this.state.accounts}</div>
        </div>

        <div className="big-box">
          <div className="left-box">
            <div className="box-content">
              <div className="b-title">Aforo:</div> 
              <div className="b-cont">{this.state.total}</div>
            </div>
            <div className="box-content">
              <div className="b-title">Entradas disponibles:</div> 
              <div className="b-cont">{this.state.entradasDisp}</div>
            </div>
            <div className="box-content">
              <div className="b-title">Precio:</div> 
              <div className="b-cont">1 ether</div>
            </div>
          </div>
          <div className="right-box">
            <h1>Concierto de Miliki</h1>
            <div className="write">
              <input placeholder="Introduce el precio en wei" onChange={(e) => this.setState({ value: e.target.value })}></input>
              <button id="button-send" onClick={this.compra}>Comprar</button>
              <div className="ayuda">{/* Helper to convert wei to ether */}
                {this.state.value && <p>Estás pagando: {this.state.web3.utils.fromWei(this.state.value, 'ether')} ether</p>}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
