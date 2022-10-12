/**
 * @description       : Classe de test de la classe ContactManager
 * @author            : Ibaa Dhaybi
 * @last modified on  : 10-12-2022
**/
@isTest
private class ContactManagerTest {
    @TestSetup
    static void createNewContact(){
        //Appeller de la méthode à tester
        Id thisContactId = ContactManager.createNewContact('Toto', 'Test', '0167678678', 'tototest@gmail.com');
    }
    @isTest 
    static void testCreateNewContact() {
        test.startTest();
        // parcourir l'Id et Email du Contact créé
        Contact thisContact = [SELECT Id, Email FROM Contact LIMIT 1];
        test.stopTest();
        //vérifier que le contact est bien créé
        System.assertEquals(thisContact.Email, 'tototest@gmail.com');
    }
    @isTest static void testUpdateContact() {
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/apexrest/ContactManager/v1/' + recordId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone":"0198981981"}');
        RestContext.request = request;
        // Appeller la méthode à tester
        Id thisContactId = ContactManager.updateContact('Toto', 'Test','0198981981' ,'tototest@gmail.com');
        Contact thisContact = [SELECT Id, Phone FROM Contact WHERE Id=:thisContactId];
        //vérifier que le contact est bien mis à jour
        System.assertEquals(thisContact.Phone, '0198981981');    
    }
    @isTest static void testDeactivateContact() {
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI =  'https://my.salesforce.com/apexrest/ContactService/v1/' + recordId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Deactivated__c" : "true"}');
        RestContext.request = request;
        // Appeller la méthode à tester
        Id thisContactId = ContactManager.deactivateContact();
        Contact thisContact = [SELECT Id, Deactivated__c FROM Contact WHERE Id =:thisContactId];
        //vérifier que le contact est bien déactiver 
        System.assertEquals(thisContact.Deactivated__c, true);
    }        
}
