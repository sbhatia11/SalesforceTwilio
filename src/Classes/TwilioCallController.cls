public class TwilioCallController {
    public String status { get; set; }
    public String phoneNumber { get; set; }

    TwilioAccount account = TwilioAPI.getDefaultAccount();
    
    String myPhoneNumber = account.getIncomingPhoneNumbers().getPageData()[0].getPhoneNumber();

    //this will be for testing only.  no real texts will be sent.
    //String myPhoneNumber = '15005550006';     
    
    public PageReference makeCall() {
        Map<String, String> params = new Map<String, String>{
            'From' => myPhoneNumber,
            'To' => phoneNumber,
           // 'Url'  => 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient'
            'Url'  => 'http://twimlets.com/message?Message%5B0%5D=Thank%20You%20For%20Your%20Donation&'
        };

        try {
            TwilioCall call = account.getCalls().create(params);
            status = 'call made';
            //status = 'Sent SMS. SID: '+ sms.getSid() + sms.getstatus() + '\n' + ' From Phone: ' + myPhoneNumber + '\n' + ' To Phone: ' + PhoneNumber  + '\n' + ' Message: ' + message;
        } catch (Exception e) {
            status = 'call not made';
            //status = 'Exception: '+ e.getMessage() + '\n'  + '\n From Phone: ' + myPhoneNumber  + '\n' + ' To Phone: ' + PhoneNumber  + '\n' + ' Message: ' + message;

        }


        //format the text to before we search for a match.
        String areaCode = phoneNumber.substring(2,5);
        String prefix = phoneNumber.substring(5,8);
        String last4 = phoneNumber.substring(8);
        String formattedPhone = '(' + areaCode +')' + ' ' + prefix + '-' + last4;

        
        // now, use the formatted phone to find the contact who has this phone number.
        List <Contact> contactList = [SELECT Id, FirstName, LastName
                                         FROM Contact
                                         WHERE MobilePhone =: formattedPhone limit 1];
 
        // if we find a contact for this phone number, then create the task related to that contact.
        if(contactList.size() > 0)
        {
            for (Contact contact : contactList)
            {
               
                // Create a new Task to record the outbound call, then attach it to the appropriate Contact
                Task text = new Task();
                text.Subject = 'called ' + formattedPhone;
                text.WhoId = contact.Id;
                text.Status = 'Completed';
                text.Type = 'Outbound call';
 
                try
                {
                   insert text;
                }
                catch(DmlException e)
                {
                  System.debug('INSERT TASK FAILED: ' + e);
                }
            }
        }

        phoneNumber = null;

        return null;
    }
}
