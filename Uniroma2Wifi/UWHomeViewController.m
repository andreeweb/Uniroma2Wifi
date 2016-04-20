//
//  UWHomeViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 03/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWHomeViewController.h"

@interface UWHomeViewController ()

@end

@implementation UWHomeViewController
@synthesize spinner, buttonConnect, socialView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nascondo le icone social su iPhone 4 per questioni di spazio
    if(IS_IPHONE_4_AND_OLDER)
        [socialView setHidden:YES];
    
    //titolo della vista
    [self setTitle:@"Uniroma2 Wi-Fi"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Connessione
- (IBAction)doConnectionAction:(id)sender
{    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    //Get the dictionary containing the captive network infomation
    CFDictionaryRef captiveNtwrkDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    
    //NSLog(@"Information of the network we're connected to: %@", captiveNtwrkDict);
    
    NSDictionary *dict = (__bridge NSDictionary*) captiveNtwrkDict;
    NSString* SSID = [dict objectForKey:@"SSID"];
    
    //verifico se si è collegati alla rete giusta
    if ([SSID isEqualToString:@"uniroma2-cp-NG"]) {
        
        //verifico se si è già connessi
        [self testInternetConnection];
        
    }else{
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Non sei collegato"
                                                       description:@"Per favore vai in Impostazioni -> Wifi e collegati alla rete uniroma2-cp-NG"
                                                              type:TWMessageBarMessageTypeError];
    }
}

- (void) testInternetConnection
{
    
    NSLog(@"TEST CONNECTION");
    [self startSpinner];
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://captive.apple.com"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    testConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (!testConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        // Inform the user that the connection failed.
        [self stopSpinner];
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Errore di rete."
                                                       description:@"Riprova per favore, oppure contatta il supporto."
                                                              type:TWMessageBarMessageTypeError];
        
    }
}

- (void) verifyConnection
{
    NSLog(@"VERIFICO CONNECTION");
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://captive.apple.com"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    verifyConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (!verifyConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        // Inform the user that the connection failed.
        [self stopSpinner];
        
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Errore di rete."
                                                       description:@"Riprova per favore, oppure contatta il supporto."
                                                              type:TWMessageBarMessageTypeError];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    testConnection = nil;
    receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Errore di rete."
                                                   description:@"Riprova per favore, oppure contatta il supporto."
                                                          type:TWMessageBarMessageTypeError];
    
    [self stopSpinner];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    
    if (connection == testConnection){
        
        if ([responseString isEqualToString:TEST]){
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Informazione"
                                                           description:@"Sei già connesso alla rete!"
                                                                  type:TWMessageBarMessageTypeInfo];
            
            [self stopSpinner];
            
        }else{
            
            NSLog(@"CONNETTO ALLA CAPTIVE");
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UniWifi" accessGroup:nil];
            NSString *matricola = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
            NSString *password = [wrapper objectForKey:(__bridge id)(kSecValueData)];
            
            // In body data for the 'application/x-www-form-urlencoded' content type,
            // form fields are separated by an ampersand. Note the absence of a
            // leading ampersand.
            NSString *bodyData = [NSString stringWithFormat:@"user=%@&password=%@",matricola,password];
            //NSLog(@"%@",bodyData);
            
            // Create the request.
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://securelogin.arubanetworks.com/cgi-bin/login"]];
            
            // Set the request's content type to application/x-www-form-urlencoded
            [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            // Designate the request a POST request and specify its body data
            [postRequest setHTTPMethod:@"POST"];
            [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
            
            // create the connection with the request
            // and start loading the data
            connectToCaptive = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
            if (!connectToCaptive) {
                // Inform the user that the connection failed.
                NSLog(@"Fallito");
                [self stopSpinner];
                
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Errore"
                                                               description:@"Controlla il collegamento alla rete wifi e verifica le tue credenziali."
                                                                      type:TWMessageBarMessageTypeError];
            }
        }
    
    }else if (connection == verifyConnection){
        
        [self stopSpinner];
        
        if ([responseString isEqualToString:TEST]){
            
            NSLog(@"Connesso");
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Fatto!"
                                                           description:@"Connessione effettuata."
                                                                  type:TWMessageBarMessageTypeSuccess];
            
        }else{
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Errore"
                                                           description:@"Controlla il collegamento alla rete wifi e verifica le tue credenziali."
                                                                  type:TWMessageBarMessageTypeError];
        }
    
    }else if (connection == connectToCaptive){
        
        [self performSelector:@selector(verifyConnection) withObject:self afterDelay:2];
    }
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    testConnection = nil;
    receivedData = nil;
}

//Sent to determine whether the delegate is able to respond to a protection space’s form of authentication.
//YES if the delegate if able to respond to a protection space’s form of authentication, otherwise NO.
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSString * challenge = [protectionSpace authenticationMethod];
    if ([challenge isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        return YES;
    }
    
    return NO;
}

/* Look to see if we can handle the challenge */
- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    // I had a crt certificate, needed a der one, so found this site:
    // http://fixunix.com/openssl/537621-re-der-crt-file-conversion.html
    // and did this from Terminal: openssl x509 -in crt.crt -outform der -out crt.der
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uniroma2" ofType:@"der"];
    assert(path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    assert(data);
    
    /* Set up the array of certs we will authenticate against and create cred */
    SecCertificateRef rootcert = SecCertificateCreateWithData(NULL, CFBridgingRetain(data));
    const void *array[1] = { rootcert };
    CFArrayRef certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
    CFRelease(rootcert);    // for completeness, really does not matter
    
    NSLog(@"didReceiveAuthenticationChallenge %@ FAILURES=%d", [[challenge protectionSpace] authenticationMethod], (int)[challenge previousFailureCount]);
    
    /* Setup */
    NSURLProtectionSpace *protectionSpace   = [challenge protectionSpace];
    assert(protectionSpace);
    SecTrustRef trust                       = [protectionSpace serverTrust];
    assert(trust);
    CFRetain(trust);  // Make sure this thing stays around until we're done with it
    NSURLCredential *credential             = [NSURLCredential credentialForTrust:trust];
    
    /* Build up the trust anchor using our root cert */
    
    int err;
    SecTrustResultType trustResult = 0;
    err = SecTrustSetAnchorCertificates(trust, certs);
    if (err == noErr) {
        err = SecTrustEvaluate(trust,&trustResult);
    }
    CFRelease(trust);  // OK, now we're done with it
    
    // http://developer.apple.com/library/mac/#qa/qa1360/_index.html
    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
    
    // Return based on whether we decided to trust or not
    if (trusted) {
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        NSLog(@"Trust evaluation failed for service root certificate");
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void) startSpinner
{
    [spinner startAnimating];
    [buttonConnect setUserInteractionEnabled:NO];
    [buttonConnect setTitle:@"" forState:UIControlStateNormal];
}

- (void) stopSpinner
{
    [spinner stopAnimating];
    [buttonConnect setUserInteractionEnabled:YES];
    [buttonConnect setTitle:@"Connetti" forState:UIControlStateNormal];
}

#pragma mark - Social

- (IBAction)twitterButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=uniroma2wifi"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=uniroma2wifi"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/uniroma2wifi"]];
    
}

- (IBAction)facebookButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://profile/440789046053535"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/440789046053535"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://it-it.facebook.com/Uniroma2WiFi"]];
}

- (IBAction)gplusButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"gplus://plus.google.com/106244358985510458585"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gplus://plus.google.com/106244358985510458585"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/106244358985510458585"]];
}

@end
