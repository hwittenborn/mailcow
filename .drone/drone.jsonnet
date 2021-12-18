local configureAndDeploy() = {
    name: "configure-and-deploy",
    kind: "pipeline",
    type: "docker",
    triggers: {
        branch: ["master"],
        repo: ["hwittenborn/mailcow"]
    },
    volumes: [
        {
            name: "docker-socket",
            host: {path: "/var/run/docker.sock"}
        },

        {
            name: "docker-compose",
            host: {path: "/usr/bin/docker-compose"}
        },

        {
            name: "mailcow",
            host: {path: "/var/www/mailcow.hunterwittenborn.com"}
        },

        {
            name: "lets-encrypt",
            host: {path: "/etc/letsencrypt/live/hunterwittenborn.com"}
        }
    ],

    steps: [
        {
            name: "configure",
            image: "ubuntu:20.04",
            environment: {
                mailcow_db_user_password: {from_secret: "mailcow_db_user_password"},
                mailcow_db_root_password: {from_secret: "mailcow_db_root_password"}
            },
            commands: [
                ".drone/scripts/configure.sh"
            ]
        },

        {
            name: "deploy",
            image: "ubuntu:20.04",
            volumes: [
                {
                    name: "docker-socket",
                    path: "/var/run/docker.sock"
                },

                {
                    name: "docker-compose",
                    path: "/usr/bin/docker-compose"
                },

                {
                    name: "mailcow",
                    path: "/var/www/mailcow.hunterwittenborn.com"
                },

                {
                    name: "lets-encrypt",
                    path: "/etc/letsencrypt/live/hunterwittenborn.com"
                }
            ],
            commands: [
                ".drone/scripts/deploy.sh"
            ]
        }
    ]
};

[configureAndDeploy()]
