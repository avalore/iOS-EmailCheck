### iOS Email Suggest

Email address' are awkward to type on mobile devices. Your users could be in a taxi, on the bus or even driving whilst using your app. The more you can do to make user input easier and less error prone the better. This class takes a user submitted email address and makes suggestions for common errors (.con instead of .com, gmal.com instead of gmail.com, etc).

![email suggest example](https://s3-eu-west-1.amazonaws.com/louis-harwood/images/email-suggest.png)

## Basic usage

```
    LHEmailCheck *emailCheck = [[LHEmailCheck alloc] init];
    NSString *suggestedEmail = [emailCheck suggestEmail:@"louis.harwood@gmal.com"];
    if (suggestedEmail) {
        //An email suggestion was created
        NSString *suggestMsg = [NSString stringWithFormat:@"Did you mean %@?", suggestedEmail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did you mean?"
                                                        message:suggestMsg
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
```
