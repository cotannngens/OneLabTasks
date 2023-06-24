import Contacts

class ContactsManager {
    static let shared = ContactsManager()
    let contactStore = CNContactStore()
    
    private init() {}
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                print("Error requesting access to contacts: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }
    
    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        var contacts = [CNContact]()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                    contacts.append(contact)
                })
                DispatchQueue.main.async {
                    completion(contacts)
                }
            } catch {
                print("Error fetching contacts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func addContact(givenName: String, familyName: String, phoneNumber: String) {
        let newContact = CNMutableContact()
        newContact.givenName = givenName
        newContact.familyName = familyName
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phoneNumber))
        newContact.phoneNumbers = [homePhone]
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        do {
            try contactStore.execute(saveRequest)
        } catch {
            print("Error saving contact: \(error.localizedDescription)")
        }
    }
}
