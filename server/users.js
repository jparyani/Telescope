Accounts.onCreateUser(function(options, user){

  // ------------------------------ Properties ------------------------------ //

  user.username = options.profile.name;
  var userProperties = {
    profile: options.profile || {},
    karma: 0,
    isInvited: false,
    postCount: 0,
    commentCount: 0,
    invitedCount: 0,
    votes: {
      upvotedPosts: [],
      downvotedPosts: [],
      upvotedComments: [],
      downvotedComments: []
    }
  };
  user = _.extend(user, userProperties);

  // set email on profile
  if (options.email)
    user.profile.email = options.email;

  // if email is set, use it to generate email hash
  if (getEmail(user))
    user.email_hash = getEmailHash(user);

  // set username on profile
  if (!user.profile.name)
    user.profile.name = user.username;

  // set notifications default preferences
  user.profile.notifications = {
    users: false,
    posts: false,
    comments: true,
    replies: true
  };

  // create slug from username
  user.slug = slugify(getUserName(user));

  if (_.contains(user.services.sandstorm.permissions, 'admin'))
    user.isAdmin = true;

  // give new users a few invites (default to 3)
  user.inviteCount = getSetting('startInvitesCount', 3);

  // ------------------------------ Callbacks ------------------------------ //

  // run all post submit client callbacks on properties object successively
  clog('// Start userCreatedCallbacks')
  user = userCreatedCallbacks.reduce(function(result, currentFunction) {
    clog('// Running '+currentFunction.name+'…')
    return currentFunction(result);
  }, user);
  clog('// Finished userCreatedCallbacks')
  clog('// User object:')
  clog(user)

  // ------------------------------ Analytics ------------------------------ //

  trackEvent('new user', {username: user.username, email: user.profile.email});

  return user;
});


Meteor.methods({
  changeEmail: function (newEmail) {
    Meteor.users.update(
      Meteor.userId(),
      {$set: {
          emails: [{address: newEmail}],
          email_hash: Gravatar.hash(newEmail),
          // Just in case this gets called from somewhere other than /client/views/users/user_edit.js
          "profile.email": newEmail
        }
      }
    );
  },
  numberOfPostsToday: function(){
    console.log(numberOfItemsInPast24Hours(Meteor.user(), Posts));
  },
  numberOfCommentsToday: function(){
    console.log(numberOfItemsInPast24Hours(Meteor.user(), Comments));
  },
  testBuffer: function(){
    // TODO
  },
  getScoreDiff: function(id){
    var object = Posts.findOne(id);
    var baseScore = object.baseScore;
    var ageInHours = (new Date().getTime() - object.submitted) / (60 * 60 * 1000);
    var newScore = baseScore / Math.pow(ageInHours + 2, 1.3);
    return Math.abs(object.score - newScore);
  }
});
