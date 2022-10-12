/**
 * @description       : Classe Apex qui contient 2 méthodes qui sérvent à:
 * 1- Création d'un nouveau contract
 * 2- Modification d'un contract
 * @author            : Ibaa Dhaybi
 * @last modified on  : 10-04-2022
**/
@RestResource(urlMapping='/ContractManager/v1/*')
global with sharing class ContractManager {
    
    @HttpPost
    global static Id createNewContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm) {
        
        // Création d’un nouveau contrat
        Contract thisContract = new Contract(
            Name = Name,
            Status = Status,
            AccountId = AccountId,
            StartDate = StartDate,
            ContractTerm = ContractTerm);
        
        insert thisContract;
        
        // Retourner l'Id du contrat
        return thisContract.Id;
    }
    
    @HttpPatch
    global static Id updateContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm){
        
        // Modification d’un contrat
        // Ajouter l'Id du Contrat comme un paramètre dans l'URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Parcourir Contract en se basant sur l'Id
        Contract result = [SELECT Id FROM Contract WHERE Id = :id];
        Contract thisContract = new Contract(); 
        thisContract.Id = id;  
        thisContract.Name = Name;
        thisContract.Status = Status;
        thisContract.AccountId = AccountId;
        thisContract.StartDate = StartDate;
        thisContract.ContractTerm = ContractTerm;
        
        // mettre à jour le contrat 
        update thisContract;
        
        // Retourner l'Id du contrat
        return thisContract.Id;
    }
}
