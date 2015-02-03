@0xf68b5b5e36e37dc0;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "gw9gydmpzp219atj89j0czxp2p2ph1jhefacvarfp4t5pmahx17h",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appVersion = 0,  # Increment this for every release.

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Televote Instance"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.
  ),

  sourceMap = (
    # The following directories will be copied into your package.
    searchPath = [
      ( sourcePath = ".meteor-spk/deps" ),
      ( sourcePath = ".meteor-spk/bundle" ),
      ( sourcePath = "/usr/local/lib/libkj-0.6-dev.so", packagePath = "usr/lib/libkj-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libkj-async-0.6-dev.so", packagePath = "usr/lib/libkj-async-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnp-0.6-dev.so", packagePath = "usr/lib/libcapnp-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnpc-0.6-dev.so", packagePath = "usr/lib/libcapnpc-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnp-rpc-0.6-dev.so", packagePath = "usr/lib/libcapnp-rpc-0.6-dev.so" ),
      ( sourcePath = "/opt/sandstorm/latest/usr/include", packagePath = "usr/include" )
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
