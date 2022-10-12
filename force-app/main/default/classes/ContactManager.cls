/**
 * @description       : Classe Apex qui contient 3 méthodes qui sérvent à:
 * 1- Insertion ou création (s'il n'existe pas) d'un nouveau contact
 * 2- Modification d'un contact
 * 3- Déactivation d'un contact
 * @author            : Ibaa Dhaybi
 * @last modified on  : 10-04-2022
**/
@RestResource(urlMapping='/ContactManager/v1/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static Id createNewContact(String FirstName, String LastName, String Phone, String Email) {
        
        //a- création d'un contact 
        
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email =: Email] ;
        
        // Vérifier si le contact existe déjà
        Contact ct = (contactList != null&&contactList.size()>0)?contactList[0]:null;
        if (ct != null) {

            return ct.Id;
        }
        
        // Condition si le contact existe
        else{
            
            // Création d'un nouveau Contact
            Contact newContact = new Contact(
                FirstName      = FirstName,
                LastName       = LastName,
                Phone          = Phone,
                Email          = Email);
            
            insert newContact;
            
            // Return l'Id du Contact
            return newContact.Id;
        }
    }

    @HttpPut
    global static Id updateContact(String FirstName, String LastName, String Phone, String Email){
        // b- Modification d’un contact
        // Ajouter l'Id du Contact comme un paramètre dans l'URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Parcourir Contact en se basant sur l'Id
        Contact result = [SELECT Id FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id;  
        thisContact.FirstName = FirstName;
        thisContact.LastName = LastName ;
        thisContact.Phone = Phone ;
        thisContact.Email = Email;
        
        // Mettre à jour
        update thisContact;
        
        // Retourner l'Id du Contact
        return thisContact.Id;
    }
    
    @HttpDelete
    global static Id deactivateContact(){
        // Suppression d’un contact
        // Ajouter l'Id du Contact comme un paramètre dans l'URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Parcourir la valeur du champs Deactivated__c
        Contact result = [SELECT Id, Deactivated__c FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id; 
        thisContact.Deactivated__c = true;  
        
        // mettre à jour le champs Deactivated__c 
        update thisContact;
        
        // Retourner l'Id du Contact
        return thisContact.Id;
    }
}
