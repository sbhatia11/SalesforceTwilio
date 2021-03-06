public class TwilioPageController {
    public String status { get; set; }
    public String message { get; set; }
    public String phoneNumber { get; set; }

    TwilioAccount account = TwilioAPI.getDefaultAccount();
    
    String myPhoneNumber = 
    account.getIncomingPhoneNumbers().getPageData()[0].getPhoneNumber();

    //String myPhoneNumber = '15005550006';     
    
    public PageReference sendSMS() {
        Map<String, String> params = new Map<String, String>{
            'From' => myPhoneNumber,
            'To' => phoneNumber,
            'Body' => message
        };

        try {
            TwilioSms sms = account.getSmsMessages().create(params);
            status = 'Sent SMS. SID: '+ sms.getSid() + sms.getstatus() + '\n' + ' From Phone: ' + myPhoneNumber + '\n' + ' To Phone: ' + PhoneNumber  + '\n' + ' Message: ' + message;
        } catch (Exception e) {
            status = 'Exception: '+ e.getMessage() + '\n'  + '\n From Phone: ' + myPhoneNumber  + '\n' + ' To Phone: ' + PhoneNumber  + '\n' + ' Message: ' + message;
        }

        phoneNumber = null;
        message = null;

        return null;
    }
}
