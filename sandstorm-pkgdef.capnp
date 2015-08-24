@0x82984481f49bd8f5;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "5h13ka55xn93gpenjc29f5kxqpjf5gk4drgx949q4dx7gk968smh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appVersion = 2,  # Increment this for every release.

    appTitle = (defaultText = "Telescope"),

    appMarketingVersion = (defaultText = "0.14.0"),

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Telescope"),
        nounPhrase = (defaultText = "telescope"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
      icons = (
        appGrid = (png = (
          dpi1x = embed "app-graphics/telescope-128.png",
          dpi2x = embed "app-graphics/telescope-256.png"
        )),
        grain = (png = (
          dpi1x = embed "app-graphics/telescope-24.png",
          dpi2x = embed "app-graphics/telescope-48.png"
        )),
        market =  (png = (
          dpi1x = embed "app-graphics/telescope-150.png",
          dpi2x = embed "app-graphics/telescope-300.png"
        )),
      ),

      website = "http://www.telescopeapp.org/",
      codeUrl = "https://github.com/jparyani/Telescope",
      license = (openSource = mit),
      categories = [social],

      author = (
        contactEmail = "jparyani@sandstorm.io",
        pgpSignature = embed "pgp-signature",
        upstreamAuthor = "Sacha Greif & Tom Coleman",
      ),
      pgpKeyring = embed "pgp-keyring",

      description = (defaultText = embed "description.md"),

      screenshots = [
        (width = 448, height = 354, png = embed "sandstorm-screenshot.png")
      ],

      changeLog = (defaultText = embed "History.md"),
    ),
  ),

  sourceMap = (
    # The following directories will be copied into your package.
    searchPath = [
      ( sourcePath = ".meteor-spk/deps" ),
      ( sourcePath = ".meteor-spk/bundle" )
    ]
  ),

  alwaysInclude = [ "." ],
  # This says that we always want to include all files from the source map.
  # (An alternative is to automatically detect dependencies by watching what
  # the app opens while running in dev mode. To see what that looks like,
  # run `spk init` without the -A option.)

  bridgeConfig = (viewInfo = (permissions = [(name = "admin")]))
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "4000", "--", "node", "start.js"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);
