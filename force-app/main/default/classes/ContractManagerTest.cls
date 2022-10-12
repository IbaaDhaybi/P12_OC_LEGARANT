/**
 * @description       : Classe de test de la classe ContractManager
 * @author            : Ibaa Dhaybi 
 * @last modified on  : 10-12-2022
**/
@isTest
private class ContractManagerTest {
    @isTest 
    static void CreateNewContractTest() {
        // création d'un Account
        Account account = new Account();
        account.Name ='AccountTest';
        insert account;
        //Appeller de la méthode à tester et ajouter les paramètres
        Id thisContractId = ContractManager.createNewContract('Test','Draft',account.Id,Date.valueOf('2022-12-12'),6);
        Contract thisContract = [SELECT Id, ContractTerm, Status FROM Contract WHERE Id =:thisContractId];
        // Vérifier que le contrat est bien créé
        System.assertEquals(thisContract.ContractTerm, 6);
        System.assertEquals(thisContract.Status, 'Draft');

    }

    @isTest 
    static void testUpdateContract(){
        
        // Set up d'un test request
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/ContractManager/v1/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status":"Activated"}');
        RestContext.request = request;
        
        // Parcourire les champs du contrat créé
        Contract ctc = [SELECT Name ,AccountId, StartDate, ContractTerm FROM Contract WHERE Id =: recordId];
        
        // mettre à jour le status de l'enregistrement
        Id thisContractId = ContractManager.updateContract(ctc.Name, 'Activated', ctc.AccountId, ctc.StartDate , ctc.ContractTerm);
        
        // Parcourir l'Id et Status du Contract mis à jour
        Contract thisContract = [SELECT Id, Status FROM Contract WHERE Id=:thisContractId];

        // Verifier que le statut est bien mis à jour
        System.assertEquals(thisContract.Status, 'Activated'); 
    }
    
    // Helper method
    static Id CreateTestRecord(){
        // Créer un Account test
        Account accountTest = new Account();
        accountTest.Name ='TestAccount';
        insert accountTest;
        
        // Créer un contrat test 
        Contract contractTest = new Contract(
            Name = 'TestContract',
            Status = 'Draft',
            AccountId = accountTest.Id,
            StartDate = Date.valueOf('2022-12-12'),
            ContractTerm = 5
        );
        insert contractTest;
        return contractTest.Id;
    }
}
