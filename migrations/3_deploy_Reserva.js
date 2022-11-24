var Reserva = artifacts.require("./Reserva.sol");

module.exports = function(deployer) {
  deployer.deploy(Reserva);
};