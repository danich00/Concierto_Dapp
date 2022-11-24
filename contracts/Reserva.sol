// Version de solidity del Smart Contract
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

// Informacion del Smart Contract
// Nombre: Reserva
// Logica: Implementa subasta de productos entre varios participantes

// Declaracion del Smart Contract - Auction
contract Reserva {

    // ----------- Variables (datos) -----------
    // Información de la reserva
    string public description;
    uint public price;
    uint8 public totalentradas;
    uint8 public entradasdisponibles;
    uint fondostotales = address(this).balance;

    // Comprador de la reserva
    address payable public comprador;
    address payable public owner;
    address payable public contractaddress;

    // Estado de la reserva
    bool private completo;
    bool private cancelado;
    bool private terminado;
    
    // ----------- Eventos (pueden ser emitidos por el Smart Contract) -----------
    event AforoDisponible(string _message);
    event Status(string _message);

    //Mapping
    mapping (address => uint) pendingWithdrawals;

    // ----------- Constructor -----------
    // Uso: Inicializa el Smart Contract - Reserva
    constructor() {
        
        // Inicializo el valor a las variables (datos)
        description = "Concierto de miliki en la sala Sol el 25/03/2023";
        price = 1 ether;
        totalentradas = 100;
        entradasdisponibles = totalentradas;
        completo = false;
        owner = payable(msg.sender);
        contractaddress = payable(address(this));

        
        // Se emite un Evento
        emit Status("Concierto disponible");
    }
    
    // ------------ Funciones que modifican datos (set) ------------

    // Funcion
    // Nombre: compra
    // Uso:    Deja que el usuario envie fondos al contrato si se cumplen las conciciones
    function compra() public payable {
        if(entradasdisponibles > 0 && msg.value == price && !cancelado){
            comprador = payable(msg.sender);
            entradasdisponibles --;
                if(entradasdisponibles == 0){
                    completo == true;
                }
            if(pendingWithdrawals[msg.sender]>0){
                pendingWithdrawals[msg.sender]++;
            } else{
                pendingWithdrawals[msg.sender] = 1;
            }
            emit Status("Compra realizada con exito");
        } else {
            emit Status("Ya no hay entradas, no has introducido el precio adecuado, se ha cancelado o ya se ha realizado");
        }
    }

    // Funcion
    // Nombre: cancelar 
    // Uso:    se cancela el concierto y se pone en true para que los usuarios puedan sacar los fondos introducidos,
    //         solo puede cancelar el concierto el creador del contrato
    function cancelar() public {
        require(msg.sender == owner, "No eres el propietario");
        cancelado = true;
    }




    // Funcion
    // Nombre: withdraw 
    // Uso:    La función ejecuta la transferencia del contrato a la dirección del solicitante
    //         una vez cancelado el contrato los compradores que han pagado pueden retirar sus fondos
    function withdraw() public payable {
        require(cancelado, "El concierto sigue en pie");
        require(pendingWithdrawals[msg.sender]>0, "No tienes entrada para el concierto");
        uint totaldevolver = price * pendingWithdrawals[msg.sender];
        payable(msg.sender).transfer(totaldevolver);
    }



    // Funcion
    // Nombre: sacarfondos 
    // Uso:    Enviar los fondos del contrato al creador
    function sacarfondos() public {
        require(msg.sender == owner, "No eres el propietario");
        require(!cancelado, "El concierto se ha cancelado, solo los compradores pueden reclamar los fondos");
        require(!terminado, "El concierto ya se ha realizado y los fondos se han retirado");
        terminado = true;
        owner.transfer(address(this).balance);

    }

    // Funcion
    // Nombre: Entradas disponibles
    // Logica: Consulta las entradas disponibles del concierto
    function getentradasdisponibles() public view returns (uint8){
        return (entradasdisponibles);
    }


    function getactive() public view returns (bool){
        return (cancelado);
    }

    // Funcion
    // Nombre: Entradas disponibles
    // Logica: Consulta las entradas disponibles del concierto
    function aforo() public view returns (uint8){
        return (totalentradas);
    }
    
    // Funcion
    // Nombre: getPrice
    // Logica: Consulta el precio de la maxima puja
    function getPrice() public view returns (uint){
        return (price);
    }

}

