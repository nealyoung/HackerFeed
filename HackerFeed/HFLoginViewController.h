@import UIKit;

#import "libHN.h"
#import "HFBorderedButton.h"

@class HFLoginViewController;

@protocol HFLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(HFLoginViewController *)loginViewController didLoginWithUser:(HNUser *)user;

@end

@interface HFLoginViewController : UIViewController

@property (weak) id <HFLoginViewControllerDelegate> delegate;

@property UITextField *usernameTextField;
@property UITextField *passwordTextField;
@property UILabel *securityLabel;
@property HFBorderedButton *submitButton;

@end
