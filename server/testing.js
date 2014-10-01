var isTesting = Meteor.settings && Meteor.settings.isTesting;

if (isTesting) {
  console.log('Adding login functions');
  Meteor.methods({
    // login from client with Meteor.call('loginTest', function(err, res) {  Meteor.loginWithToken(res, function() {}); })
    loginTest: function() {
      var login, token;
      Meteor.users.remove({});
      login = Accounts.updateOrCreateUserFromExternalService("sandstorm", {
        id: 0,
        permissions: ['admin']
      }, {
        profile: {
          name: 'Test Admin'
        }
      });
      console.log(login);
      token = Accounts._generateStampedLoginToken();
      Accounts._insertLoginToken(login.userId, token);
      return token.token;
    }
  });
}
