/*
 * iPhoneConfig.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class iPhoneConfigApplication, iPhoneConfigDocument, iPhoneConfigWindow, iPhoneConfigConfigurationProfile, iPhoneConfigPayload, iPhoneConfigAccessPointPayload, iPhoneConfigCredentialsPayload, iPhoneConfigEmailPayload, iPhoneConfigExchangeActiveSyncPayload, iPhoneConfigPasscodePayload, iPhoneConfigRestrictionsPayload, iPhoneConfigVPNPayload, iPhoneConfigVPNOnDemand, iPhoneConfigWiFiPayload, iPhoneConfigTrustedServerCertificate, iPhoneConfigLDAPPayload, iPhoneConfigLDAPSearchSetting, iPhoneConfigCalDAVPayload, iPhoneConfigSubscribedCalendarPayload, iPhoneConfigWebClipPayload, iPhoneConfigSCEPPayload, iPhoneConfigMdmPayload;

enum iPhoneConfigSaveOptions {
	iPhoneConfigSaveOptionsYes = 'yes ' /* Save the file. */,
	iPhoneConfigSaveOptionsNo = 'no  ' /* Do not save the file. */,
	iPhoneConfigSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum iPhoneConfigSaveOptions iPhoneConfigSaveOptions;

enum iPhoneConfigPrintingErrorHandling {
	iPhoneConfigPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	iPhoneConfigPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum iPhoneConfigPrintingErrorHandling iPhoneConfigPrintingErrorHandling;

enum iPhoneConfigConfigurationProfileSecurityType {
	iPhoneConfigConfigurationProfileSecurityTypeNever = 'stno',
	iPhoneConfigConfigurationProfileSecurityTypeAlways = 'stal',
	iPhoneConfigConfigurationProfileSecurityTypeAuthorization = 'stau'
};
typedef enum iPhoneConfigConfigurationProfileSecurityType iPhoneConfigConfigurationProfileSecurityType;

enum iPhoneConfigSecurityTypes {
	iPhoneConfigSecurityTypesNone = 'none',
	iPhoneConfigSecurityTypesWEP = 'wepp',
	iPhoneConfigSecurityTypesWPA = 'wpap',
	iPhoneConfigSecurityTypesAnyPersonal = 'anyp',
	iPhoneConfigSecurityTypesWEPEnterprise = 'wepe',
	iPhoneConfigSecurityTypesWPAEnterprise = 'wpae',
	iPhoneConfigSecurityTypesAnyEnterprise = 'anye'
};
typedef enum iPhoneConfigSecurityTypes iPhoneConfigSecurityTypes;

enum iPhoneConfigInnerAuthentications {
	iPhoneConfigInnerAuthenticationsPAP = 'pap ',
	iPhoneConfigInnerAuthenticationsCHAP = 'chap',
	iPhoneConfigInnerAuthenticationsMSCHAP = 'msch',
	iPhoneConfigInnerAuthenticationsMSCHAPv2 = 'msc2'
};
typedef enum iPhoneConfigInnerAuthentications iPhoneConfigInnerAuthentications;

enum iPhoneConfigVPNConnectionTypes {
	iPhoneConfigVPNConnectionTypesL2TP = 'l2tp',
	iPhoneConfigVPNConnectionTypesPPTP = 'pptp',
	iPhoneConfigVPNConnectionTypesIPsecCisco = 'ipse',
	iPhoneConfigVPNConnectionTypesCiscoAnyConnect = 'ciac',
	iPhoneConfigVPNConnectionTypesJuniperSSL = 'jssl',
	iPhoneConfigVPNConnectionTypesF5SSL = 'fssl'
};
typedef enum iPhoneConfigVPNConnectionTypes iPhoneConfigVPNConnectionTypes;

enum iPhoneConfigVPNMachineAuthenticationTypes {
	iPhoneConfigVPNMachineAuthenticationTypesSharedSecretAuthentication = 'mats',
	iPhoneConfigVPNMachineAuthenticationTypesCertificateAuthentication = 'matc'
};
typedef enum iPhoneConfigVPNMachineAuthenticationTypes iPhoneConfigVPNMachineAuthenticationTypes;

enum iPhoneConfigVPNProxyTypes {
	iPhoneConfigVPNProxyTypesNone = 'prxn',
	iPhoneConfigVPNProxyTypesAutomatic = 'prxa',
	iPhoneConfigVPNProxyTypesManual = 'prxm'
};
typedef enum iPhoneConfigVPNProxyTypes iPhoneConfigVPNProxyTypes;

enum iPhoneConfigVPNUserAuthentications {
	iPhoneConfigVPNUserAuthenticationsPasswordAuthentication = 'pswd',
	iPhoneConfigVPNUserAuthenticationsRSASecurIDAuthentication = 'rsai'
};
typedef enum iPhoneConfigVPNUserAuthentications iPhoneConfigVPNUserAuthentications;

enum iPhoneConfigVPNEncryptionLevels {
	iPhoneConfigVPNEncryptionLevelsNoEncryption = 'none',
	iPhoneConfigVPNEncryptionLevelsAutomaticEncryption = 'auto',
	iPhoneConfigVPNEncryptionLevelsMaximumEncryption = 'm128'
};
typedef enum iPhoneConfigVPNEncryptionLevels iPhoneConfigVPNEncryptionLevels;

enum iPhoneConfigVPNOnDemandActions {
	iPhoneConfigVPNOnDemandActionsAlwaysEstablish = 'ales',
	iPhoneConfigVPNOnDemandActionsNeverEstablish = 'nees',
	iPhoneConfigVPNOnDemandActionsEstablishIfNeeded = 'ifes'
};
typedef enum iPhoneConfigVPNOnDemandActions iPhoneConfigVPNOnDemandActions;

enum iPhoneConfigEmailAccountProtocols {
	iPhoneConfigEmailAccountProtocolsIMAP = 'imap',
	iPhoneConfigEmailAccountProtocolsPOP = 'pop '
};
typedef enum iPhoneConfigEmailAccountProtocols iPhoneConfigEmailAccountProtocols;

enum iPhoneConfigPasscodeGracePeriods {
	iPhoneConfigPasscodeGracePeriodsNoGracePeriod = '0mgc',
	iPhoneConfigPasscodeGracePeriodsOneMinute = '1mgc',
	iPhoneConfigPasscodeGracePeriodsFiveMinutes = '5mgc',
	iPhoneConfigPasscodeGracePeriodsFifteenMinutes = '15gc',
	iPhoneConfigPasscodeGracePeriodsOneHour = '1hgc',
	iPhoneConfigPasscodeGracePeriodsFourHours = '4hgc'
};
typedef enum iPhoneConfigPasscodeGracePeriods iPhoneConfigPasscodeGracePeriods;

enum iPhoneConfigSafariAcceptCookiesType {
	iPhoneConfigSafariAcceptCookiesTypeNeverAcceptCookies = 'sacn',
	iPhoneConfigSafariAcceptCookiesTypeAcceptWhenVisited = 'sacw',
	iPhoneConfigSafariAcceptCookiesTypeAlwaysAcceptCookies = 'saca'
};
typedef enum iPhoneConfigSafariAcceptCookiesType iPhoneConfigSafariAcceptCookiesType;

enum iPhoneConfigParentalControlsRegionType {
	iPhoneConfigParentalControlsRegionTypeUs = 'pcus',
	iPhoneConfigParentalControlsRegionTypeAu = 'pcau',
	iPhoneConfigParentalControlsRegionTypeCa = 'pcca',
	iPhoneConfigParentalControlsRegionTypeDe = 'pcde',
	iPhoneConfigParentalControlsRegionTypeFr = 'pcfr',
	iPhoneConfigParentalControlsRegionTypeIe = 'pcie',
	iPhoneConfigParentalControlsRegionTypeJp = 'pcjp',
	iPhoneConfigParentalControlsRegionTypeNz = 'pcnz',
	iPhoneConfigParentalControlsRegionTypeGb = 'pcgb'
};
typedef enum iPhoneConfigParentalControlsRegionType iPhoneConfigParentalControlsRegionType;



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface iPhoneConfigApplication : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(iPhoneConfigSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.

@end

// A document.
@interface iPhoneConfigDocument : SBObject

@property (copy, readonly) NSString *name;  // Its name.
@property (readonly) BOOL modified;  // Has it been modified since the last save?
@property (copy, readonly) NSURL *file;  // Its location on disk, if it has one.

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// A window.
@interface iPhoneConfigWindow : SBObject

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?
@property (copy, readonly) iPhoneConfigDocument *document;  // The document whose contents are displayed in the window.

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end



/*
 * iPhone Configuration Suite
 */

@interface iPhoneConfigApplication (IPhoneConfigurationSuite)

- (SBElementArray *) configurationProfiles;

@end

// 
@interface iPhoneConfigConfigurationProfile : SBObject

- (SBElementArray *) accessPointPayloads;
- (SBElementArray *) credentialsPayloads;
- (SBElementArray *) emailPayloads;
- (SBElementArray *) ExchangeActiveSyncPayloads;
- (SBElementArray *) passcodePayloads;
- (SBElementArray *) restrictionsPayloads;
- (SBElementArray *) VPNPayloads;
- (SBElementArray *) WiFiPayloads;
- (SBElementArray *) LDAPPayloads;
- (SBElementArray *) CalDAVPayloads;
- (SBElementArray *) subscribedCalendarPayloads;
- (SBElementArray *) webClipPayloads;
- (SBElementArray *) mdmPayloads;
- (SBElementArray *) SCEPPayloads;
- (SBElementArray *) payloads;

@property (copy) NSString *displayedName;  // the displayed name of this payload
@property (copy) NSString *objectDescription;  // a description of this configuration profile and its purpose
@property (copy) NSString *profileIdentifier;  // The unique identifier for this profile
@property iPhoneConfigConfigurationProfileSecurityType removable;  // how is the profile removable once it has been installed on a device
@property (copy) NSString *removalPassword;  // password used to authorize configuration profile removal from the device
- (NSString *) id;  // the unique identifier of this configuration profile
@property (copy) NSString *organization;  // the organization issuing this configuration profile
@property (readonly) NSInteger version;  // the version of this configuration profile

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.
- (void) exportTo:(NSString *)to;  // Export a document

@end

// 
@interface iPhoneConfigPayload : SBObject

@property (copy) NSString *name;  // the name of this configuration
- (NSString *) id;  // the unique identifier of this configuration
- (void) setId: (NSString *) id;

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// 
@interface iPhoneConfigAccessPointPayload : iPhoneConfigPayload

@property (copy) NSString *accessPointName;  // the access point name to connect to the access point
@property (copy) NSString *password;  // the password to connect to the access point
@property (copy) NSString *userName;  // the user name to connect to the access point
@property (copy) NSString *proxyServer;  // the hostname or IP address for the proxy server
@property NSInteger proxyServerPort;  // the port number for the proxy server


@end

// 
@interface iPhoneConfigCredentialsPayload : iPhoneConfigPayload

@property (copy) NSString *filename;  // Absolute path of the credential


@end

// 
@interface iPhoneConfigEmailPayload : iPhoneConfigPayload

@property (copy) NSString *accountDescription;  // the display name of the account (e.g. "Company Mail Account")
@property iPhoneConfigEmailAccountProtocols accountProtocol;  // the protocol for accessing the email account
@property (copy) NSString *IMAPPathPrefix;  // the path prefix for the IMAP account
@property (copy) NSString *accountName;  // the name of the account (e.g. "John Appleseed")
@property (copy) NSString *emailAddress;  // the address of the account (e.g. "john@company.com")
@property BOOL useIncomingPasswordWhenSendingMail;  // Use the POP/IMAP password for SMTP authentication?
@property (copy) NSString *incomingServerHostname;  // the hostname or IP address for incoming mail
@property NSInteger incomingServerPort;  // the port number for incoming mail
@property (copy) NSString *incomingServerUsername;  // the username used to connect to the server for incoming mail
@property (copy) NSString *incomingServerPassword;  // the password for the incoming mail server
@property BOOL incomingServerUsesPasswordAuthentication;  // Should the incoming server authenticate using a password (will prompt user)?
@property BOOL incomingServerUsesSSL;  // Send incoming mail through a secure socket layer?
@property (copy) NSString *outgoingServerHostname;  // the hostname or IP address for outgoing mail
@property NSInteger outgoingServerPort;  // the port number for outgoing mail
@property (copy) NSString *outgoingServerUsername;  // the username used to connect to the server for outgoing mail
@property (copy) NSString *outgoingServerPassword;  // the password for the outgoing mail server
@property BOOL outgoingServerUsesPasswordAuthentication;  // Should the outgoing server authenticate using a password (will prompt user)?
@property BOOL outgoingServerUsesSSL;  // Send outgoing mail through through a secure socket layer?


@end

// 
@interface iPhoneConfigExchangeActiveSyncPayload : iPhoneConfigPayload

@property (copy) NSString *accountName;  // the name for the Exchange ActiveSync account
@property (copy) NSString *hostname;  // the name for the Microsoft Exchange Server
@property BOOL useSSL;  // Send all communication through a secure socket layer?
@property (copy) NSString *windowsDomain;  // the domain for the account - both domain and user name must be unspecified for the device to prompt for the user name
@property (copy) NSString *emailAddress;  // the address of the account (e.g. "john@company.com")
@property (copy) NSString *userName;  // the user for the account - both domain and user name must be unspecified for the device to prompt for the user name
@property (copy) NSString *password;  // the password for the account (e.g. "MyP4ssw0rd!")
@property (copy) NSString *credentialPassphrase;  // the passphrase of the credential
@property (copy) NSString *credentialCommonName;  // Absolute path of the credential for ActiveSync
@property BOOL includeCredentialPassphrase;  // Include credential passphrase in payload?


@end

// 
@interface iPhoneConfigPasscodePayload : iPhoneConfigPayload

@property BOOL alphanumericValueRequired;  // Is the passcode restricted to numbers and letters?
@property NSInteger maximumFailedAttempts;  // The maximum number of failed attempts to authenticate before the data on the device will be erased
@property NSInteger maximumPasscodeAge;  // the maximum age of the passcode, in days
@property NSInteger minimumComplexCharacters;  // the minimum number of non-alpahnumeric characters allowed in the passcode
@property NSInteger minimumPasscodeLength;  // the minimum length of the passcode
@property BOOL passcodeRequired;  // Is a passcode required before using the device?
@property BOOL simpleValueAllowed;  // Is character repetition allowed in the passcode?
@property NSInteger maximumInactivity;  // the device automatically locks when this time period elapses
@property NSInteger requirePINHistory;  // the number of unique passcodes before reuse (0 means any passcode can be reused)
@property iPhoneConfigPasscodeGracePeriods lockGracePeriod;  // the amount of time the device can be locked without prompting for passcode on unlock


@end

// 
@interface iPhoneConfigRestrictionsPayload : iPhoneConfigPayload

@property BOOL explicitContentAllowed;  // Is explicit content allowed?
@property BOOL SafariAllowed;  // Is use of Safari allowed allowed?
@property BOOL YouTubeAllowed;  // Is use of YouTube allowed?
@property BOOL WiFiMusicStoreAllowed;  // Is use of the Wi-Fi Music Store allowed?
@property BOOL installingApplicationsAllowed;  // Is installation of applications allowed?
@property BOOL cameraAllowed;  // Is using the camera allowed?
@property BOOL screenCaptureAllowed;  // Can the device capture its current UI state?
@property BOOL allowAutomaticSyncWhileRoaming;  // Can the device perform background fetches while roaming?
@property BOOL forceEncryptedBackups;  // Should all backups be encrypted?
@property BOOL allowVoiceDialing;  // Can the device use voice dialing?
@property BOOL allowMultiplayerGaming;  // Can the device play multiplayer games with Game Center?
@property BOOL allowAddingGameCenterFriends;  // Can the device add friends in Game Center?
@property BOOL enableSafariAutofill;  // Can Safari use autofill?
@property BOOL forceSafariFraudWarning;  // Force Safari to use fraud warning?
@property BOOL enableSafariJavascript;  // Allow JavaScript in Safari?
@property BOOL enableSafariPopupBlock;  // Should Safari block pop-ups?
@property BOOL allowInAppPurchases;  // Can the device purchase in app content?
@property BOOL allowFacetime;  // Can the device use FaceTime?
@property iPhoneConfigSafariAcceptCookiesType safariAcceptCookies;  // How does Safari accept cookies?
@property iPhoneConfigParentalControlsRegionType parentalControlsRegion;  // What parental controls region are we using?
@property NSInteger allowedMovieRatings;  // Allowed ratings for movies.
@property NSInteger allowedTvShowRatings;  // Allowed ratings for tv shows
@property NSInteger allowedAppRatings;  // Allowed ratings for apps


@end

// 
@interface iPhoneConfigVPNPayload : iPhoneConfigPayload

- (SBElementArray *) VPNOnDemands;

@property (copy) NSString *connectionName;  // the display name of the connection (displayed on the device)
@property iPhoneConfigVPNConnectionTypes connectionType;  // the type of connection enabled by this payload
@property (copy) NSString *serverAddress;  // the hostname or IP address for the server
@property (copy) NSString *username;  // the user account for authenticating the connection
@property iPhoneConfigVPNUserAuthentications userAuthentication;  // the authentication type for the connection
@property (copy) NSString *sharedSecret;  // the shared secret for the connection
@property BOOL sendAllTraffic;  // Route all network traffic through the VPN connection?
@property iPhoneConfigVPNProxyTypes proxyType;  // the proxy type to be used with this VPN connection
@property (copy) NSString *proxyServerAddress;  // the hostname or IP address for the proxy server
@property NSInteger proxyServerPort;  // the port number for the proxy server
@property (copy) NSString *proxyServerUsername;  // the username used to connect to the proxy server
@property (copy) NSString *proxyServerPassword;  // the password used to connect to the proxy server
@property (copy) NSString *proxyServerURL;  // the URL for the proxy server
@property iPhoneConfigVPNEncryptionLevels encryptionLevel;  // the level of data encryption applied to the connection
@property iPhoneConfigVPNMachineAuthenticationTypes machineAuthenticationType;  // the authentication type for the connection
@property (copy) NSString *groupName;  // the group identifier for the connection
@property BOOL useHybridAuthentication;  // Authenticate using secret, name, and server-side certificate?
@property BOOL promptUserForPassword;  // Prompt user for password on the device?
@property (copy) iPhoneConfigCredentialsPayload *authenticationCredential;  // the credential for authenticating the connection
@property BOOL includeUserPIN;  // Request PIN during connection and send with authentication?
@property BOOL enableVPNOnDemand;  // Establish a VPN for specified VPN on Demand domain and host names?


@end

// the domain and host names that will establish a VPN
@interface iPhoneConfigVPNOnDemand : SBObject

@property (copy) NSString *domain;  // the domain or host name
@property iPhoneConfigVPNOnDemandActions action;  // the action taken when this domain or host is requested

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// 
@interface iPhoneConfigWiFiPayload : iPhoneConfigPayload

- (SBElementArray *) trustedServerCertificates;

@property (copy) NSString *serviceSetIdentifier;  // identification of the wireless network
@property BOOL hidden;  // Is this network not open or broadcasting?
@property iPhoneConfigSecurityTypes securityType;  // wireless network encryption to use when connecting
@property (copy) NSString *password;  // the password for the wireless network
@property BOOL acceptEAPSIM;  // Is EAP-SIM an accepted EAP type?
@property BOOL acceptEAPFAST;  // Is EAP-FAST an accepted EAP type?
@property BOOL acceptLEAP;  // Is LEAP an accepted EAP type?
@property BOOL acceptPEAP;  // Is PEAP an accepted EAP type?
@property BOOL acceptTLS;  // Is TLS an accepted EAP type?
@property BOOL acceptTTLS;  // Is TTLS an accepted EAP type?
@property BOOL usePAC;  // Is Protected Access Credential used? ( applies only to EAP-FAST )
@property BOOL provisionPAC;  // Is Protected Access Credential provisioned? ( applies only to EAP-FAST )
@property BOOL provisionPACAnonymously;  // Is Protected Access Credential provisioned anonymously? ( applies only to EAP-FAST )
@property iPhoneConfigInnerAuthentications innerAuthentication;  // authentication protocol ( applies only to TTLS )
@property (copy) NSString *userName;  // user name for connection to wireless network
@property BOOL perConnectionPassword;  // Is the password requested during connection and sent with authentication?
@property (copy) NSString *outerIdentity;  // externally visible identification ( applies to TTLS, PEAP, and EAP-FAST )
@property BOOL allowTrustExceptions;  // Allow trust decisions (via dialog) to be made by the user?


@end

// 
@interface iPhoneConfigTrustedServerCertificate : SBObject

@property (copy) NSString *certificateName;  // name of the trusted certificate

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// 
@interface iPhoneConfigLDAPPayload : iPhoneConfigPayload

- (SBElementArray *) LDAPSearchSettings;

@property (copy) NSString *accountDescription;  // the display name of the account (e.g. "Company LDAP Account")
@property (copy) NSString *userName;  // the username for this LDAP account
@property (copy) NSString *password;  // the password for this LDAP account
@property BOOL useSSL;  // Enable a secure socket layer for this connection?


@end

// 
@interface iPhoneConfigLDAPSearchSetting : SBObject

@property (copy) NSString *searchDescription;  // the description of the search setting
@property (copy) NSString *scope;  // the scope of the search setting
@property (copy) NSString *searchBase;  // the search base of the search setting

- (void) closeSaving:(iPhoneConfigSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// 
@interface iPhoneConfigCalDAVPayload : iPhoneConfigPayload

@property (copy) NSString *accountDescription;  // the display name of the account (e.g. "Company CalDAV Account")
@property (copy) NSString *hostname;  // the hostname or IP address of the CalDAV server
@property (copy) NSString *userName;  // the user name for this CalDAV account
@property (copy) NSString *password;  // the password for this CalDAV account
@property BOOL useSSL;  // Enable a secure socket layer for this connection?
@property NSInteger port;  // the port number of the CalDAV server
@property (copy) NSString *principalURL;  // the Principal URL for this CalDAV account


@end

// 
@interface iPhoneConfigSubscribedCalendarPayload : iPhoneConfigPayload

@property (copy) NSString *calendarDescription;  // the description of this calendar subscription
@property (copy) NSString *url;  // the URL of the calendar file
@property (copy) NSString *userName;  // the user name for this subscription
@property (copy) NSString *password;  // the password for this subscription
@property BOOL useSSL;  // Enable a secure socket layer for this connection?


@end

// 
@interface iPhoneConfigWebClipPayload : iPhoneConfigPayload

@property (copy) NSString *label;  // the name to display for the web clip
@property (copy) NSString *URL;  // the URL to open for the web clip
@property BOOL canRemove;  // Allow removal of the web clip?
@property (copy) NSString *imageFilename;  // Absolute path for an icon file to display for the Web Clip
@property BOOL imagePrecomposed;  // Is icon image precomposed?
@property BOOL fullscreen;  // Is web clip displayed fullscreen?


@end

// 
@interface iPhoneConfigSCEPPayload : iPhoneConfigPayload

@property (copy) NSString *scepServerURL;  // the base URL of the SCEP server
@property (copy) NSString *subject;  // representation of a X.500 name
@property (copy) NSString *instanceName;  // the name of the instance: CA-IDENT
@property (copy) NSString *challenge;  // the pre-shared secret for automatic enrollment
@property NSInteger keySize;  // key size (in bits)
@property BOOL useAsDigitalSignature;  // Can the key be used as a digital signature?
@property BOOL useForKeyEncipherment;  // Can the key be used for key encipherment?
@property (copy) NSString *fingerprint;  // the hex string to be used as a fingerprint
@property (copy) NSString *ntPrincipalName;  // An optional NT Principal name


@end

// 
@interface iPhoneConfigMdmPayload : iPhoneConfigPayload

@property (copy) NSString *serverUrl;  // The URL of the mobile device management server
@property (copy) NSString *checkInUrl;  // The URL the device will use for check in during installation
@property (copy) NSString *topic;  // Push notification topic for management messages
@property BOOL signMessages;  // Sign management messages?
@property BOOL queryGeneralSettings;  // Can the MDM server query general settings?
@property BOOL querySecuritySettings;  // Can the MDM server query security settings?
@property BOOL queryNetworkSettings;  // Can the MDM server query network settings?
@property BOOL queryRestrictions;  // Can the MDM server query restrictions?
@property BOOL queryConfigurationProfiles;  // Can the MDM server query configuration profiles?
@property BOOL queryProvisioningProfiles;  // Can the MDM server query provisioning profiles?
@property BOOL queryApplications;  // Can the MDM server query applications?
@property BOOL modifyConfigurationProfiles;  // Can the MDM server modify configuration profiles?
@property BOOL modifyProvisioningProfiles;  // Can the MDM server modify provisioning profiles?
@property BOOL changeDevicePassword;  // Can the MDM server change the device password?
@property BOOL remoteWipe;  // Can the MDM server remotely wipe the device?
@property BOOL useDevelopmentApns;  // Should the device use the development APNS?
@property (copy) NSString *identityCertificateUuid;  // The UUID of the identity certificate payload


@end

